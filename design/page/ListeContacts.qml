import QtQuick 2.15
import QtQuick.Controls 2.15
import "qrc:/design/Components"

Page {
    id: listePage

    background: Rectangle { color: "#f8f9fa" }

    // ── Modèle local rechargeable ─────────────────────────────
    ListModel { id: contactsModel }

    function chargerContacts() {
        contactsModel.clear()
        var liste = contactsManager.listContact()
        for (var i = 0; i < liste.length; i++) {
            contactsModel.append(liste[i])
        }
    }

    function filtrerContacts(terme) {
        contactsModel.clear()
        var liste = contactsManager.listContact()
        for (var i = 0; i < liste.length; i++) {
            var full = ((liste[i].prenom || "") + " " + (liste[i].nom || "")).toLowerCase()
            if (terme.trim() === "" || full.indexOf(terme.toLowerCase()) >= 0)
                contactsModel.append(liste[i])
        }
    }

    Component.onCompleted: chargerContacts()

    // Rafraîchit quand on revient sur cette page (pop depuis n'importe où)
    StackView.onActivating: chargerContacts()

    // Rafraîchit sur signal C++ (addContact, updateContact, deleteContact, setFavori)
    Connections {
        target: contactsManager
        function onContactsChanged() { chargerContacts() }
    }

    // ─────────────────────────────────────────────────────────
    Column {
        anchors.fill: parent
        spacing: 14

        // ================= APP BAR =================
        CustomAppBar { title: "Contacts" }

        // ================= SEARCH =================
        Rectangle {
            width: parent.width - 40
            height: 48
            radius: 24
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#eef1f4"
            clip: true

            Row {
                anchors.fill: parent
                anchors.leftMargin: 16; anchors.rightMargin: 16
                spacing: 8

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "🔍"; font.pixelSize: 16; color: "#9ca3af"
                }

                TextField {
                    id: searchField
                    width: parent.width - 30
                    height: parent.height
                    placeholderText: "Rechercher un contact"
                    color: "#111827"
                    placeholderTextColor: "#9ca3af"
                    font.pixelSize: 14
                    verticalAlignment: TextInput.AlignVCenter
                    background: Rectangle { color: "transparent" }
                    leftPadding: 0
                    onTextChanged: filtrerContacts(text)
                }
            }
        }

        // ================= LIST =================
        ListView {
            id: contactsList
            width: parent.width
            height: parent.height - 260
            spacing: 12
            clip: true
            model: contactsModel

            delegate: Rectangle {
                width: contactsList.width - 24
                height: 76
                radius: 14
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
                border.color: "#e5e7eb"
                border.width: 1

                // Clic ligne → DetailsContacts
                // Qt.resolvedUrl résout le chemin relatif depuis ce fichier QML
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.nav.push(
                            Qt.resolvedUrl("DetailsContacts.qml"),
                            { contactId: model.id }
                        )
                    }
                }

                Row {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 12

                    // Avatar initiales
                    Rectangle {
                        width: 44; height: 44; radius: 22
                        color: "#005da7"
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            anchors.centerIn: parent
                            text: {
                                var p = (model.prenom || "").length > 0 ? model.prenom[0].toUpperCase() : ""
                                var n = (model.nom    || "").length > 0 ? model.nom[0].toUpperCase()    : ""
                                return p + n
                            }
                            color: "white"; font.bold: true; font.pixelSize: 15
                        }

                        // Badge favori sur l'avatar
                        Rectangle {
                            visible: model.favori === true
                            width: 16; height: 16; radius: 8
                            color: "#f59e0b"
                            anchors { right: parent.right; bottom: parent.bottom; margins: 1 }
                            Text { anchors.centerIn: parent; text: "★"; font.pixelSize: 8; color: "white" }
                        }
                    }

                    // Nom + téléphone
                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2
                        width: parent.width - 140

                        Text {
                            text: (model.prenom || "") + " " + (model.nom || "")
                            font.pixelSize: 15; font.bold: true; color: "#1f2937"
                            elide: Text.ElideRight; width: parent.width
                        }
                        Text {
                            text: (model.telephone || model.email || "")
                            color: "#6b7280"; font.pixelSize: 12
                            elide: Text.ElideRight; width: parent.width
                        }
                    }

                    // Bouton ★/☆ toggle favori
                    Button {
                        anchors.verticalCenter: parent.verticalCenter
                        background: Rectangle { color: "transparent" }
                        contentItem: Text {
                            text:  model.favori === true ? "★" : "☆"
                            color: model.favori === true ? "#f59e0b" : "#9ca3af"
                            font.pixelSize: 22
                        }
                        onClicked: {
                            contactsManager.setFavori(model.id, !(model.favori === true))
                            // onContactsChanged rechargera automatiquement
                        }
                    }
                }
            }

            Text {
                visible: contactsList.count === 0
                anchors.centerIn: parent
                text: "Aucun contact"
                color: "#9ca3af"; font.pixelSize: 14
            }
        }
    }

    // ================= FAB Ajouter =================
    Rectangle {
        width: 60; height: 60; radius: 30
        color: "#005da7"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20
        anchors.bottomMargin: 90

        Text {
            anchors.centerIn: parent
            text: "+"; color: "white"; font.pixelSize: 30; font.bold: true
        }

        MouseArea {
            anchors.fill: parent
            // Qt.resolvedUrl("AjouterContacts.qml") résout depuis ce dossier
            onClicked: root.nav.push(Qt.resolvedUrl("AjouterContacts.qml"))
        }
    }

    // ================= BOTTOM NAV =================
    Rectangle {
        width: parent.width; height: 72
        anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
        color: "white"; border.color: "#e5e7eb"

        Rectangle { width: parent.width; height: 1; color: "#00000010" }

        Row {
            anchors.centerIn: parent
            spacing: 90

            Button {
                text: "Contacts"
                background: Rectangle { radius: 14; color: "#dbeafe" }
                contentItem: Text { text: parent.text; color: "#005da7"; font.bold: true }
            }

            Button {
                text: "Favoris"
                background: Rectangle { radius: 14; color: "transparent" }
                contentItem: Text { text: parent.text; color: "#6b7280"; font.bold: true }
                // ← Même convention Qt.resolvedUrl que tous les autres push
                onClicked: root.nav.push(Qt.resolvedUrl("FavorisContacts.qml"))
            }
        }
    }
}
