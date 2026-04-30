#include <QApplication>
#include <QtSql>
#include <QDebug>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("Manager_contact.db");

    if (db.open()) {
        qDebug() << "SQLite fonctionne ! Connexion réussie";

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

        if (query.lastError().isValid()) {
            qDebug() << "Erreur SQL :" << query.lastError().text();
        } else {
            qDebug() << "Tables créées avec succès";
        }

    } else {
        qDebug() << "Erreur SQLite :" << db.lastError().text();
    }

    return a.exec();
}