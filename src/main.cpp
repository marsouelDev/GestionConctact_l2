#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <QQuickStyle>

#include "database.h"
#include "contactsmanager.h"

int main(int argc, char *argv[])
{
    // STYLE QT
    QQuickStyle::setStyle("Basic");

    QGuiApplication app(argc, argv);

    Database::init();

    ContactsManager manager;

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("contactsManager",&manager );

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}