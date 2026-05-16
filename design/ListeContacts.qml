import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: root

    // Récupère le modèle et la stack depuis le parent
  property var contactsModel

    background: Rectangle { color: "#f8f9fa" }

    // ══════════════════════════════════════════════════════════
    // HEADER
    // ══════════════════════════════════════════════════════════
    header: Rectangle {
        width: parent.width
        height: 64
        color: "#ffffff"
        z: 40

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: "#f3f4f6"
        }

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            spacing: 16

            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 5
                Rectangle { width: 20; height: 2; radius: 1; color: "#3b82f6" }
                Rectangle { width: 20; height: 2; radius: 1; color: "#3b82f6" }
                Rectangle { width: 20; height: 2; radius: 1; color: "#3b82f6" }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "Contacts"
                font.pixelSize: 16
                font.weight: Font.SemiBold
                color: "#111827"
            }
        }

        Rectangle {
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            width: 32; height: 32; radius: 16
            color: "#d4e3ff"
            border.color: "#c1c7d3"; border.width: 1

            Text {
                anchors.centerIn: parent
                text: "U"
                font.pixelSize: 13; font.weight: Font.Bold
                color: "#005da7"
            }
        }
    }

    // ══════════════════════════════════════════════════════════
    // CORPS  ─ ListView avec sections alphabétiques
    // ══════════════════════════════════════════════════════════
    Item {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: bottomNav.top

        // Barre de recherche
        Rectangle {
            id: searchBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 16
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            height: 48
            radius: 999
            color: "#edeeef"
            opacity: 0.85
            z: 5

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10

                Text {
                    text: "🔍"
                    font.pixelSize: 16
                    color: "#717783"
                    anchors.verticalCenter: parent.verticalCenter
                }
                TextField {
                    id: searchField
                    placeholderText: "Rechercher des contacts"
                    font.pixelSize: 15
                    color: "#111827"
                    background: Item {}
                    width: root.width - 100
                    leftPadding: 0
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // Modèle filtré + trié
        // SortFilterProxyModel {
        //     id: sortedModel
        // }

        // On utilise un simple ListView avec section
        ListView {
            id: listView
            anchors.top: searchBar.bottom
            anchors.topMargin: 8
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            clip: true
            bottomMargin: 16

            model: root.contactsModel

            // Tri par nom (section alphabétique)
            section.property: "lastName"
            section.criteria: ViewSection.FirstCharacter
            section.delegate: Text {
                leftPadding: 28
                topPadding: 16
                bottomPadding: 6
                text: section.toUpperCase()
                font.pixelSize: 12
                font.weight: Font.SemiBold
                font.letterSpacing: 0.6
                color: "#005da7"
            }

            delegate: ContactRowDelegate {
                width: listView.width
                contactIndex: index
                firstName: model.firstName
                lastName: model.lastName
                avatarBg: model.avatarColor
                avatarFg: model.avatarText
                isFav: model.favorite

                onClicked: {
                    StackView.view.push(Qt.resolvedUrl("ContactDetailPage.qml"), {
                        "contactIndex": index,
                        "contactsModel": root.contactsModel
                    })
                }
            }

            // Séparateur fin entre délégués du même groupe
            footer: Item { height: 16 }
        }
    }

    // ══════════════════════════════════════════════════════════
    // FAB
    // ══════════════════════════════════════════════════════════
    Rectangle {
        id: fab
        anchors.right: parent.right
        anchors.rightMargin: 24
        anchors.bottom: bottomNav.top
        anchors.bottomMargin: 16
        width: 56; height: 56; radius: 28
        color: "#005da7"
        z: 50

        Rectangle {
            anchors.fill: parent; anchors.margins: -5
            radius: 33; color: "transparent"
            border.color: "#4d005da7"; border.width: 5
            z: -1
        }

        Rectangle { anchors.centerIn: parent; width: 20; height: 3; radius: 1.5; color: "#ffffff" }
        Rectangle { anchors.centerIn: parent; width: 3; height: 20; radius: 1.5; color: "#ffffff" }

        scale: fabTap.pressed ? 0.92 : 1.0
        Behavior on scale { NumberAnimation { duration: 120 } }

        TapHandler {
            id: fabTap
            onTapped: {
                StackView.view.push(Qt.resolvedUrl("AddContactPage.qml"), {
                    "contactsModel": root.contactsModel
                })
            }
        }
    }

    // ══════════════════════════════════════════════════════════
    // BOTTOM NAV
    // ══════════════════════════════════════════════════════════
    Rectangle {
        id: bottomNav
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 72
        color: "#ffffff"
        z: 50

        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1; color: "#f3f4f6"
        }

        Row {
            anchors.fill: parent
            anchors.topMargin: 8
            anchors.bottomMargin: 8

            // Contacts (actif)
            Item {
                width: parent.width / 2
                height: parent.height

                Rectangle {
                    anchors.centerIn: parent
                    width: tabContacts.implicitWidth + 40
                    height: 46; radius: 16
                    color: "#eff6ff"

                    Row {
                        id: tabContacts
                        anchors.centerIn: parent
                        spacing: 6

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "👤"; font.pixelSize: 22; color: "#2563eb"
                        }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Contacts"
                            font.pixelSize: 12; font.weight: Font.Medium
                            color: "#2563eb"
                        }
                    }
                }
            }

            // Favoris (inactif)
            Item {
                width: parent.width / 2
                height: parent.height

                Column {
                    anchors.centerIn: parent
                    spacing: 2

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "☆"; font.pixelSize: 22; color: "#6b7280"
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Favoris"
                        font.pixelSize: 12; font.weight: Font.Medium
                        color: "#6b7280"
                    }
                }

                TapHandler {
                    onTapped: {
                        StackView.view.push(Qt.resolvedUrl("FavoritesPage.qml"), {
                            "contactsModel": root.contactsModel
                        })
                    }
                }
            }
        }
    }
}
