#include "contactsmanager.h"
#include "database.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

ContactsManager::ContactsManager(QObject *parent)
    : QObject(parent)
{
    // Migration : ajoute la colonne Favori si elle n'existe pas encore
    // SQLite ignore silencieusement si elle existe déjà — aucun risque.
    QSqlQuery q(Database::getDB());
    q.exec("ALTER TABLE Contact ADD COLUMN Favori INTEGER DEFAULT 0");
}

// ===================== LISTE CONTACTS =====================
QVariantList ContactsManager::listContact()
{
    QVariantList list;
    QSqlQuery query(Database::getDB());

    // On joint Telephone pour récupérer le numéro en même temps
    if (!query.exec(
            "SELECT c.ID_Contact, c.Nom, c.Prenom, c.Email, "
            "       c.Localite, c.Organisation, c.Favori, "
            "       t.Numero AS telephone "
            "FROM Contact c "
            "LEFT JOIN Telephone t ON t.ID_Contact = c.ID_Contact "
            "ORDER BY c.Nom, c.Prenom"))
    {
        qDebug() << "Erreur SELECT:" << query.lastError().text();
        return list;
    }

    while (query.next()) {
        QVariantMap c;
        c["id"]           = query.value("ID_Contact");
        c["nom"]          = query.value("Nom");
        c["prenom"]       = query.value("Prenom");
        c["email"]        = query.value("Email");
        c["localite"]     = query.value("Localite");
        c["organisation"] = query.value("Organisation");
        c["telephone"]    = query.value("telephone");
        c["favori"]       = query.value("Favori").toBool();
        list.append(c);
    }
    return list;
}

// ===================== AJOUT CONTACT =====================
bool ContactsManager::addContact(const QString &nom,
                                 const QString &prenom,
                                 const QString &email,
                                 const QString &localite,
                                 const QString &organisation,
                                 const QString &telephone)
{
    QSqlQuery query(Database::getDB());

    // 1. INSÉRER CONTACT
    query.prepare(R"(
        INSERT INTO Contact (Nom, Prenom, Email, Localite, Organisation, Favori)
        VALUES (?, ?, ?, ?, ?, 1)
    )");
    query.addBindValue(nom);
    query.addBindValue(prenom);
    query.addBindValue(email);
    query.addBindValue(localite);
    query.addBindValue(organisation);

    if (!query.exec()) {
        qDebug() << "Erreur INSERT Contact:" << query.lastError().text();
        return false;
    }

    // 2. RÉCUPÉRER L'ID DU CONTACT
    int idContact = query.lastInsertId().toInt();

    // 3. INSÉRER TÉLÉPHONE
    QSqlQuery telQuery(Database::getDB());
    telQuery.prepare(R"(
        INSERT INTO Telephone (Numero, ID_Type, ID_Contact)
        VALUES (?, 1, ?)
    )");
    telQuery.addBindValue(telephone);
    telQuery.addBindValue(idContact);

    if (!telQuery.exec()) {
        qDebug() << "Erreur INSERT Telephone:" << telQuery.lastError().text();
        return false;
    }

    emit contactsChanged();
    return true;
}

// ===================== OBTENIR UN CONTACT PAR ID =====================
QVariantMap ContactsManager::getContactById(int id)
{
    QVariantMap c;
    QSqlQuery query(Database::getDB());

    query.prepare(
        "SELECT c.ID_Contact, c.Nom, c.Prenom, c.Email, "
        "       c.Localite, c.Organisation, c.Favori, "
        "       t.Numero AS telephone "
        "FROM Contact c "
        "LEFT JOIN Telephone t ON t.ID_Contact = c.ID_Contact "
        "WHERE c.ID_Contact = ?"
        );
    query.addBindValue(id);

    if (!query.exec()) {
        qDebug() << "Erreur getContactById:" << query.lastError().text();
        return c;
    }

    if (query.next()) {
        c["id"]           = query.value("ID_Contact");
        c["nom"]          = query.value("Nom");
        c["prenom"]       = query.value("Prenom");
        c["email"]        = query.value("Email");
        c["localite"]     = query.value("Localite");
        c["organisation"] = query.value("Organisation");
        c["telephone"]    = query.value("telephone");
        c["favori"]       = query.value("Favori").toBool();
    } else {
        qDebug() << "getContactById: aucun contact avec id=" << id;
    }

    return c;
}

// ===================== MODIFIER UN CONTACT =====================
bool ContactsManager::updateContact(int id,
                                    const QString &nom,
                                    const QString &prenom,
                                    const QString &email,
                                    const QString &localite,
                                    const QString &organisation,
                                    const QString &telephone)
{
    QSqlQuery query(Database::getDB());

    // 1. METTRE À JOUR LA TABLE Contact
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
        return false;
    }

    // 2. METTRE À JOUR LE TÉLÉPHONE
    //    Si un enregistrement existe → UPDATE, sinon → INSERT
    QSqlQuery checkTel(Database::getDB());
    checkTel.prepare("SELECT COUNT(*) FROM Telephone WHERE ID_Contact = ?");
    checkTel.addBindValue(id);
    checkTel.exec();
    checkTel.next();
    int count = checkTel.value(0).toInt();

    QSqlQuery telQuery(Database::getDB());
    if (count > 0) {
        telQuery.prepare(R"(
            UPDATE Telephone SET Numero=?
            WHERE ID_Contact=?
        )");
        telQuery.addBindValue(telephone);
        telQuery.addBindValue(id);
    } else {
        telQuery.prepare(R"(
            INSERT INTO Telephone (Numero, ID_Type, ID_Contact)
            VALUES (?, 1, ?)
        )");
        telQuery.addBindValue(telephone);
        telQuery.addBindValue(id);
    }

    if (!telQuery.exec()) {
        qDebug() << "Erreur UPDATE/INSERT Telephone:" << telQuery.lastError().text();
        return false;
    }

    emit contactsChanged();
    return true;
}

// ===================== SUPPRIMER UN CONTACT =====================
bool ContactsManager::deleteContact(int id)
{
    // 1. SUPPRIMER LE TÉLÉPHONE D'ABORD (contrainte de clé étrangère)
    QSqlQuery telQuery(Database::getDB());
    telQuery.prepare("DELETE FROM Telephone WHERE ID_Contact = ?");
    telQuery.addBindValue(id);

    if (!telQuery.exec()) {
        qDebug() << "Erreur DELETE Telephone:" << telQuery.lastError().text();
        return false;
    }

    // 2. SUPPRIMER LE CONTACT
    QSqlQuery query(Database::getDB());
    query.prepare("DELETE FROM Contact WHERE ID_Contact = ?");
    query.addBindValue(id);

    if (!query.exec()) {
        qDebug() << "Erreur DELETE Contact:" << query.lastError().text();
        return false;
    }

    emit contactsChanged();
    return true;
}

// ===================== TOGGLE FAVORI =====================
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

// ===================== LISTE DES FAVORIS =====================
QVariantList ContactsManager::getFavoris()
{
    QVariantList list;
    QSqlQuery query(Database::getDB());

    if (!query.exec(
            "SELECT c.ID_Contact, c.Nom, c.Prenom, c.Email, "
            "       c.Localite, c.Organisation, "
            "       t.Numero AS telephone "
            "FROM Contact c "
            "LEFT JOIN Telephone t ON t.ID_Contact = c.ID_Contact "
            "WHERE c.Favori = 1 "
            "ORDER BY c.Nom, c.Prenom"))
    {
        qDebug() << "Erreur getFavoris:" << query.lastError().text();
        return list;
    }

    while (query.next()) {
        QVariantMap c;
        c["id"]           = query.value("ID_Contact");
        c["nom"]          = query.value("Nom");
        c["prenom"]       = query.value("Prenom");
        c["email"]        = query.value("Email");
        c["localite"]     = query.value("Localite");
        c["organisation"] = query.value("Organisation");
        c["telephone"]    = query.value("telephone");
        c["favori"]       = true;
        list.append(c);
    }
    return list;
}