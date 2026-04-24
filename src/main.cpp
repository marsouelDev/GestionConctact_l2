#include <QApplication>
#include <QtSql>
#include <QDebug>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    // 1. Créer connexion SQLite
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("Manager_contact.db");

    // 2. Ouvrir base
    if (db.open()) {
        qDebug() << " SQLite fonctionne ! Connexion réussie";
    } else {
        qDebug() << " Erreur SQLite :" << db.lastError().text();
    }

    return a.exec();
}