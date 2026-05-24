import QtQuick 2.15
import QtQuick.Controls 2.15

Page {
    id: detailPage
    background: Rectangle { color: "#f0f2f5" }

    // ── Propriété reçue depuis ListeContacts ou FavorisContacts ──
    // root.nav.push("qrc:/design/page/DetailsContacts.qml", { contactId: model.id })
    property int contactId: -1

    // Données affichées — toutes initialisées à vide
    property string contactNom:    ""
    property string contactPrenom: ""
    property string contactEmail:  ""
    property string contactTel:    ""
    property string contactOrg:    ""
    property string contactLocalite: ""
    property bool   contactFavori: false

    // ── Chargement des données depuis la BD ───────────────────
    function chargerContact() {
        if (contactId < 0) return
        var c = contactsManager.getContactById(contactId)
        // getContactById retourne un QVariantMap ; on vérifie que l'id est présent
        if (c && c.id !== undefined) {
            contactNom      = c.nom      || ""
            contactPrenom   = c.prenom   || ""
            contactEmail    = c.email    || ""
            contactTel      = c.telephone || ""   // clé "telephone" du JOIN
            contactOrg      = c.organisation || ""
            contactLocalite = c.localite || ""
            contactFavori   = c.favori   === true
        }
    }

    Component.onCompleted: chargerContact()

    // Rafraîchissement si on revient depuis ModifierContact
    StackView.onActivating: chargerContact()

    // Rafraîchissement si le signal C++ est émis (ex: setFavori depuis la liste)
    Connections {
        target: contactsManager
        function onContactsChanged() { chargerContact() }
    }

    // ── Dialogue de confirmation suppression ──────────────────
    Rectangle {
        id: deleteDialog
        visible: false
        z: 100
        anchors.fill: parent
        color: "#80000000"

        Rectangle {
            width: 320; height: 190; radius: 16
            color: "white"
            anchors.centerIn: parent

            Column {
                anchors.centerIn: parent
                spacing: 18
                width: parent.width - 48

                Text {
                    width: parent.width
                    text: "Supprimer ce contact ?"
                    font.pixelSize: 17; font.bold: true; color: "#111827"
                    horizontalAlignment: Text.AlignHCenter
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

    // ── Header ────────────────────────────────────────────────
    Rectangle {
        id: appBar
        z: 10
        anchors { top: parent.top; left: parent.left; right: parent.right }
        height: 56
        color: "white"; border.color: "#e5e7eb"; border.width: 0.5

        // Bouton retour
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

        // Étoile favori
        Rectangle {
            id: favBtn
            width: 36; height: 36; radius: 18
            color: favHover.containsMouse ? "#fef3c7" : "transparent"
            anchors { right: editBtn.left; rightMargin: 6; verticalCenter: parent.verticalCenter }
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
            width: 84; height: 34; radius: 8
            color: "#005da7"
            anchors { right: parent.right; rightMargin: 12; verticalCenter: parent.verticalCenter }
            Text { anchors.centerIn: parent; text: "Modifier"; color: "white"; font.pixelSize: 13; font.bold: true }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.nav.push("qrc:/design/page/ModifierContacts.qml",
                                  { contactId: contactId })
                }
            }
        }
    }

    // ── Contenu scrollable ────────────────────────────────────
    Flickable {
        anchors { top: appBar.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
        clip: true
        contentHeight: mainCol.implicitHeight + 40

        Column {
            id: mainCol
            width: parent.width
            spacing: 0

            // ── Carte avatar ──────────────────────────────────
            Rectangle {
                width: parent.width; height: 180
                color: "white"; border.color: "#e5e7eb"; border.width: 0.5

                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    Rectangle {
                        width: 90; height: 90; radius: 45
                        color: "#005da7"
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            anchors.centerIn: parent
                            text: {
                                var p = contactPrenom.length > 0 ? contactPrenom[0].toUpperCase() : ""
                                var n = contactNom.length > 0    ? contactNom[0].toUpperCase()    : "?"
                                return p + n
                            }
                            font.pixelSize: 32; font.bold: true; color: "white"
                        }

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

            // ── Actions rapides ───────────────────────────────
            Item { width: parent.width; height: 20 }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 28

                // Appel
                Column {
                    spacing: 6
                    Rectangle {
                        width: 52; height: 52; radius: 26; color: "#dbeafe"
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text { anchors.centerIn: parent; text: "📞"; font.pixelSize: 22 }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: { if (contactTel.length > 0) Qt.openUrlExternally("tel:" + contactTel) }
                        }
                    }
                    Text { anchors.horizontalCenter: parent.horizontalCenter; text: "Appel"; font.pixelSize: 11; color: "#374151" }
                }

                // SMS
                Column {
                    spacing: 6
                    Rectangle {
                        width: 52; height: 52; radius: 26; color: "#d1fae5"
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text { anchors.centerIn: parent; text: "💬"; font.pixelSize: 22 }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: { if (contactTel.length > 0) Qt.openUrlExternally("sms:" + contactTel) }
                        }
                    }
                    Text { anchors.horizontalCenter: parent.horizontalCenter; text: "SMS"; font.pixelSize: 11; color: "#374151" }
                }

                // Email
                Column {
                    spacing: 6
                    Rectangle {
                        width: 52; height: 52; radius: 26; color: "#ede9fe"
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text { anchors.centerIn: parent; text: "✉️"; font.pixelSize: 22 }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: { if (contactEmail.length > 0) Qt.openUrlExternally("mailto:" + contactEmail) }
                        }
                    }
                    Text { anchors.horizontalCenter: parent.horizontalCenter; text: "E-mail"; font.pixelSize: 11; color: "#374151" }
                }

                // Favori
                Column {
                    spacing: 6
                    Rectangle {
                        width: 52; height: 52; radius: 26
                        color: contactFavori ? "#fef3c7" : "#f3f4f6"
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text {
                            anchors.centerIn: parent
                            text: contactFavori ? "★" : "☆"
                            font.pixelSize: 22
                            color: contactFavori ? "#f59e0b" : "#9ca3af"
                        }
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

            // ── Section Coordonnées ───────────────────────────
            Item { width: parent.width; height: 24 }

            Text {
                text: "COORDONNÉES"
                color: "#9ca3af"; font.pixelSize: 11; font.bold: true; leftPadding: 20
            }

            Item { width: parent.width; height: 8 }

            Rectangle {
                width: parent.width
                height: coordCol.implicitHeight
                color: "white"; border.color: "#e5e7eb"; border.width: 0.5

                Column {
                    id: coordCol
                    width: parent.width

                    // ── Téléphone ──────────────────────────────
                    Item {
                        width: parent.width
                        // Toujours visible même si vide, on affiche "—" dans ce cas
                        height: 64

                        Row {
                            anchors {
                                left: parent.left; leftMargin: 20
                                right: parent.right; rightMargin: 20
                                verticalCenter: parent.verticalCenter
                            }
                            spacing: 14

                            Rectangle {
                                width: 40; height: 40; radius: 12; color: "#dbeafe"
                                anchors.verticalCenter: parent.verticalCenter
                                Text { anchors.centerIn: parent; text: "📞"; font.pixelSize: 20 }
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 2
                                Text { text: "Téléphone"; font.pixelSize: 11; color: "#9ca3af" }
                                Text {
                                    text: contactTel.length > 0 ? contactTel : "—"
                                    font.pixelSize: 15
                                    color: contactTel.length > 0 ? "#005da7" : "#9ca3af"
                                    font.bold: contactTel.length > 0
                                }
                            }
                        }
                    }

                    Rectangle { width: parent.width; height: 1; color: "#f3f4f6" }

                    // ── Email ──────────────────────────────────
                    Item {
                        width: parent.width; height: 64

                        Row {
                            anchors {
                                left: parent.left; leftMargin: 20
                                right: parent.right; rightMargin: 20
                                verticalCenter: parent.verticalCenter
                            }
                            spacing: 14

                            Rectangle {
                                width: 40; height: 40; radius: 12; color: "#d1fae5"
                                anchors.verticalCenter: parent.verticalCenter
                                Text { anchors.centerIn: parent; text: "✉️"; font.pixelSize: 20 }
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 2
                                Text { text: "E-mail"; font.pixelSize: 11; color: "#9ca3af" }
                                Text {
                                    text: contactEmail.length > 0 ? contactEmail : "—"
                                    font.pixelSize: 15
                                    color: contactEmail.length > 0 ? "#111827" : "#9ca3af"
                                }
                            }
                        }
                    }
                }
            }

            // ── Section Informations personnelles ─────────────
            Item { width: parent.width; height: 24 }

            Text {
                text: "INFORMATIONS PERSONNELLES"
                color: "#9ca3af"; font.pixelSize: 11; font.bold: true; leftPadding: 20
            }

            Item { width: parent.width; height: 8 }

            Rectangle {
                width: parent.width
                height: infoCol.implicitHeight
                color: "white"; border.color: "#e5e7eb"; border.width: 0.5

                Column {
                    id: infoCol
                    width: parent.width

                    Item {
                        width: parent.width; height: 56
                        Column {
                            anchors { left: parent.left; leftMargin: 20; verticalCenter: parent.verticalCenter }
                            spacing: 2
                            Text { text: "Prénom"; font.pixelSize: 11; color: "#9ca3af" }
                            Text { text: contactPrenom.length > 0 ? contactPrenom : "—"; font.pixelSize: 15; color: "#111827" }
                        }
                    }

                    Rectangle { width: parent.width; height: 1; color: "#f3f4f6" }

                    Item {
                        width: parent.width; height: 56
                        Column {
                            anchors { left: parent.left; leftMargin: 20; verticalCenter: parent.verticalCenter }
                            spacing: 2
                            Text { text: "Nom"; font.pixelSize: 11; color: "#9ca3af" }
                            Text { text: contactNom.length > 0 ? contactNom : "—"; font.pixelSize: 15; color: "#111827" }
                        }
                    }

                    Rectangle { width: parent.width; height: 1; color: "#f3f4f6" }

                    Item {
                        width: parent.width; height: 56
                        visible: contactLocalite.length > 0
                        Column {
                            anchors { left: parent.left; leftMargin: 20; verticalCenter: parent.verticalCenter }
                            spacing: 2
                            Text { text: "Localité"; font.pixelSize: 11; color: "#9ca3af" }
                            Text { text: contactLocalite; font.pixelSize: 15; color: "#111827" }
                        }
                    }
                }
            }

            // ── Section Entreprise ────────────────────────────
            Item { width: parent.width; height: 24; visible: contactOrg.length > 0 }

            Text {
                visible: contactOrg.length > 0
                text: "DÉTAILS SUPPLÉMENTAIRES"
                color: "#9ca3af"; font.pixelSize: 11; font.bold: true; leftPadding: 20
            }

            Item { width: parent.width; height: 8; visible: contactOrg.length > 0 }

            Rectangle {
                visible: contactOrg.length > 0
                width: parent.width; height: 56
                color: "white"; border.color: "#e5e7eb"; border.width: 0.5

                Column {
                    anchors { left: parent.left; leftMargin: 20; verticalCenter: parent.verticalCenter }
                    spacing: 2
                    Text { text: "Entreprise"; font.pixelSize: 11; color: "#9ca3af" }
                    Text { text: contactOrg; font.pixelSize: 15; color: "#111827" }
                }
            }

            // ── Bouton Supprimer ──────────────────────────────
            Item { width: parent.width; height: 32 }

            Rectangle {
                width: parent.width - 40; height: 48; radius: 12
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#fee2e2"; border.color: "#fca5a5"; border.width: 1

                Row {
                    anchors.centerIn: parent
                    spacing: 8
                    Text { text: "🗑"; font.pixelSize: 18; color: "#ef4444" }
                    Text { text: "Supprimer ce contact"; font.pixelSize: 15; font.bold: true; color: "#ef4444" }
                }

                MouseArea { anchors.fill: parent; onClicked: deleteDialog.visible = true }
            }

            Item { width: parent.width; height: 30 }
        }
    }
}
