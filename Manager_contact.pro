QML_IMPORT_PATH += $$PWD/QML/design
QT += sql
QT += quick
QT += core gui widgets quick qml
CONFIG += c++17

INCLUDEPATH += include

SOURCES += \
    dataBases/database.cpp \
    src/main.cpp \
    src/mainwindow.cpp \
    sqlite/sqlite3.c

HEADERS += \
    dataBases/database.h \
    include/mainwindow.h \
    sqlite/sqlite3.h

FORMS += \
    design/mainwindow.ui

DISTFILES += \
    .gitignore \
    README.md \
    design/AjouterContacts.qml \
    design/DetailsContacts.qml \
    design/FavorisContacts.qml \
    design/ListeContacts.qml \
    main.qml

RESOURCES += \
    qml.qrc