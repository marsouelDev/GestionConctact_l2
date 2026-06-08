#ifndef CONTACTSMANAGER_H
#define CONTACTSMANAGER_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>

class ContactsManager : public QObject
{
    Q_OBJECT

public:
    explicit ContactsManager(QObject *parent = nullptr);

    Q_INVOKABLE QVariantList listContact();
    Q_INVOKABLE QVariantMap  getContactById(int id);

    Q_INVOKABLE bool addContact(const QString &nom,
                                const QString &prenom,
                                const QString &email,
                                const QString &localite,
                                const QString &organisation,
                                const QVariantList &telephones);

    //  SIGNATURE MODIFIÉE : accepte maintenant une liste de téléphones
    Q_INVOKABLE bool updateContact(int id,
                                   const QString &nom,
                                   const QString &prenom,
                                   const QString &email,
                                   const QString &localite,
                                   const QString &organisation,
                                   const QVariantList &telephones);

    Q_INVOKABLE bool deleteContact(int id);
    Q_INVOKABLE bool setFavori(int id, bool favori);
    Q_INVOKABLE QVariantList getFavoris();

signals:
    void contactsChanged();
    void favorisChanged();
};

#endif // CONTACTSMANAGER_H