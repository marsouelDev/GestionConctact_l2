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
            var c = liste[i]

            var premierTel = ""
            var nbTel = 0
            if (c.telephones && c.telephones.length > 0) {
                nbTel = c.telephones.length
                var t0 = c.telephones[0]
                premierTel = (typeof t0 === "string") ? t0 : (t0.numero || "")
            } else {
                premierTel = c.telephone || ""
            }

            contactsModel.append({
                id: c.id,
                nom: c.nom || "",
                prenom: c.prenom || "",
                email: c.email || "",
                localite: c.localite || "",
                organisation: c.organisation || "",
                telephone: premierTel,
                nbTelephones: nbTel,
                favori: c.favori === true,
                telephones: c.telephones
            })
        }
    }

    function filtrerContacts(terme) {
        contactsModel.clear()
        var recherche = terme.toLowerCase().trim()
        var liste = contactsManager.listContact()

        for (var i = 0; i < liste.length; i++) {
            var c = liste[i]
            var trouve = false

            var texte = (
                (c.nom || "") + " " + (c.prenom || "") + " " +
                (c.email || "") + " " + (c.localite || "") + " " +
                (c.organisation || "") + " " + (c.telephone || "")
            ).toLowerCase()

            if (recherche === "" || texte.indexOf(recherche) >= 0) {
                trouve = true
            }

            if (!trouve && c.telephones) {
                for (var j = 0; j < c.telephones.length; j++) {
                    var telData = c.telephones[j]
                    var numero = ""
                    if (typeof telData === "string") {
                        numero = telData
                    } else if (telData && telData.numero) {
                        numero = telData.numero.toString()
                    }
                    if (numero.toLowerCase().indexOf(recherche) >= 0) {
                        trouve = true
                        break
                    }
                }
            }

            if (trouve) {
                var premierTel = ""
                var nbTel = 0
                if (c.telephones && c.telephones.length > 0) {
                    nbTel = c.telephones.length
                    var t0 = c.telephones[0]
                    premierTel = (typeof t0 === "string") ? t0 : (t0.numero || "")
                } else {
                    premierTel = c.telephone || ""
                }

                contactsModel.append({
                    id: c.id,
                    nom: c.nom || "",
                    prenom: c.prenom || "",
                    email: c.email || "",
                    localite: c.localite || "",
                    organisation: c.organisation || "",
                    telephone: premierTel,
                    nbTelephones: nbTel,
                    favori: c.favori === true,
                    telephones: c.telephones
                })
            }
        }
    }

    Component.onCompleted: chargerContacts()
    StackView.onActivating: chargerContacts()

    Connections {
        target: contactsManager
        function onContactsChanged() { chargerContacts() }
    }

    // ─────────────────────────────────────────────────────────
    Column {
        anchors.fill: parent
        spacing: 14

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
                    text: ""; font.pixelSize: 16; color: "#9ca3af"
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

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // ✅ Utiliser root.nav
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

                        Rectangle {
                            visible: model.favori === true
                            width: 16; height: 16; radius: 8
                            color: "#f59e0b"
                            anchors { right: parent.right; bottom: parent.bottom; margins: 1 }
                            Text { anchors.centerIn: parent; text: "★"; font.pixelSize: 8; color: "white" }
                        }
                    }

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2
                        width: parent.width - 140

                        Text {
                            text: (model.prenom || "") + " " + (model.nom || "")
                            font.pixelSize: 15
                            font.bold: true
                            color: "#1f2937"
                            elide: Text.ElideRight
                            width: parent.width
                        }

                        Text {
                            text: {
                                var t = model.telephone || ""
                                var nb = model.nbTelephones || 0
                                if (nb > 1) return t + " (+" + (nb - 1) + " autre" + (nb > 2 ? "s" : "") + ")"
                                return t
                            }
                            color: "#6b7280"
                            font.pixelSize: 12
                            elide: Text.ElideRight
                            width: parent.width
                        }
                    }

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
            // ✅ Utiliser root.nav
            onClicked: root.nav.push(Qt.resolvedUrl("AjouterContacts.qml"))
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

        Rectangle {
            width: parent.width
            height: 1
            color: "#00000010"
        }

        Row {
            anchors.centerIn: parent
            spacing: 60

            Rectangle {
                width: 120; height: 40; radius: 14; color: "#dbeafe"
                Text { anchors.centerIn: parent; text: "Contacts"; color: "#005da7"; font.bold: true }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // ✅ Utiliser root.nav
                        while (root.nav.depth > 1) root.nav.pop()
                    }
                }
            }

            Rectangle {
                width: 120; height: 40; radius: 14; color: "#f3f4f4"
                Text { anchors.centerIn: parent; text: "Favoris"; color: "#6b7280"; font.bold: true }
                MouseArea {
                    anchors.fill: parent
                    // ✅ Utiliser root.nav
                    onClicked: root.nav.push(Qt.resolvedUrl("FavorisContacts.qml"))
                }
            }
        }
    }
}