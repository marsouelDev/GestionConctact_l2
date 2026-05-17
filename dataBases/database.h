#ifndef DATABASE_H
#define DATABASE_H

#include <QSqlDatabase>

class Database
{
public:
    static bool init();
    static QSqlDatabase getDB();
};

#endif