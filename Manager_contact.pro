QT += widgets
QT += sql

CONFIG += c++17

INCLUDEPATH += include

SOURCES += \
    src/main.cpp \
    src/mainwindow.cpp \
    sqlite/sqlite3.c

HEADERS += \
    include/mainwindow.h \
    sqlite/sqlite3.h

FORMS += \
    design/mainwindow.ui