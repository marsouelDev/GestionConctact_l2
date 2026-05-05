#include <QApplication>
#include <QtSql>
#include <QDebug>
#include"mainwindow.h"
#include"dataBases/database.h"

int main(int argc, char *argv[])
{
 QApplication a(argc, argv);
    Database::init();
    MainWindow w;
    w.show();
    return a.exec();
}