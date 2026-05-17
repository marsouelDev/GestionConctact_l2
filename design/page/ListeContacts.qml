import QtQuick 2.15
import QtQuick.Controls 2.15
import "qrc:/design/Components"

Page {

    background: Rectangle {
        color: "#f8f9fa"
    }

    Column {
        anchors.fill: parent
        spacing: 14

        // ================= APP BAR =================
        CustomAppBar {
            title: "Contacts"
        }

        // ================= SEARCH =================

        Rectangle {
            width: parent.width - 40
            height: 48
            radius: 24
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#eef1f4"
            clip: true                          //  empêche le texte de déborder

            Row {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                spacing: 8

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "🔍"
                    font.pixelSize: 16
                    color: "#9ca3af"
                }

                TextField {
                    width: parent.width - 30
                    height: parent.height
                    placeholderText: "Rechercher un contact"
                    color: "#111827"                    // ✅ texte saisi visible
                    placeholderTextColor: "#9ca3af"
                    font.pixelSize: 14
                    verticalAlignment: TextInput.AlignVCenter
                    background: Rectangle {             // ✅ fond transparent explicite
                        color: "transparent"
                    }
                    leftPadding: 0
                }
            }
        }
        // ================= LIST =================
        ListView {

            id: contactsList
            width: parent.width

            //  FIX IMPORTANT (évite chevauchement bottom nav + FAB)
            height: parent.height - 260

            spacing: 12
            clip: true

            model: contactsManager.listContact()

            delegate: Rectangle {

                width: contactsList.width - 24
                height: 76
                radius: 14
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter

                border.color: "#e5e7eb"
                border.width: 1

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        root.nav.push(
                            Qt.resolvedUrl("DetailsContacts.qml"),
                            { contactId: modelData.id }
                        )
                    }
                }

                Row {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 12

                    Rectangle {
                        width: 44
                        height: 44
                        radius: 22
                        color: "#005da7"

                        Text {
                            anchors.centerIn: parent
                            text: (modelData.prenom.charAt(0) + modelData.nom.charAt(0)).toUpperCase()
                            color: "white"
                            font.bold: true
                            font.pixelSize: 15
                        }
                    }

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2
                        width: parent.width - 140

                        Text {
                            text: modelData.prenom + " " + modelData.nom
                            font.pixelSize: 15
                            font.bold: true
                            color: "#1f2937"
                            elide: Text.ElideRight
                        }

                        Text {
                            text: modelData.email
                            color: "#6b7280"
                            font.pixelSize: 12
                            elide: Text.ElideRight
                        }
                    }

                    Button {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "❤"

                        background: Rectangle {
                            color: "transparent"
                        }

                        contentItem: Text {
                            text: parent.text
                            color: "#ff3b30"
                            font.pixelSize: 18
                        }

                        onClicked: {
                            console.log("Favori click")
                        }
                    }
                }
            }

            Text {
                visible: contactsList.count === 0
                anchors.centerIn: parent
                text: "Aucun contact"
                color: "#9ca3af"
                font.pixelSize: 14
            }
        }
    }

    // ================= FLOAT BUTTON =================
    Rectangle {
        width: 60
        height: 60
        radius: 30
        color: "#005da7"

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20
        anchors.bottomMargin: 90

        Text {
            anchors.centerIn: parent
            text: "+"
            color: "white"
            font.pixelSize: 30
            font.bold: true
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                root.nav.push(Qt.resolvedUrl("AjouterContacts.qml"))
            }
        }
    }

    // ================= BOTTOM NAV =================
    Rectangle {

        width: parent.width
        height: 72

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        color: "white"
        border.color: "#e5e7eb"

        // shadow top
        Rectangle {
            width: parent.width
            height: 1
            color: "#00000010"
        }

        Row {
            anchors.centerIn: parent
            spacing: 90

            Button {
                text: "Contacts"

                background: Rectangle {
                    radius: 14
                    color: "#dbeafe"
                }

                contentItem: Text {
                    text: parent.text
                    color: "#005da7"
                    font.bold: true
                }
            }

            Button {
                text: "Favoris"

                background: Rectangle {
                    radius: 14
                    color: "transparent"
                }

                contentItem: Text {
                    text: parent.text
                    color: "#6b7280"
                    font.bold: true
                }

                onClicked: {
                    root.nav.push(Qt.resolvedUrl("FavorisContacts.qml"))
                }
            }
        }
    }
}