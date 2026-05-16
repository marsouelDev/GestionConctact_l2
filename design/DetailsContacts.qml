import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: root

    property int    contactIndex:  0
    property var    contactsModel: null

    // Raccourcis vers les données du contact courant
    property string cfirstName:  contactsModel ? contactsModel.get(contactIndex).firstName  : ""
    property string clastName:   contactsModel ? contactsModel.get(contactIndex).lastName   : ""
    property string cphone:      contactsModel ? contactsModel.get(contactIndex).phone      : ""
    property string cemail:      contactsModel ? contactsModel.get(contactIndex).email      : ""
    property string ccompany:    contactsModel ? contactsModel.get(contactIndex).company    : ""
    property string cavatarBg:   contactsModel ? contactsModel.get(contactIndex).avatarColor: "#dce3eb"
    property string cavatarFg:   contactsModel ? contactsModel.get(contactIndex).avatarText : "#40484e"
    property bool   cFavorite:   contactsModel ? contactsModel.get(contactIndex).favorite   : false

    background: Rectangle { color: "#f8f9fa" }

    // ══════════════════════════════════════════════════════════
    // HEADER
    // ══════════════════════════════════════════════════════════
    header: Rectangle {
        width: parent.width
        height: 64
        color: "#ffffff"
        z: 50

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1; color: "#f3f4f6"
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 20
            spacing: 12

            // Bouton retour
            Rectangle {
                width: 40; height: 40; radius: 20
                color: backHover.containsMouse ? "#f3f4f5" : "transparent"
                Behavior on color { ColorAnimation { duration: 150 } }

                Text {
                    anchors.centerIn: parent
                    text: "←"; font.pixelSize: 20; color: "#6b7280"
                }

                HoverHandler { id: backHover }
                TapHandler {
                    onTapped: StackView.view.pop()
                }
            }

            // Prénom dans le header
            Text {
                Layout.fillWidth: true
                text: root.cfirstName
                font.pixelSize: 18; font.weight: Font.SemiBold
                color: "#111827"
                elide: Text.ElideRight
            }

            // Bouton modifier
            Rectangle {
                height: 36
                width: editLabel.implicitWidth + 32
                radius: 999
                color: "#005da7"

                Text {
                    id: editLabel
                    anchors.centerIn: parent
                    text: "Modifier"
                    font.pixelSize: 13; font.weight: Font.SemiBold
                    color: "#ffffff"
                }

                scale: editTap.pressed ? 0.95 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }

                TapHandler {
                    id: editTap
                    onTapped: {
                        StackView.view.push(Qt.resolvedUrl("AddContactPage.qml"), {
                            "contactsModel": root.contactsModel,
                            "editIndex": root.contactIndex
                        })
                    }
                }
            }
        }
    }

    // ══════════════════════════════════════════════════════════
    // CORPS SCROLLABLE
    // ══════════════════════════════════════════════════════════
    ScrollView {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: bottomNav.top
        contentWidth: availableWidth
        clip: true

        Column {
            width: parent.width
            spacing: 0

            // ── Hero avatar ────────────────────────────────────
            Rectangle {
                width: parent.width
                height: heroCol.implicitHeight + 48
                color: "#ffffff"
                border.color: "#f3f4f6"; border.width: 0

                Column {
                    id: heroCol
                    anchors.centerIn: parent
                    spacing: 12

                    // Avatar
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 96; height: 96; radius: 48
                        color: root.cavatarBg
                        border.color: "#ffffff"; border.width: 4

                        Text {
                            anchors.centerIn: parent
                            text: (root.cfirstName.length > 0 ? root.cfirstName[0] : "") +
                                  (root.clastName.length  > 0 ? root.clastName[0]  : "")
                            font.pixelSize: 32; font.weight: Font.Bold
                            color: root.cavatarFg
                        }
                    }

                    // Nom complet
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: root.cfirstName + " " + root.clastName
                        font.pixelSize: 22; font.weight: Font.SemiBold
                        color: "#191c1d"
                    }

                    // Entreprise
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: root.ccompany
                        font.pixelSize: 14; color: "#717783"
                    }

                    // Bouton favori
                    Rectangle {
                        id: favBtn
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: favRow.implicitWidth + 40
                        height: 38; radius: 999
                        color: root.cFavorite ? "#eff6ff" : "transparent"
                        border.color: root.cFavorite ? "#005da7" : "#c1c7d3"
                        border.width: 1.5

                        Behavior on color { ColorAnimation { duration: 200 } }
                        Behavior on border.color { ColorAnimation { duration: 200 } }

                        Row {
                            id: favRow
                            anchors.centerIn: parent
                            spacing: 8

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: root.cFavorite ? "★" : "☆"
                                font.pixelSize: 18
                                color: root.cFavorite ? "#005da7" : "#9ca3af"
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: root.cFavorite ? "Dans les favoris" : "Ajouter aux favoris"
                                font.pixelSize: 13; font.weight: Font.Medium
                                color: root.cFavorite ? "#005da7" : "#717783"
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }
                        }

                        scale: favTap.pressed ? 0.94 : 1.0
                        Behavior on scale { NumberAnimation { duration: 100 } }

                        TapHandler {
                            id: favTap
                            onTapped: {
                                root.contactsModel.setProperty(root.contactIndex, "favorite", !root.cFavorite)
                                root.cFavorite = root.contactsModel.get(root.contactIndex).favorite
                            }
                        }
                    }

                    // Boutons d'action rapide
                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 12

                        Repeater {
                            model: [
                                { icon: "📞", label: "Appeler" },
                                { icon: "💬", label: "Message" },
                                { icon: "✉️",  label: "E-mail"  }
                            ]

                            delegate: Column {
                                spacing: 6

                                Rectangle {
                                    width: 56; height: 56; radius: 28
                                    color: "#f3f4f5"
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.icon
                                        font.pixelSize: 24
                                    }
                                }

                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: modelData.label
                                    font.pixelSize: 11; color: "#717783"
                                }
                            }
                        }
                    }
                }
            }

            Item { width: 1; height: 12 }

            // ── Card coordonnées ───────────────────────────────
            Rectangle {
                width: parent.width - 40
                anchors.horizontalCenter: parent.horizontalCenter
                height: coordCol.implicitHeight + 32
                radius: 12; color: "#ffffff"
                border.color: "#f3f4f6"; border.width: 1

                Column {
                    id: coordCol
                    anchors.left: parent.left; anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 20
                    spacing: 0

                    Text {
                        text: "COORDONNÉES"
                        font.pixelSize: 11; font.weight: Font.SemiBold
                        font.letterSpacing: 1.2; color: "#717783"
                        bottomPadding: 12
                    }

                    // Téléphone
                    Row {
                        width: parent.width
                        spacing: 14
                        height: 52

                        Rectangle {
                            width: 40; height: 40; radius: 8
                            color: "#d4e3ff"
                            anchors.verticalCenter: parent.verticalCenter
                            Text { anchors.centerIn: parent; text: "📞"; font.pixelSize: 18 }
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2
                            Text { text: "Téléphone"; font.pixelSize: 11; color: "#717783" }
                            Text { text: root.cphone; font.pixelSize: 15; color: "#191c1d" }
                        }
                    }

                    Rectangle { width: parent.width - 54; anchors.right: parent.right; height: 1; color: "#f3f4f6" }

                    // E-mail
                    Row {
                        width: parent.width
                        spacing: 14
                        height: 52

                        Rectangle {
                            width: 40; height: 40; radius: 8
                            color: "#6bfe9c55"
                            anchors.verticalCenter: parent.verticalCenter
                            Text { anchors.centerIn: parent; text: "✉️"; font.pixelSize: 18 }
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2
                            Text { text: "E-mail"; font.pixelSize: 11; color: "#717783" }
                            Text { text: root.cemail; font.pixelSize: 15; color: "#191c1d"; elide: Text.ElideRight; width: 220 }
                        }
                    }
                }
            }

            Item { width: 1; height: 12 }

            // ── Card détails ────────────────────────────────────
            Rectangle {
                width: parent.width - 40
                anchors.horizontalCenter: parent.horizontalCenter
                height: detailCol.implicitHeight + 32
                radius: 12; color: "#ffffff"
                border.color: "#f3f4f6"; border.width: 1

                Column {
                    id: detailCol
                    anchors.left: parent.left; anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 20
                    spacing: 0

                    Text {
                        text: "DÉTAILS"
                        font.pixelSize: 11; font.weight: Font.SemiBold
                        font.letterSpacing: 1.2; color: "#717783"
                        bottomPadding: 12
                    }

                    Row {
                        width: parent.width
                        spacing: 14
                        height: 52

                        Rectangle {
                            width: 40; height: 40; radius: 8
                            color: "#f3f4f5"
                            anchors.verticalCenter: parent.verticalCenter
                            Text { anchors.centerIn: parent; text: "🏢"; font.pixelSize: 18 }
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2
                            Text { text: "Entreprise"; font.pixelSize: 11; color: "#717783" }
                            Text { text: root.ccompany; font.pixelSize: 15; color: "#191c1d" }
                        }
                    }
                }
            }

            Item { width: 1; height: 12 }

            // ── Supprimer ───────────────────────────────────────
            Rectangle {
                width: parent.width - 40
                anchors.horizontalCenter: parent.horizontalCenter
                height: 52; radius: 12
                color: delHover.containsMouse ? "#fff0f0" : "#ffffff"
                border.color: "#f3f4f6"; border.width: 1
                Behavior on color { ColorAnimation { duration: 150 } }

                Text {
                    anchors.centerIn: parent
                    text: "🗑  Supprimer ce contact"
                    font.pixelSize: 14; font.weight: Font.Medium
                    color: "#ba1a1a"
                }

                HoverHandler { id: delHover }
                TapHandler {
                    onTapped: {
                        root.contactsModel.remove(root.contactIndex)
                        StackView.view.pop()
                    }
                }
            }

            Item { width: 1; height: 32 }
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
        height: 72; color: "#ffffff"; z: 50

        Rectangle {
            anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right
            height: 1; color: "#f3f4f6"
        }

        Row {
            anchors.fill: parent
            anchors.topMargin: 8; anchors.bottomMargin: 8

            Item {
                width: parent.width / 2; height: parent.height
                Column {
                    anchors.centerIn: parent; spacing: 2
                    Text { anchors.horizontalCenter: parent.horizontalCenter; text: "👤"; font.pixelSize: 22; color: "#2563eb" }
                    Text { anchors.horizontalCenter: parent.horizontalCenter; text: "Contacts"; font.pixelSize: 12; font.weight: Font.Medium; color: "#2563eb" }
                }
                TapHandler { onTapped: StackView.view.pop() }
            }

            Item {
                width: parent.width / 2; height: parent.height
                Column {
                    anchors.centerIn: parent; spacing: 2
                    Text { anchors.horizontalCenter: parent.horizontalCenter; text: "☆"; font.pixelSize: 22; color: "#6b7280" }
                    Text { anchors.horizontalCenter: parent.horizontalCenter; text: "Favoris"; font.pixelSize: 12; font.weight: Font.Medium; color: "#6b7280" }
                }
                TapHandler {
                    onTapped: {
                        StackView.view.push(Qt.resolvedUrl("FavorisContacts.qml"), {
                            "contactsModel": root.contactsModel
                        })
                    }
                }
            }
        }
    }
}
