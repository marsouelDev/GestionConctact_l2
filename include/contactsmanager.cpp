#include "contactsmanager.h"
#include "database.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

ContactsManager::ContactsManager(QObject *parent)
    : QObject(parent)
{
    // Migration : ajoute la colonne Favori si elle n'existe pas encore
    QSqlQuery q(Database::getDB());
    q.exec("ALTER TABLE Contact ADD COLUMN Favori INTEGER DEFAULT 0");

    // S'assurer que les foreign keys sont activées à chaque démarrage
    q.exec("PRAGMA foreign_keys = ON");
}

// ═══════════════════════════════════════════════════════════════
//  FONCTION UTILITAIRE : récupérer tous les téléphones d'un contact
// ═══════════════════════════════════════════════════════════════
static QVariantList getTelephonesForContact(int idContact)
{
    QVariantList telephones;
    QSqlQuery q(Database::getDB());
    q.prepare(
        "SELECT t.Numero, t.ID_Type, tt.libelle "
        "FROM Telephone t "
        "LEFT JOIN TypeTelephone tt ON t.ID_Type = tt.ID_Type "
        "WHERE t.ID_Contact = ? "
        "ORDER BY t.ID_Tel ASC"
        );
    q.addBindValue(idContact);

    if (q.exec()) {
        while (q.next()) {
            QVariantMap tel;
            tel["numero"]  = q.value("Numero").toString();
            tel["type"]    = q.value("ID_Type").toInt();
            tel["libelle"] = q.value("libelle").toString();
            telephones.append(tel);
        }
    } else {
        qDebug() << "Erreur getTelephonesForContact:" << q.lastError().text();
    }
    return telephones;
}

// ═══════════════════════════════════════════════════════════════
//  LISTE DE TOUS LES CONTACTS
// ═══════════════════════════════════════════════════════════════
QVariantList ContactsManager::listContact()
{
    QVariantList list;
    QSqlQuery query(Database::getDB());

    if (!query.exec(
            "SELECT ID_Contact, Nom, Prenom, Email, "
            "       Localite, Organisation, Favori "
            "FROM Contact "
            "ORDER BY ID_Contact DESC"
            ))
    {
        qDebug() << "Erreur SELECT listContact:" << query.lastError().text();
        return list;
    }

    while (query.next()) {
        QVariantMap c;
        int id = query.value("ID_Contact").toInt();

        c["id"]           = id;
        c["nom"]          = query.value("Nom").toString();
        c["prenom"]       = query.value("Prenom").toString();
        c["email"]        = query.value("Email").toString();
        c["localite"]     = query.value("Localite").toString();
        c["organisation"] = query.value("Organisation").toString();
        c["favori"]       = query.value("Favori").toBool();

        // Récupérer TOUS les téléphones de CE contact
        QVariantList telephones = getTelephonesForContact(id);
        c["telephones"] = telephones;

        // Premier téléphone pour compatibilité (affichage rapide)
        if (!telephones.isEmpty()) {
            QVariantMap first = telephones.first().toMap();
            c["telephone"] = first.value("numero").toString();
        } else {
            c["telephone"] = "";
        }

        list.append(c);
    }
    return list;
}

// ═══════════════════════════════════════════════════════════════
//  AJOUTER UN CONTACT (avec plusieurs téléphones)
// ═══════════════════════════════════════════════════════════════
bool ContactsManager::addContact(const QString &nom,
                                 const QString &prenom,
                                 const QString &email,
                                 const QString &localite,
                                 const QString &organisation,
                                 const QVariantList &telephones)
{
    QSqlDatabase db = Database::getDB();

    if (!db.isOpen()) {
        qDebug() << "Database fermée";
        return false;
    }

    db.transaction();

    // ================= INSERT CONTACT =================
    QSqlQuery query(db);
    query.prepare(R"(
        INSERT INTO Contact
        (Nom, Prenom, Email, Localite, Organisation)
        VALUES (?, ?, ?, ?, ?)
    )");
    query.addBindValue(nom);
    query.addBindValue(prenom);
    query.addBindValue(email);
    query.addBindValue(localite);
    query.addBindValue(organisation);

    if (!query.exec()) {
        qDebug() << "Erreur INSERT Contact:" << query.lastError().text();
        db.rollback();
        return false;
    }

    int idContact = query.lastInsertId().toInt();

    // ================= INSERT TOUS LES TELEPHONES =================
    for (const QVariant &item : telephones) {
        QVariantMap tel = item.toMap();

        QString numero = tel["numero"].toString();
        int typeId     = tel.value("type", 1).toInt();

        if (numero.trimmed().isEmpty())
            continue;

        QSqlQuery telQuery(db);
        telQuery.prepare(R"(
            INSERT INTO Telephone (Numero, ID_Type, ID_Contact)
            VALUES (?, ?, ?)
        )");
        telQuery.addBindValue(numero);
        telQuery.addBindValue(typeId);
        telQuery.addBindValue(idContact);

        if (!telQuery.exec()) {
            qDebug() << "Erreur INSERT Telephone:" << telQuery.lastError().text();
            db.rollback();
            return false;
        }
    }

    db.commit();
    emit contactsChanged();
    qDebug() << "Contact ajouté avec succès, id=" << idContact
             << ", nb téléphones=" << telephones.size();
    return true;
}

// ═══════════════════════════════════════════════════════════════
//  OBTENIR UN CONTACT PAR ID (avec tous ses téléphones)
// ═══════════════════════════════════════════════════════════════
QVariantMap ContactsManager::getContactById(int id)
{
    QVariantMap c;
    QSqlQuery query(Database::getDB());

    query.prepare(
        "SELECT ID_Contact, Nom, Prenom, Email, "
        "       Localite, Organisation, Favori "
        "FROM Contact "
        "WHERE ID_Contact = ?"
        );
    query.addBindValue(id);

    if (!query.exec()) {
        qDebug() << "Erreur getContactById:" << query.lastError().text();
        return c;
    }

    if (query.next()) {
        c["id"]           = query.value("ID_Contact").toInt();
        c["nom"]          = query.value("Nom").toString();
        c["prenom"]       = query.value("Prenom").toString();
        c["email"]        = query.value("Email").toString();
        c["localite"]     = query.value("Localite").toString();
        c["organisation"] = query.value("Organisation").toString();
        c["favori"]       = query.value("Favori").toBool();

        // Récupérer TOUS les téléphones
        QVariantList telephones = getTelephonesForContact(id);
        c["telephones"] = telephones;

        if (!telephones.isEmpty()) {
            QVariantMap first = telephones.first().toMap();
            c["telephone"] = first.value("numero").toString();
        } else {
            c["telephone"] = "";
        }
    } else {
        qDebug() << "getContactById: aucun contact avec id=" << id;
    }

    return c;
}

// ═══════════════════════════════════════════════════════════════
//  MODIFIER UN CONTACT (avec gestion de plusieurs téléphones)
// ═══════════════════════════════════════════════════════════════
bool ContactsManager::updateContact(int id,
                                    const QString &nom,
                                    const QString &prenom,
                                    const QString &email,
                                    const QString &localite,
                                    const QString &organisation,
                                    const QVariantList &telephones)
{
    QSqlDatabase db = Database::getDB();
    db.transaction();

    // 1. METTRE À JOUR LE CONTACT
    QSqlQuery query(db);
    query.prepare(R"(
        UPDATE Contact
        SET Nom=?, Prenom=?, Email=?, Localite=?, Organisation=?
        WHERE ID_Contact=?
    )");
    query.addBindValue(nom);
    query.addBindValue(prenom);
    query.addBindValue(email);
    query.addBindValue(localite);
    query.addBindValue(organisation);
    query.addBindValue(id);

    if (!query.exec()) {
        qDebug() << "Erreur UPDATE Contact:" << query.lastError().text();
        db.rollback();
        return false;
    }

    // 2. SUPPRIMER TOUS LES ANCIENS TÉLÉPHONES
    QSqlQuery delTel(db);
    delTel.prepare("DELETE FROM Telephone WHERE ID_Contact = ?");
    delTel.addBindValue(id);
    if (!delTel.exec()) {
        qDebug() << "Erreur DELETE old telephones:" << delTel.lastError().text();
        db.rollback();
        return false;
    }

    // 3. RÉINSÉRER TOUS LES NOUVEAUX TÉLÉPHONES
    for (const QVariant &item : telephones) {
        QVariantMap tel = item.toMap();
        QString numero = tel["numero"].toString();
        int typeId     = tel.value("type", 1).toInt();

        if (numero.trimmed().isEmpty())
            continue;

        QSqlQuery insTel(db);
        insTel.prepare(R"(
            INSERT INTO Telephone (Numero, ID_Type, ID_Contact)
            VALUES (?, ?, ?)
        )");
        insTel.addBindValue(numero);
        insTel.addBindValue(typeId);
        insTel.addBindValue(id);

        if (!insTel.exec()) {
            qDebug() << "Erreur INSERT nouveau telephone:" << insTel.lastError().text();
            db.rollback();
            return false;
        }
    }

    db.commit();
    emit contactsChanged();
    return true;
}

// ═══════════════════════════════════════════════════════════════
//  ✅ SUPPRIMER UN CONTACT (CORRIGÉ : supprime d'abord les téléphones)
// ═══════════════════════════════════════════════════════════════
bool ContactsManager::deleteContact(int id)
{
    QSqlDatabase db = Database::getDB();

    // ✅ Démarrer une transaction pour garantir l'intégrité
    if (!db.transaction()) {
        qDebug() << "Erreur début transaction:" << db.lastError().text();
        return false;
    }

    // ✅ ÉTAPE 1 : Supprimer d'abord tous les téléphones liés au contact
    QSqlQuery delTel(db);
    delTel.prepare("DELETE FROM Telephone WHERE ID_Contact = ?");
    delTel.addBindValue(id);

    if (!delTel.exec()) {
        qDebug() << "Erreur DELETE telephones:" << delTel.lastError().text();
        db.rollback();
        return false;
    }

    int nbTelSupprimes = delTel.numRowsAffected();
    qDebug() << "✅" << nbTelSupprimes << "téléphone(s) supprimé(s) pour le contact" << id;

    // ✅ ÉTAPE 2 : Supprimer le contact
    QSqlQuery delContact(db);
    delContact.prepare("DELETE FROM Contact WHERE ID_Contact = ?");
    delContact.addBindValue(id);

    if (!delContact.exec()) {
        qDebug() << "Erreur DELETE Contact:" << delContact.lastError().text();
        db.rollback();
        return false;
    }

    if (delContact.numRowsAffected() == 0) {
        qDebug() << "❌ Contact non trouvé, id=" << id;
        db.rollback();
        return false;
    }

    // ✅ Valider la transaction
    if (!db.commit()) {
        qDebug() << "Erreur commit:" << db.lastError().text();
        db.rollback();
        return false;
    }

    qDebug() << "✅ Contact" << id << "supprimé avec succès";
    emit contactsChanged();
    return true;
}

// ═══════════════════════════════════════════════════════════════
//  TOGGLE FAVORI
// ═══════════════════════════════════════════════════════════════
bool ContactsManager::setFavori(int id, bool favori)
{
    QSqlQuery query(Database::getDB());
    query.prepare("UPDATE Contact SET Favori = ? WHERE ID_Contact = ?");
    query.addBindValue(favori ? 1 : 0);
    query.addBindValue(id);

    if (!query.exec()) {
        qDebug() << "Erreur setFavori:" << query.lastError().text();
        return false;
    }

    emit favorisChanged();
    emit contactsChanged();
    return true;
}

// ═══════════════════════════════════════════════════════════════
//  LISTE DES FAVORIS (avec tous les téléphones)
// ═══════════════════════════════════════════════════════════════
QVariantList ContactsManager::getFavoris()
{
    QVariantList list;
    QSqlQuery query(Database::getDB());

    if (!query.exec(
            "SELECT ID_Contact, Nom, Prenom, Email, "
            "       Localite, Organisation "
            "FROM Contact "
            "WHERE Favori = 1 "
            "ORDER BY Nom, Prenom"))
    {
        qDebug() << "Erreur getFavoris:" << query.lastError().text();
        return list;
    }

    while (query.next()) {
        QVariantMap c;
        int id = query.value("ID_Contact").toInt();

        c["id"]           = id;
        c["nom"]          = query.value("Nom").toString();
        c["prenom"]       = query.value("Prenom").toString();
        c["email"]        = query.value("Email").toString();
        c["localite"]     = query.value("Localite").toString();
        c["organisation"] = query.value("Organisation").toString();
        c["favori"]       = true;

        QVariantList telephones = getTelephonesForContact(id);
        c["telephones"] = telephones;

        if (!telephones.isEmpty()) {
            QVariantMap first = telephones.first().toMap();
            c["telephone"] = first.value("numero").toString();
        } else {
            c["telephone"] = "";
        }

        list.append(c);
    }
    return list;
}