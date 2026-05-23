import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: favorisPage
    background: Rectangle { color: "#f0f2f5" }

    // ── Header ───────────────────────────────────────────────
    Rectangle {
        id: appBar
        z: 10
        anchors { top: parent.top; left: parent.left; right: parent.right }
        height: 56
        color: "white"; border.color: "#e5e7eb"; border.width: 0.5

        Text {
            anchors.centerIn: parent
            text: "⭐ Favoris"
            font.pixelSize: 17; font.bold: true; color: "#111827"
        }

        // Compteur
        Rectangle {
            visible: favorisModel.count > 0
            width: countText.implicitWidth + 16
            height: 24; radius: 12
            color: "#fef3c7"
            anchors { right: parent.right; rightMargin: 16; verticalCenter: parent.verticalCenter }
            Text {
                id: countText
                anchors.centerIn: parent
                text: favorisModel.count + " contact" + (favorisModel.count > 1 ? "s" : "")
                font.pixelSize: 12; color: "#92400e"; font.bold: true
            }
        }
    }

    // Modèle chargé depuis la BD
    ListModel { id: favorisModel }

    // Rechargement à chaque fois que la page devient visible
    // (ex: après avoir retiré un favori dans DetailsContacts)
    Connections {
        target: contactsManager
        function onFavorisChanged() { chargerFavoris() }
        function onContactsChanged() { chargerFavoris() }
    }

    Component.onCompleted: chargerFavoris()

    function chargerFavoris() {
        favorisModel.clear()
        var liste = contactsManager.getFavoris()
        for (var i = 0; i < liste.length; i++) {
            favorisModel.append(liste[i])
        }
    }

    // ── État vide ────────────────────────────────────────────
    Column {
        visible: favorisModel.count === 0
        anchors.centerIn: parent
        spacing: 16

        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "★"; font.pixelSize: 60; color: "#d1d5db" }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Aucun favori"
            font.pixelSize: 18; font.bold: true; color: "#374151"
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Marquez un contact avec ★\npour le retrouver ici."
            font.pixelSize: 13; color: "#9ca3af"
            horizontalAlignment: Text.AlignHCenter
        }
    }

    // ── Liste des favoris ────────────────────────────────────
    ListView {
        visible: favorisModel.count > 0
        anchors { top: appBar.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
        model: favorisModel
        clip: true
        spacing: 0

        // En-tête : champ de recherche
        header: Item {
            width: parent.width; height: 64

            Rectangle {
                width: parent.width - 32; height: 42; radius: 12
                anchors.centerIn: parent
                color: "white"; border.color: "#e5e7eb"; border.width: 1

                Row {
                    anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 12 }
                    spacing: 8
                    Text { text: "🔍"; font.pixelSize: 16; color: "#9ca3af" }
                    TextInput {
                        id: searchInput
                        width: 260
                        anchors.verticalCenter: parent.verticalCenter
                        placeholderText: "Rechercher dans les favoris…"
                        font.pixelSize: 14; color: "#111827"
                        // Filtrage côté QML simple
                        onTextChanged: {
                            favorisModel.clear()
                            var liste = contactsManager.getFavoris()
                            for (var i = 0; i < liste.length; i++) {
                                var full = (liste[i].prenom + " " + liste[i].nom).toLowerCase()
                                if (text.trim() === "" || full.indexOf(text.toLowerCase()) >= 0) {
                                    favorisModel.append(liste[i])
                                }
                            }
                        }
                    }
                }
            }
        }

        delegate: Rectangle {
            width: ListView.view.width
            height: 72
            color: delegateHover.containsMouse ? "#f9fafb" : "white"
            border.color: "#f3f4f6"; border.width: 0.5

            Row {
                anchors {
                    left: parent.left; leftMargin: 16
                    right: parent.right; rightMargin: 16
                    verticalCenter: parent.verticalCenter
                }
                spacing: 14

                // Avatar initiales
                Rectangle {
                    width: 48; height: 48; radius: 24
                    color: "#005da7"
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: {
                            var p = model.prenom && model.prenom.length > 0 ? model.prenom[0].toUpperCase() : ""
                            var n = model.nom && model.nom.length > 0 ? model.nom[0].toUpperCase() : ""
                            return p + n
                        }
                        font.pixelSize: 18; font.bold: true; color: "white"
                    }

                    // Badge étoile
                    Rectangle {
                        width: 18; height: 18; radius: 9
                        color: "#f59e0b"
                        anchors { right: parent.right; bottom: parent.bottom; margins: 1 }
                        Text { anchors.centerIn: parent; text: "★"; font.pixelSize: 9; color: "white" }
                    }
                }

                // Infos
                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2
                    width: parent.width - 48 - 14 - 40 - 14

                    Text {
                        text: (model.prenom || "") + " " + (model.nom || "")
                        font.pixelSize: 15; font.bold: true; color: "#111827"
                        elide: Text.ElideRight; width: parent.width
                    }
                    Text {
                        text: model.telephone || model.email || ""
                        font.pixelSize: 13; color: "#6b7280"
                        elide: Text.ElideRight; width: parent.width
                    }
                    Text {
                        visible: (model.organisation || "").length > 0
                        text: model.organisation || ""
                        font.pixelSize: 11; color: "#9ca3af"
                        elide: Text.ElideRight; width: parent.width
                    }
                }

                // Bouton retirer favori
                Rectangle {
                    width: 36; height: 36; radius: 18
                    color: "#fef3c7"
                    anchors.verticalCenter: parent.verticalCenter

                    Text { anchors.centerIn: parent; text: "★"; font.pixelSize: 18; color: "#f59e0b" }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            contactsManager.setFavori(model.id, false)
                            // Le signal onFavorisChanged rechargera la liste
                        }
                    }
                }
            }

            // Clic → Détail
            MouseArea {
                id: delegateHover
                hoverEnabled: true
                anchors.fill: parent
                // Ne pas bloquer les clics sur le bouton étoile
                onClicked: {
                    root.nav.push("qrc:/design/page/DetailsContacts.qml", { contactId: model.id })
                }
            }
        }
    }
}
