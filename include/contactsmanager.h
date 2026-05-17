#ifndef CONTACTSMANAGER_H
#define CONTACTSMANAGER_H

#include <QObject>
#include <QVariantList>

class ContactsManager : public QObject
{
    Q_OBJECT
public:
    explicit ContactsManager(QObject *parent = nullptr);

    Q_INVOKABLE QVariantList listContact();

    Q_INVOKABLE bool addContact(const QString &nom,
                                const QString &prenom,
                                const QString &email,
                                const QString &localite,
                                const QString &organisation,
                                const QString &telephone);
};

#endif