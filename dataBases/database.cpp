#include "database.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

QSqlDatabase Database::getDB()
{
    QSqlDatabase db = QSqlDatabase::database("manager_connection");
    //  S'assurer que foreign_keys est actif sur cette connexion
    if (db.isOpen()) {
        QSqlQuery q(db);
        q.exec("PRAGMA foreign_keys = ON");
    }
    return db;
}

bool Database::init()
{
    if (QSqlDatabase::contains("manager_connection")) {
        //  Réactiver les foreign keys même si la connexion existe déjà
        QSqlDatabase db = QSqlDatabase::database("manager_connection");
        if (db.isOpen()) {
            QSqlQuery q(db);
            q.exec("PRAGMA foreign_keys = ON");
        }
        return true;
    }

    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE", "manager_connection");
    db.setDatabaseName("Manager_contact.db");

    if (!db.open()) {
        qDebug() << "Erreur DB:" << db.lastError().text();
        return false;
    }

    QSqlQuery query(db);
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
            Organisation TEXT,
            Favori INTEGER DEFAULT 0
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
            FOREIGN KEY(ID_Contact) REFERENCES Contact(ID_Contact) ON DELETE CASCADE
        )
    )")) {
        qDebug() << "Erreur CREATE Telephone:" << query.lastError().text();
    }

    // ================= TYPES PAR DÉFAUT =================
    query.exec("INSERT OR IGNORE INTO TypeTelephone (ID_Type, libelle) VALUES (1, 'Mobile')");
    query.exec("INSERT OR IGNORE INTO TypeTelephone (ID_Type, libelle) VALUES (2, 'WhatsApp')");
    query.exec("INSERT OR IGNORE INTO TypeTelephone (ID_Type, libelle) VALUES (3, 'Maison')");
    query.exec("INSERT OR IGNORE INTO TypeTelephone (ID_Type, libelle) VALUES (4, 'Bureau')");

    qDebug() << "Database initialisée avec succès";
    return true;
}