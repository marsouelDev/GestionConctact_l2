#include "database.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

QSqlDatabase Database::getDB()
{
    return QSqlDatabase::database("manager_connection");
}

bool Database::init()
{
    if (QSqlDatabase::contains("manager_connection")) {
        return true;
    }

    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE", "manager_connection");
    db.setDatabaseName("Manager_contact.db");

    if (!db.open()) {
        qDebug() << "Erreur DB:" << db.lastError().text();
        return false;
    }

    QSqlQuery query(db);

    //  Activer les clés étrangères SQLite
    query.exec("PRAGMA foreign_keys = ON");

    // ================= TABLE CONTACT =================
    if (!query.exec(R"(
        CREATE TABLE IF NOT EXISTS Contact (
            ID_Contact INTEGER PRIMARY KEY AUTOINCREMENT,
            Image TEXT,
            Nom TEXT,
            Prenom TEXT,
            Email TEXT,
            Localite TEXT,
            Organisation TEXT
        )
    )")) {
        qDebug() << "Erreur CREATE Contact:" << query.lastError().text();
    }

    // ================= TABLE TYPE TELEPHONE =================
    if (!query.exec(R"(
        CREATE TABLE IF NOT EXISTS TypeTelephone (
            ID_Type INTEGER PRIMARY KEY AUTOINCREMENT,
            libelle TEXT UNIQUE
        )
    )")) {
        qDebug() << "Erreur CREATE TypeTelephone:" << query.lastError().text();
    }

    // ================= TABLE TELEPHONE =================
    if (!query.exec(R"(
        CREATE TABLE IF NOT EXISTS Telephone (
            ID_Tel INTEGER PRIMARY KEY AUTOINCREMENT,
            Numero TEXT,
            ID_Type INTEGER,
            ID_Contact INTEGER,
            FOREIGN KEY(ID_Type) REFERENCES TypeTelephone(ID_Type),
            FOREIGN KEY(ID_Contact) REFERENCES Contact(ID_Contact)
        )
    )")) {
        qDebug() << "Erreur CREATE Telephone:" << query.lastError().text();
    }

    qDebug() << "Database initialisée avec succès";
    return true;
}