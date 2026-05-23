import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: detailPage
    background: Rectangle { color: "#f0f2f5" }

    // ── Propriété reçue depuis ListeContacts ─────────────────
    // Appel : root.nav.push("qrc:/design/page/DetailsContacts.qml", { contactId: model.id })
    property int contactId: -1

    // Données chargées depuis la BD
    property string contactNom:     ""
    property string contactPrenom:  ""
    property string contactEmail:   ""
    property string contactTel:     ""
    property string contactOrg:     ""
    property bool   contactFavori:  false

    // Chargement au démarrage
    Component.onCompleted: {
        if (contactId >= 0) {
            var c = contactsManager.getContactById(contactId)
            if (c) {
                contactNom    = c.nom
                contactPrenom = c.prenom
                contactEmail  = c.email
                contactTel    = c.telephone
                contactOrg    = c.organisation
                contactFavori = c.favori
            }
        }
    }

    // ── Dialogue de confirmation suppression ─────────────────
    Rectangle {
        id: deleteDialog
        visible: false
        z: 100
        anchors.fill: parent
        color: "#80000000"

        Rectangle {
            width: 320; height: 180; radius: 16
            color: "white"
            anchors.centerIn: parent

            Column {
                anchors.centerIn: parent
                spacing: 20
                width: parent.width - 40

                Text {
                    width: parent.width
                    text: "Supprimer le contact ?"
                    font.pixelSize: 17; font.bold: true
                    color: "#111827"; horizontalAlignment: Text.AlignHCenter
                }
                Text {
                    width: parent.width
                    text: "Cette action est irréversible."
                    font.pixelSize: 13; color: "#6b7280"
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 16

                    Rectangle {
                        width: 120; height: 42; radius: 10
                        color: "#f3f4f6"; border.color: "#d1d5db"
                        Text { anchors.centerIn: parent; text: "Annuler"; font.pixelSize: 14; color: "#374151" }
                        MouseArea { anchors.fill: parent; onClicked: deleteDialog.visible = false }
                    }
                    Rectangle {
                        width: 120; height: 42; radius: 10
                        color: "#ef4444"
                        Text { anchors.centerIn: parent; text: "Supprimer"; font.pixelSize: 14; color: "white"; font.bold: true }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                contactsManager.deleteContact(contactId)
                                deleteDialog.visible = false
                                root.nav.pop()
                            }
                        }
                    }
                }
            }
        }
    }

    // ── Header ───────────────────────────────────────────────
    Rectangle {
        id: appBar
        z: 10
        anchors { top: parent.top; left: parent.left; right: parent.right }
        height: 56
        color: "white"
        border.color: "#e5e7eb"; border.width: 0.5

        // Bouton Retour
        Rectangle {
            width: 36; height: 36; radius: 18
            color: backHover.containsMouse ? "#f3f4f6" : "transparent"
            anchors { left: parent.left; leftMargin: 12; verticalCenter: parent.verticalCenter }
            Text { anchors.centerIn: parent; text: "←"; font.pixelSize: 20; color: "#374151" }
            MouseArea { id: backHover; hoverEnabled: true; anchors.fill: parent; onClicked: root.nav.pop() }
        }

        Text {
            anchors.centerIn: parent
            text: "Détails du contact"
            font.pixelSize: 16; font.bold: true; color: "#111827"
        }

        // Bouton Favoris (étoile)
        Rectangle {
            width: 36; height: 36; radius: 18
            color: favHover.containsMouse ? "#fef3c7" : "transparent"
            anchors { right: editBtn.left; rightMargin: 4; verticalCenter: parent.verticalCenter }
            Text {
                anchors.centerIn: parent
                text: contactFavori ? "★" : "☆"
                font.pixelSize: 22
                color: contactFavori ? "#f59e0b" : "#9ca3af"
            }
            MouseArea {
                id: favHover; hoverEnabled: true; anchors.fill: parent
                onClicked: {
                    contactFavori = !contactFavori
                    contactsManager.setFavori(contactId, contactFavori)
                }
            }
        }

        // Bouton Modifier
        Rectangle {
            id: editBtn
            width: 80; height: 34; radius: 8
            color: "#005da7"
            anchors { right: parent.right; rightMargin: 12; verticalCenter: parent.verticalCenter }
            Text { anchors.centerIn: parent; text: "Modifier"; color: "white"; font.pixelSize: 13; font.bold: true }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.nav.push("qrc:/design/page/ModifierContact.qml", { contactId: contactId })
                }
            }
        }
    }

    // ── Contenu scrollable ───────────────────────────────────
    Flickable {
        anchors { top: appBar.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
        clip: true
        contentHeight: mainCol.implicitHeight + 40

        Column {
            id: mainCol
            width: parent.width
            spacing: 0

            // ── Avatar + Nom ─────────────────────────────────
            Rectangle {
                width: parent.width
                height: 180
                color: "white"
                border.color: "#e5e7eb"; border.width: 0.5

                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    // Cercle avatar avec initiales
                    Rectangle {
                        width: 90; height: 90; radius: 45
                        color: "#005da7"
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            anchors.centerIn: parent
                            text: {
                                var p = contactPrenom.length > 0 ? contactPrenom[0].toUpperCase() : ""
                                var n = contactNom.length > 0 ? contactNom[0].toUpperCase() : ""
                                return p + n
                            }
                            font.pixelSize: 32; font.bold: true
                            color: "white"
                        }

                        // Badge favori sur l'avatar
                        Rectangle {
                            visible: contactFavori
                            width: 26; height: 26; radius: 13
                            color: "#f59e0b"
                            anchors { right: parent.right; bottom: parent.bottom; margins: 2 }
                            Text { anchors.centerIn: parent; text: "★"; font.pixelSize: 13; color: "white" }
                        }
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: contactPrenom + " " + contactNom
                        font.pixelSize: 20; font.bold: true; color: "#111827"
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        visible: contactOrg.length > 0
                        text: contactOrg
                        font.pixelSize: 13; color: "#6b7280"
                    }
                }
            }

            // ── Actions rapides ──────────────────────────────
            Item { width: parent.width; height: 16 }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 24

                // Appel
                Column {
                    spacing: 6
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        width: 52; height: 52; radius: 26
                        color: "#dbeafe"
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text { anchors.centerIn: parent; text: "📞"; font.pixelSize: 22 }
                        MouseArea { anchors.fill: parent; onClicked: Qt.openUrlExternally("tel:" + contactTel) }
                    }
                    Text { anchors.horizontalCenter: parent.horizontalCenter; text: "Appel"; font.pixelSize: 11; color: "#374151" }
                }

                // SMS
                Column {
                    spacing: 6
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        width: 52; height: 52; radius: 26
                        color: "#d1fae5"
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text { anchors.centerIn: parent; text: "💬"; font.pixelSize: 22 }
                        MouseArea { anchors.fill: parent; onClicked: Qt.openUrlExternally("sms:" + contactTel) }
                    }
                    Text { anchors.horizontalCenter: parent.horizontalCenter; text: "SMS"; font.pixelSize: 11; color: "#374151" }
                }

                // Email
                Column {
                    spacing: 6
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        width: 52; height: 52; radius: 26
                        color: "#ede9fe"
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text { anchors.centerIn: parent; text: "✉️"; font.pixelSize: 22 }
                        MouseArea { anchors.fill: parent; onClicked: Qt.openUrlExternally("mailto:" + contactEmail) }
                    }
                    Text { anchors.horizontalCenter: parent.horizontalCenter; text: "E-mail"; font.pixelSize: 11; color: "#374151" }
                }

                // Favori
                Column {
                    spacing: 6
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        width: 52; height: 52; radius: 26
                        color: contactFavori ? "#fef3c7" : "#f3f4f6"
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text { anchors.centerIn: parent; text: contactFavori ? "★" : "☆"; font.pixelSize: 22; color: contactFavori ? "#f59e0b" : "#9ca3af" }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                contactFavori = !contactFavori
                                contactsManager.setFavori(contactId, contactFavori)
                            }
                        }
                    }
                    Text { anchors.horizontalCenter: parent.horizontalCenter; text: "Favori"; font.pixelSize: 11; color: "#374151" }
                }
            }

            // ── Section Coordonnées ──────────────────────────
            Item { width: parent.width; height: 20 }

            Text {
                text: "COORDONNÉES"
                color: "#9ca3af"; font.pixelSize: 11; font.bold: true
                leftPadding: 20
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
                        height: 64
                        visible: contactTel.length > 0

                        Row {
                            anchors {
                                left: parent.left; leftMargin: 20
                                right: parent.right; rightMargin: 20
                                verticalCenter: parent.verticalCenter
                            }
                            spacing: 14

                            Rectangle {
                                width: 40; height: 40; radius: 12
                                color: "#dbeafe"
                                anchors.verticalCenter: parent.verticalCenter
                                Text { anchors.centerIn: parent; text: "📞"; font.pixelSize: 20 }
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 2
                                Text { text: "Téléphone"; font.pixelSize: 11; color: "#9ca3af" }
                                Text { text: contactTel; font.pixelSize: 15; color: "#005da7"; font.bold: true }
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width; height: 1; color: "#f3f4f6"
                        visible: contactTel.length > 0 && contactEmail.length > 0
                    }

                    // Email
                    Item {
                        width: parent.width
                        height: 64
                        visible: contactEmail.length > 0

                        Row {
                            anchors {
                                left: parent.left; leftMargin: 20
                                right: parent.right; rightMargin: 20
                                verticalCenter: parent.verticalCenter
                            }
                            spacing: 14

                            Rectangle {
                                width: 40; height: 40; radius: 12
                                color: "#d1fae5"
                                anchors.verticalCenter: parent.verticalCenter
                                Text { anchors.centerIn: parent; text: "✉️"; font.pixelSize: 20 }
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 2
                                Text { text: "E-mail"; font.pixelSize: 11; color: "#9ca3af" }
                                Text { text: contactEmail; font.pixelSize: 15; color: "#111827" }
                            }
                        }
                    }
                }
            }

            // ── Section Informations personnelles ────────────
            Item { width: parent.width; height: 20 }

            Text {
                text: "INFORMATIONS PERSONNELLES"
                color: "#9ca3af"; font.pixelSize: 11; font.bold: true
                leftPadding: 20
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
                    Item {
                        width: parent.width; height: 56
                        visible: contactPrenom.length > 0

                        Column {
                            anchors {
                                left: parent.left; leftMargin: 20
                                verticalCenter: parent.verticalCenter
                            }
                            spacing: 2
                            Text { text: "Prénom"; font.pixelSize: 11; color: "#9ca3af" }
                            Text { text: contactPrenom; font.pixelSize: 15; color: "#111827" }
                        }
                    }

                    Rectangle { width: parent.width; height: 1; color: "#f3f4f6" }

                    // Nom
                    Item {
                        width: parent.width; height: 56
                        visible: contactNom.length > 0

                        Column {
                            anchors {
                                left: parent.left; leftMargin: 20
                                verticalCenter: parent.verticalCenter
                            }
                            spacing: 2
                            Text { text: "Nom"; font.pixelSize: 11; color: "#9ca3af" }
                            Text { text: contactNom; font.pixelSize: 15; color: "#111827" }
                        }
                    }
                }
            }

            // ── Section Détails supplémentaires ─────────────
            Item {
                width: parent.width; height: 20
                visible: contactOrg.length > 0
            }

            Text {
                visible: contactOrg.length > 0
                text: "DÉTAILS SUPPLÉMENTAIRES"
                color: "#9ca3af"; font.pixelSize: 11; font.bold: true
                leftPadding: 20
            }

            Item { width: parent.width; height: 8; visible: contactOrg.length > 0 }

            Rectangle {
                width: parent.width
                height: 56
                visible: contactOrg.length > 0
                color: "white"; border.color: "#e5e7eb"; border.width: 0.5

                Column {
                    anchors { left: parent.left; leftMargin: 20; verticalCenter: parent.verticalCenter }
                    spacing: 2
                    Text { text: "Entreprise"; font.pixelSize: 11; color: "#9ca3af" }
                    Text { text: contactOrg; font.pixelSize: 15; color: "#111827" }
                }
            }

            // ── Bouton Supprimer ─────────────────────────────
            Item { width: parent.width; height: 32 }

            Rectangle {
                width: parent.width - 40
                height: 48; radius: 12
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#fee2e2"; border.color: "#fca5a5"; border.width: 1

                Row {
                    anchors.centerIn: parent
                    spacing: 8
                    Text { text: "🗑"; font.pixelSize: 18; color: "#ef4444" }
                    Text { text: "Supprimer ce contact"; font.pixelSize: 15; font.bold: true; color: "#ef4444" }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: deleteDialog.visible = true
                }
            }

            Item { width: parent.width; height: 30 }
        }
    }
}
