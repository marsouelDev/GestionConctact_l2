import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "qrc:/design/Components"

Page {
    background: Rectangle { color: "#f0f2f5" }

    // ── Header ──────────────────────────────────────────────
    Rectangle {
        id: appBar
        z: 10
        anchors { top: parent.top; left: parent.left; right: parent.right }
        height: 56
        color: "white"
        border.color: "#e5e7eb"
        border.width: 0.5

        // Bouton Fermer (✕)
        Rectangle {
            width: 32; height: 32; radius: 16
            color: closeHover.containsMouse ? "#f3f4f6" : "transparent"
            anchors { left: parent.left; leftMargin: 16; verticalCenter: parent.verticalCenter }
            Text { anchors.centerIn: parent; text: "✕"; font.pixelSize: 16; color: "#374151" }
            MouseArea { id: closeHover; hoverEnabled: true; anchors.fill: parent; onClicked: root.nav.pop() }
        }

        Text {
            anchors.centerIn: parent
            text: "Nouveau contact"
            font.pixelSize: 16; font.bold: true; color: "#111827"
        }

        // Bouton Enregistrer (header)
        Rectangle {
            width: 110; height: 34; radius: 8
            color: "#005da7"
            anchors { right: parent.right; rightMargin: 16; verticalCenter: parent.verticalCenter }
            Text { anchors.centerIn: parent; text: "Enregistrer"; color: "white"; font.pixelSize: 13; font.bold: true }
            MouseArea {
                anchors.fill: parent
                onClicked: sauvegarder()
            }
        }
    }

    // ── Fonction de sauvegarde ────────────────────────────────
    // Après l'appel, on fait pop() → ListeContacts.qml reçoit
    // StackView.onActivating ET le signal onContactsChanged → se rafraîchit.
    function sauvegarder() {
        var ok = contactsManager.addContact(
            nomField.text.trim(),
            prenomField.text.trim(),
            emailField.text.trim(),
            "",                       // localite (champ non présent ici)
            orgField.text.trim(),
            telField.text.trim()
        )
        if (ok) root.nav.pop()
    }

    // ── Contenu scrollable ───────────────────────────────────
    Flickable {
        anchors { top: appBar.bottom; left: parent.left; right: parent.right; bottom: bottomBar.top }
        clip: true
        contentHeight: mainCol.implicitHeight + 40

        Column {
            id: mainCol
            width: parent.width
            spacing: 0
            padding: 0

            // ── Avatar ──────────────────────────────────────
            Item {
                width: parent.width
                height: 130

                Column {
                    anchors.centerIn: parent
                    spacing: 8

                    Rectangle {
                        width: 80; height: 80; radius: 40
                        color: "#e5e7eb"
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text { anchors.centerIn: parent; text: "👤"; font.pixelSize: 36 }

                        Rectangle {
                            width: 24; height: 24; radius: 12
                            color: "#005da7"
                            anchors { right: parent.right; bottom: parent.bottom }
                            Text { anchors.centerIn: parent; text: "📷"; font.pixelSize: 12 }
                        }
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Ajouter une photo"
                        color: "#005da7"; font.pixelSize: 13
                    }
                }
            }

            // ── Section Informations personnelles ───────────
            Item { width: parent.width; height: 16 }

            Text {
                text: "INFORMATIONS PERSONNELLES"
                color: "#9ca3af"; font.pixelSize: 11; font.bold: true; leftPadding: 20
            }

            Item { width: parent.width; height: 8 }

            Rectangle {
                width: parent.width
                implicitHeight: colInfo.implicitHeight
                color: "white"; border.color: "#e5e7eb"; border.width: 0.5

                Column {
                    id: colInfo
                    width: parent.width

                    // Prénom
                    Column {
                        width: parent.width
                        topPadding: 12; bottomPadding: 8; spacing: 4
                        Text { text: "Prénom"; font.pixelSize: 12; color: "#374151"; font.bold: true; leftPadding: 20 }
                        TextField {
                            id: prenomField
                            x: 20; width: parent.width - 40
                            placeholderText: "Ex: Jean"
                            background: Rectangle { color: "#f9fafb"; radius: 8; border.color: "#e5e7eb" }
                            font.pixelSize: 14; color: "#111827"; leftPadding: 12
                        }
                    }

                    Rectangle { width: parent.width; height: 1; color: "#f3f4f6" }

                    // Nom
                    Column {
                        width: parent.width
                        topPadding: 12; bottomPadding: 12; spacing: 4
                        Text { text: "Nom"; font.pixelSize: 12; color: "#374151"; font.bold: true; leftPadding: 20 }
                        TextField {
                            id: nomField
                            x: 20; width: parent.width - 40
                            placeholderText: "Ex: Atangana"
                            background: Rectangle { color: "#f9fafb"; radius: 8; border.color: "#e5e7eb" }
                            font.pixelSize: 14; color: "#111827"; leftPadding: 12
                        }
                    }
                }
            }

            // ── Section Coordonnées ─────────────────────────
            Item { width: parent.width; height: 20 }

            Text {
                text: "COORDONNÉES"
                color: "#9ca3af"; font.pixelSize: 11; font.bold: true; leftPadding: 20
            }

            Item { width: parent.width; height: 8 }

            Rectangle {
                width: parent.width
                implicitHeight: colCoord.implicitHeight
                color: "white"; border.color: "#e5e7eb"; border.width: 0.5

                Column {
                    id: colCoord
                    width: parent.width

                    // Téléphone
                    Item {
                        width: parent.width
                        height: rowTel.implicitHeight + 24

                        Row {
                            id: rowTel
                            anchors {
                                left: parent.left; leftMargin: 20
                                right: parent.right; rightMargin: 20
                                verticalCenter: parent.verticalCenter
                            }
                            spacing: 12

                            Rectangle {
                                width: 36; height: 36; radius: 10; color: "#dbeafe"
                                Text { anchors.centerIn: parent; text: "📞"; font.pixelSize: 18 }
                            }

                            Column {
                                width: parent.width - 48; spacing: 4
                                Text { text: "Téléphone"; font.pixelSize: 12; color: "#374151"; font.bold: true }
                                TextField {
                                    id: telField
                                    width: parent.width
                                    placeholderText: "671 46 22 46"
                                    inputMethodHints: Qt.ImhDialableCharactersOnly
                                    background: Rectangle { color: "#f9fafb"; radius: 8; border.color: "#e5e7eb" }
                                    font.pixelSize: 14; color: "#111827"; leftPadding: 12
                                }
                            }
                        }
                    }

                    Rectangle { width: parent.width; height: 1; color: "#f3f4f6" }

                    // Email
                    Item {
                        width: parent.width
                        height: rowEmail.implicitHeight + 24

                        Row {
                            id: rowEmail
                            anchors {
                                left: parent.left; leftMargin: 20
                                right: parent.right; rightMargin: 20
                                verticalCenter: parent.verticalCenter
                            }
                            spacing: 12

                            Rectangle {
                                width: 36; height: 36; radius: 10; color: "#d1fae5"
                                Text { anchors.centerIn: parent; text: "✉️"; font.pixelSize: 18 }
                            }

                            Column {
                                width: parent.width - 48; spacing: 4
                                Text { text: "E-mail"; font.pixelSize: 12; color: "#374151"; font.bold: true }
                                TextField {
                                    id: emailField
                                    width: parent.width
                                    placeholderText: "jean.atangana@exemple.com"
                                    inputMethodHints: Qt.ImhEmailCharactersOnly
                                    background: Rectangle { color: "#f9fafb"; radius: 8; border.color: "#e5e7eb" }
                                    font.pixelSize: 14; color: "#111827"; leftPadding: 12
                                }
                            }
                        }
                    }
                }
            }

            // ── Section Détails supplémentaires ────────────
            Item { width: parent.width; height: 20 }

            Text {
                text: "DÉTAILS SUPPLÉMENTAIRES"
                color: "#9ca3af"; font.pixelSize: 11; font.bold: true; leftPadding: 20
            }

            Item { width: parent.width; height: 8 }

            Rectangle {
                width: parent.width
                implicitHeight: colDetails.implicitHeight
                color: "white"; border.color: "#e5e7eb"; border.width: 0.5

                Column {
                    id: colDetails
                    width: parent.width
                    topPadding: 12; bottomPadding: 12; spacing: 4

                    Text { text: "Entreprise"; font.pixelSize: 12; color: "#374151"; font.bold: true; leftPadding: 20 }
                    TextField {
                        id: orgField
                        x: 20; width: parent.width - 40
                        placeholderText: "Nom de l'entreprise"
                        background: Rectangle { color: "#f9fafb"; radius: 8; border.color: "#e5e7eb" }
                        font.pixelSize: 14; color: "#111827"; leftPadding: 12
                    }
                }
            }

            Item { width: parent.width; height: 20 }
        }
    }

    // ── Barre du bas ─────────────────────────────────────────
    Rectangle {
        id: bottomBar
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
        height: 72
        color: "white"; border.color: "#e5e7eb"; border.width: 0.5

        Row {
            anchors.centerIn: parent
            spacing: 16

            Rectangle {
                width: 140; height: 44; radius: 10
                color: "#f3f4f6"; border.color: "#d1d5db"
                Text { anchors.centerIn: parent; text: "Annuler"; font.pixelSize: 15; color: "#374151"; font.bold: true }
                MouseArea { anchors.fill: parent; onClicked: root.nav.pop() }
            }

            Rectangle {
                width: 140; height: 44; radius: 10
                color: "#005da7"
                Text { anchors.centerIn: parent; text: "Enregistrer"; font.pixelSize: 15; color: "white"; font.bold: true }
                MouseArea { anchors.fill: parent; onClicked: sauvegarder() }
            }
        }
    }
}
