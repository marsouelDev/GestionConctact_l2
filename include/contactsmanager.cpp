#include "contactsmanager.h"
#include "database.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

ContactsManager::ContactsManager(QObject *parent)
    : QObject(parent)
{}
// ===================== LISTE CONTACTS =====================
QVariantList ContactsManager::listContact()
{
    QVariantList list;

    QSqlQuery query((Database::getDB()));

    if (!query.exec("SELECT * FROM Contact")) {
        qDebug() << "Erreur SELECT:" << query.lastError().text();
        return list;
    }

    while (query.next()) {
        QVariantMap c;

        c["id"] = query.value("ID_Contact");
        c["nom"] = query.value("Nom");
        c["prenom"] = query.value("Prenom");
        c["email"] = query.value("Email");
        c["localite"] = query.value("Localite");
        c["organisation"] = query.value("Organisation");

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
    QSqlQuery query((Database::getDB()));

    // 1. INSÉRER CONTACT
    query.prepare(R"(
        INSERT INTO Contact (Nom, Prenom, Email, Localite, Organisation)
        VALUES (?, ?, ?, ?, ?)
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

    // 2. RECUPERER ID DU CONTACT
    int idContact = query.lastInsertId().toInt();

    // 3. INSÉRER TELEPHONE
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

    return true;
}
