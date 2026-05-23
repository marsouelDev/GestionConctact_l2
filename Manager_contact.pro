QT += sql
QT += quick
QT += core gui widgets quick qml
CONFIG += c++17
QT += quickcontrols2

INCLUDEPATH += \
    $$PWD/include \
    $$PWD/dataBases \
    $$PWD/sqlite

SOURCES += \
    dataBases/database.cpp \
    include/contactsmanager.cpp \
    src/main.cpp \
    sqlite/sqlite3.c

HEADERS += \
    dataBases/database.h \
    include/contactsmanager.h \
    sqlite/sqlite3.h

FORMS +=


QML_IMPORT_PATH += $$PWD/QML/design
DISTFILES += \
    .gitignore \
    README.md \
    design/AjouterContacts.qml \
    design/Components/Avatar.qml \
    design/Components/BottomNav.qml \
    design/Components/ContactCard.qml \
    design/Components/ContactRow.qml \
    design/Components/CustomAppBar.qml \
    design/Components/FabButton.qml \
    design/Components/InfoItem.qml \
    design/Components/SearchBar.qml \
    design/Components/TopBar.qml \
    design/DetailsContacts.qml \
    design/FavorisContacts.qml \
    design/ListeContacts.qml \
    design/page/AjouterContacts.qml \
    design/page/DetailsContacts.qml \
    design/page/FavorisContacts.qml \
    design/page/ListeContacts.qml \
    design/page/ModifierContacts.qml \
    main.qml

RESOURCES += \
    qml.qrc