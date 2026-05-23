#ifndef CONTACTSMANAGER_H
#define CONTACTSMANAGER_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

class ContactsManager : public QObject
{
    Q_OBJECT

public:
    explicit ContactsManager(QObject *parent = nullptr);

    // ── Méthodes existantes ──────────────────────────────────
    Q_INVOKABLE QVariantList listContact();

    Q_INVOKABLE bool addContact(const QString &nom,
                                const QString &prenom,
                                const QString &email,
                                const QString &localite,
                                const QString &organisation,
                                const QString &telephone);

    // ── Nouvelles méthodes ───────────────────────────────────

    // Retourne tous les champs d'un contact (id, nom, prenom,
    // email, localite, organisation, telephone, favori)
    Q_INVOKABLE QVariantMap getContactById(int id);

    // Modifie un contact existant
    Q_INVOKABLE bool updateContact(int id,
                                   const QString &nom,
                                   const QString &prenom,
                                   const QString &email,
                                   const QString &localite,
                                   const QString &organisation,
                                   const QString &telephone);

    // Supprime un contact par son id
    Q_INVOKABLE bool deleteContact(int id);

    // Active / désactive le favori d'un contact
    Q_INVOKABLE bool setFavori(int id, bool favori);

    // Retourne uniquement les contacts dont favori = 1
    Q_INVOKABLE QVariantList getFavoris();

signals:
    // Émis après tout ajout / modification / suppression
    void contactsChanged();

    // Émis après setFavori pour rafraîchir FavorisContacts.qml
    void favorisChanged();
};

#endif // CONTACTSMANAGER_H