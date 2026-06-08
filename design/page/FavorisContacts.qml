import QtQuick 2.15
import QtQuick.Controls 2.15

Page {
    id: favorisPage
    background: Rectangle { color: "#f5f7fb" }

    // ✅ Accès robuste au StackView parent
    property var nav: {
        var p = parent
        while (p) {
            if (p.hasOwnProperty("depth") && p.hasOwnProperty("push")) return p
            p = p.parent
        }
        return StackView.view
    }

    // ================= HEADER =================
    Rectangle {
        id: appBar
        height: 64
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        color: "white"

        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: "#e5e7eb"
        }

        Text {
            anchors.centerIn: parent
            text: "⭐ Favoris"
            font.pixelSize: 20
            font.bold: true
            color: "#111827"
        }
    }

    // ================= MODELS =================
    ListModel { id: favorisModel }

    // ✅ Stockage intermédiaire en JS (supporte les tableaux de téléphones)
    property var allFavoris: []

    function chargerFavoris() {
        allFavoris = contactsManager.getFavoris()
        filtrerFavoris(searchField.text)
    }

    function filtrerFavoris(terme) {
        favorisModel.clear()

        var t = terme.toLowerCase().trim()

        for (var i = 0; i < allFavoris.length; i++) {
            var c = allFavoris[i]

            var full = ((c.prenom || "") + " " + (c.nom || "")).toLowerCase()
            var email = (c.email || "").toLowerCase()
            var localite = (c.localite || "").toLowerCase()
            var org = (c.organisation || "").toLowerCase()

            var trouve = (t === "" ||
                          full.indexOf(t) >= 0 ||
                          email.indexOf(t) >= 0 ||
                          localite.indexOf(t) >= 0 ||
                          org.indexOf(t) >= 0)

            // ✅ Recherche dans TOUS les numéros de téléphone
            if (!trouve && c.telephones) {
                for (var j = 0; j < c.telephones.length; j++) {
                    var telData = c.telephones[j]
                    var numero = ""
                    if (typeof telData === "string") {
                        numero = telData
                    } else if (telData && telData.numero) {
                        numero = telData.numero.toString()
                    }
                    if (numero.toLowerCase().indexOf(t) >= 0) {
                        trouve = true
                        break
                    }
                }
            }

            // ✅ Fallback sur l'ancien champ "telephone" (compatibilité)
            if (!trouve && c.telephone) {
                if (c.telephone.toLowerCase().indexOf(t) >= 0) {
                    trouve = true
                }
            }

            if (trouve) {
                // ✅ Préparation des données pour l'affichage
                var premierTel = ""
                var nbTel = 0
                if (c.telephones && c.telephones.length > 0) {
                    nbTel = c.telephones.length
                    var t0 = c.telephones[0]
                    premierTel = (typeof t0 === "string") ? t0 : (t0.numero || "")
                } else {
                    premierTel = c.telephone || ""
                }

                favorisModel.append({
                    id: c.id,
                    nom: c.nom || "",
                    prenom: c.prenom || "",
                    email: c.email || "",
                    localite: c.localite || "",
                    organisation: c.organisation || "",
                    telephone: premierTel,
                    nbTelephones: nbTel,
                    favori: true
                })
            }
        }
    }

    Component.onCompleted: chargerFavoris()
    StackView.onActivating: chargerFavoris()

    Connections {
        target: contactsManager
        function onFavorisChanged() { chargerFavoris() }
        function onContactsChanged() { chargerFavoris() }
    }

    // ================= SEARCH BAR =================
    Rectangle {
        id: searchBar
        height: 48
        radius: 14
        anchors {
            top: appBar.bottom
            left: parent.left
            right: parent.right
            margins: 14
        }

        color: "white"
        border.color: "#e5e7eb"

        Row {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            Text {
                text: "🔍"
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }

            TextField {
                id: searchField
                width: parent.width - 40
                placeholderText: "Rechercher un favori..."
                font.pixelSize: 14
                color: "#111827"
                background: Rectangle { color: "transparent" }

                onTextChanged: filtrerFavoris(text)
            }
        }
    }

    // ================= EMPTY STATE =================
    Item {
        anchors.centerIn: parent
        visible: favorisModel.count === 0

        Column {
            spacing: 12
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: "⭐"
                font.pixelSize: 80
                color: "#d1d5db"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "Aucun favori"
                font.pixelSize: 18
                font.bold: true
                color: "#374151"
            }

            Text {
                text: "Ajoute des contacts pour les retrouver ici"
                font.pixelSize: 12
                color: "#9ca3af"
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    // ================= LIST =================
    ListView {
        anchors {
            top: searchBar.bottom
            left: parent.left
            right: parent.right
            bottom: bottomNav.top
            margins: 10
        }

        model: favorisModel
        spacing: 12
        clip: true

        delegate: Rectangle {
            width: ListView.view.width - 20
            height: 82
            radius: 18
            anchors.horizontalCenter: parent.horizontalCenter

            color: "white"
            border.color: "#e5e7eb"
            border.width: 1

            Row {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 12

                // ================= AVATAR + INFOS (zone cliquable pour navigation) =================
                Item {
                    width: parent.width - 60  // ✅ Laisse la place pour le bouton étoile
                    height: parent.height

                    Rectangle {
                        width: parent.width
                        height: parent.height
                        radius: 12
                        color: hoverArea.containsMouse ? "#f9fafb" : "transparent"

                        Behavior on color { ColorAnimation { duration: 150 } }
                    }

                    Row {
                        anchors.fill: parent
                        spacing: 12

                        // ================= AVATAR =================
                        Rectangle {
                            width: 50
                            height: 50
                            radius: 25
                            color: "#005da7"
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                anchors.centerIn: parent
                                text: (model.prenom ? model.prenom[0] : "") +
                                      (model.nom ? model.nom[0] : "")
                                color: "white"
                                font.bold: true
                                font.pixelSize: 16
                            }

                            Rectangle {
                                width: 16
                                height: 16
                                radius: 8
                                color: "#f59e0b"
                                anchors { right: parent.right; bottom: parent.bottom; margins: 2 }

                                Text {
                                    anchors.centerIn: parent
                                    text: "★"
                                    font.pixelSize: 10
                                    color: "white"
                                }
                            }
                        }

                        // ================= INFOS =================
                        Column {
                            width: parent.width - 62
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 3

                            Text {
                                text: (model.prenom || "") + " " + (model.nom || "")
                                font.pixelSize: 15
                                font.bold: true
                                color: "#111827"
                                elide: Text.ElideRight
                                width: parent.width
                            }

                            Text {
                                // ✅ Affiche le premier numéro + "(+X autres)" si nécessaire
                                text: {
                                    var t = model.telephone || model.email || ""
                                    var nb = model.nbTelephones || 0
                                    if (nb > 1) return t + " (+" + (nb - 1) + " autre" + (nb > 2 ? "s" : "") + ")"
                                    return t
                                }
                                font.pixelSize: 12
                                color: "#6b7280"
                                elide: Text.ElideRight
                                width: parent.width
                            }
                        }
                    }

                    // ✅ MouseArea pour la navigation (couvre avatar + infos)
                    MouseArea {
                        id: hoverArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            nav.push(Qt.resolvedUrl("DetailsContacts.qml"), {
                                contactId: model.id
                            })
                        }
                    }
                }

                // ================= REMOVE FAVORI (bouton indépendant) =================
                Rectangle {
                    width: 40
                    height: 40
                    radius: 20
                    color: starHover.containsMouse ? "#fde68a" : "#fef3c7"
                    anchors.verticalCenter: parent.verticalCenter

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: "★"
                        font.pixelSize: 18
                        color: "#f59e0b"
                    }

                    MouseArea {
                        id: starHover
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            contactsManager.setFavori(model.id, false)
                        }
                    }
                }
            }
        }
    }

    // ================= BOTTOM NAV =================
    Rectangle {
        id: bottomNav
        height: 72
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        color: "white"

        Rectangle {
            width: parent.width
            height: 1
            color: "#e5e7eb"
        }

        Row {
            anchors.centerIn: parent
            spacing: 50

            // Contacts
            Rectangle {
                width: 110
                height: 42
                radius: 12
                color: contactsHover.containsMouse ? "#e5e7eb" : "#f3f4f6"

                Behavior on color { ColorAnimation { duration: 150 } }

                Text {
                    anchors.centerIn: parent
                    text: "Contacts"
                    font.bold: true
                    color: "#374151"
                }

                MouseArea {
                    id: contactsHover
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        // ✅ Retour propre à la liste principale
                        while (nav && nav.depth > 1) {
                            nav.pop()
                        }
                    }
                }
            }

            // Favoris (actif)
            Rectangle {
                width: 110
                height: 42
                radius: 12
                color: "#dbeafe"

                Text {
                    anchors.centerIn: parent
                    text: "Favoris"
                    font.bold: true
                    color: "#005da7"
                }
            }

            // Ajouter
            Rectangle {
                width: 110
                height: 42
                radius: 12
                color: ajouterHover.containsMouse ? "#e0e7ff" : "#eef2ff"

                Behavior on color { ColorAnimation { duration: 150 } }

                Text {
                    anchors.centerIn: parent
                    text: "+ Ajouter"
                    font.bold: true
                    color: "#4f46e5"
                }

                MouseArea {
                    id: ajouterHover
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: nav.push(Qt.resolvedUrl("AjouterContacts.qml"))
                }
            }
        }
    }
}