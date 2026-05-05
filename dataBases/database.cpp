#include "database.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

static QSqlDatabase db ;

void Database::init()
{
db= QSqlDatabase::addDatabase("QSQLITE");
db.setDatabaseName("Manager_contact.db");

if (!db.open()) {
    qDebug() << "Erreur DB:" << db.lastError();
    return;
}

    QSqlQuery query;


    query.exec("CREATE TABLE IF NOT EXISTS Contact ("
               "ID_Contact INTEGER PRIMARY KEY AUTOINCREMENT, "
               "Image TEXT, "
               "Nom TEXT, "
               "Prenom TEXT, "
               "Email TEXT, "
               "Localite TEXT, "
               "Organisation TEXT"
               ")");

    query.exec("CREATE TABLE IF NOT EXISTS TypeTelephone ("
               "ID_Type INTEGER PRIMARY KEY AUTOINCREMENT, "
               "libelle TEXT UNIQUE"
               ")");

    query.exec("CREATE TABLE IF NOT EXISTS Telephone ("
               "ID_Tel INTEGER PRIMARY KEY AUTOINCREMENT, "
               "Numero TEXT, "
               "ID_Type INTEGER, "
               "ID_Contact INTEGER, "
               "FOREIGN KEY(ID_Type) REFERENCES TypeTelephone(ID_Type), "
               "FOREIGN KEY(ID_Contact) REFERENCES Contact(ID_Contact)"
               ")");
}
QSqlDatabase Database::getDB()

{
return db;
}