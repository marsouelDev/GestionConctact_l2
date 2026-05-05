#ifndef DATABASE_H
#define DATABASE_H
#include <QSqlDatabase>

class Database{
public:
    static void init();
    static QSqlDatabase getDB();

};

#endif // DATABASE_H
