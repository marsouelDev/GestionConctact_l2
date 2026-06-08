import QtQuick 2.15
import QtQuick.Controls 2.15

Page {
    id: modifPage
    background: Rectangle { color: "#f0f2f5" }

    property int contactId: -1

    // ================= MODELE TELEPHONE =================
    ListModel { id: phoneModel }

    // ── Chargement des données actuelles ──────────────────────
    Component.onCompleted: {
        if (contactId < 0) return
        var c = contactsManager.getContactById(contactId)
        if (c && c.id !== undefined) {
            prenomField.text   = c.prenom       || ""
            nomField.text      = c.nom          || ""
            emailField.text    = c.email        || ""
            localiteField.text = c.localite     || ""
            orgField.text      = c.organisation || ""

            // ✅ Remplir le phoneModel avec TOUS les téléphones existants
            phoneModel.clear()
            if (c.telephones && c.telephones.length > 0) {
                for (var i = 0; i < c.telephones.length; i++) {
                    var telData = c.telephones[i]
                    var num  = (typeof telData === "string") ? telData : (telData.numero || "")
                    var type = (typeof telData === "string") ? 1       : (telData.type || 1)
                    phoneModel.append({ numero: num, type: type })
                }
            } else if (c.telephone && c.telephone.length > 0) {
                phoneModel.append({ numero: c.telephone, type: 1 })
            } else {
                phoneModel.append({ numero: "", type: 1 })
            }
        }
    }

    // ══════════════════════════════════════════════════════════
    //  SAUVEGARDE : envoie la liste complète des téléphones
    // ══════════════════════════════════════════════════════════
    function sauvegarderModification() {
        if (nomField.text.trim() === "" && prenomField.text.trim() === "") {
            erreurMsgModif.text = "Veuillez entrer au moins un Nom ou un Prénom."
            popupErreurModif.visible = true
            return
        }

        // ✅ Construire la liste de tous les téléphones
        var telephones = []
        for (var i = 0; i < phoneModel.count; i++) {
            var p = phoneModel.get(i)
            if (p.numero.trim() !== "") {
                telephones.push({
                    numero: p.numero.trim(),
                    type: p.type
                })
            }
        }

        var ok = contactsManager.updateContact(
            contactId,
            nomField.text.trim(),
            prenomField.text.trim(),
            emailField.text.trim(),
            localiteField.text.trim(),
            orgField.text.trim(),
            telephones   // ✅ Liste complète envoyée au C++
        )

        if (ok) {
            popupEnregistrer.visible = false
            root.nav.pop()
        } else {
            erreurMsgModif.text = "Erreur lors de la mise à jour en base de données."
            popupErreurModif.visible = true
        }
    }

    // ✅ Validation avant d'ouvrir le popup
    function validerEtConfirmer() {
        if (nomField.text.trim() === "" && prenomField.text.trim() === "") {
            erreurMsgModif.text = "Veuillez entrer au moins un Nom ou un Prénom."
            popupErreurModif.visible = true
            return
        }
        popupEnregistrer.visible = true
    }

    // ══════════════════════════════════════════════════════════
    //  POPUP — CONFIRMATION ENREGISTREMENT MODIFICATION
    // ══════════════════════════════════════════════════════════
    Rectangle {
        id: popupEnregistrer
        visible: false; z: 200
        anchors.fill: parent; color: "#80000000"

        Rectangle {
            width: 300; height: 210; radius: 16; color: "white"
            anchors.centerIn: parent

            Column {
                anchors.centerIn: parent
                spacing: 18; width: parent.width - 48

                Text { anchors.horizontalCenter: parent.horizontalCenter; text: "💾"; font.pixelSize: 36 }
                Text {
                    width: parent.width
                    text: "Enregistrer les modifications ?"
                    font.pixelSize: 15; font.bold: true; color: "#111827"
                    horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WordWrap
                }
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter; spacing: 12

                    Rectangle {
                        width: 110; height: 42; radius: 10
                        color: "#f3f4f6"; border.color: "#d1d5db"
                        Text { anchors.centerIn: parent; text: "Annuler"; font.pixelSize: 14; color: "#374151" }
                        MouseArea { anchors.fill: parent; onClicked: popupEnregistrer.visible = false }
                    }
                    Rectangle {
                        width: 110; height: 42; radius: 10; color: "#005da7"
                        Text { anchors.centerIn: parent; text: "Confirmer"; font.pixelSize: 14; color: "white"; font.bold: true }
                        MouseArea { anchors.fill: parent; onClicked: sauvegarderModification() }
                    }
                }
            }
        }
    }

    // ══════════════════════════════════════════════════════════
    //  POPUP — CONFIRMATION ANNULATION MODIFICATION
    // ══════════════════════════════════════════════════════════
    Rectangle {
        id: popupAnnuler
        visible: false; z: 200
        anchors.fill: parent; color: "#80000000"

        Rectangle {
            width: 300; height: 210; radius: 16; color: "white"
            anchors.centerIn: parent

            Column {
                anchors.centerIn: parent
                spacing: 18; width: parent.width - 48

                Text { anchors.horizontalCenter: parent.horizontalCenter; text: "⚠️"; font.pixelSize: 36 }
                Text {
                    width: parent.width
                    text: "Annuler les modifications ?\nLes changements seront perdus."
                    font.pixelSize: 15; font.bold: true; color: "#111827"
                    horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WordWrap
                }
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter; spacing: 12

                    Rectangle {
                        width: 110; height: 42; radius: 10
                        color: "#f3f4f6"; border.color: "#d1d5db"
                        Text { anchors.centerIn: parent; text: "Continuer"; font.pixelSize: 13; color: "#374151" }
                        MouseArea { anchors.fill: parent; onClicked: popupAnnuler.visible = false }
                    }
                    Rectangle {
                        width: 110; height: 42; radius: 10; color: "#ef4444"
                        Text { anchors.centerIn: parent; text: "Quitter"; font.pixelSize: 14; color: "white"; font.bold: true }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: { popupAnnuler.visible = false; root.nav.pop() }
                        }
                    }
                }
            }
        }
    }

    // ══════════════════════════════════════════════════════════
    //  POPUP ERREUR MODIFICATION
    // ══════════════════════════════════════════════════════════
    Rectangle {
        id: popupErreurModif
        visible: false; z: 300
        anchors.fill: parent; color: "#80000000"

        Rectangle {
            width: 300; height: 190; radius: 16; color: "white"
            anchors.centerIn: parent

            Column {
                anchors.centerIn: parent
                spacing: 18; width: parent.width - 48

                Text { anchors.horizontalCenter: parent.horizontalCenter; text: "⚠️"; font.pixelSize: 36 }
                Text {
                    id: erreurMsgModif
                    width: parent.width
                    text: "Veuillez remplir les informations obligatoires."
                    font.pixelSize: 14; color: "#111827"
                    horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WordWrap
                }
                Rectangle {
                    width: 120; height: 42; radius: 10; color: "#005da7"
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text { anchors.centerIn: parent; text: "OK"; font.pixelSize: 14; color: "white"; font.bold: true }
                    MouseArea { anchors.fill: parent; onClicked: popupErreurModif.visible = false }
                }
            }
        }
    }

    // ── Header ────────────────────────────────────────────────
    Rectangle {
        id: appBar; z: 10
        anchors { top: parent.top; left: parent.left; right: parent.right }
        height: 56; color: "white"; border.color: "#e5e7eb"; border.width: 0.5

        Rectangle {
            width: 32; height: 32; radius: 16
            color: closeHover.containsMouse ? "#f3f4f6" : "transparent"
            anchors { left: parent.left; leftMargin: 16; verticalCenter: parent.verticalCenter }
            Text { anchors.centerIn: parent; text: "✕"; font.pixelSize: 16; color: "#374151" }
            MouseArea {
                id: closeHover; hoverEnabled: true; anchors.fill: parent
                onClicked: popupAnnuler.visible = true
            }
        }

        Text {
            anchors.centerIn: parent
            text: "Modifier le contact"
            font.pixelSize: 16; font.bold: true; color: "#111827"
        }

        Rectangle {
            width: 110; height: 34; radius: 8; color: "#005da7"
            anchors { right: parent.right; rightMargin: 16; verticalCenter: parent.verticalCenter }
            Text { anchors.centerIn: parent; text: "Enregistrer"; color: "white"; font.pixelSize: 13; font.bold: true }
            MouseArea { anchors.fill: parent; onClicked: validerEtConfirmer() }
        }
    }

    // ── Contenu scrollable ────────────────────────────────────
    Flickable {
        anchors { top: appBar.bottom; left: parent.left; right: parent.right; bottom: bottomBar.top }
        clip: true
        contentHeight: mainCol.implicitHeight + 40

        Column {
            id: mainCol; width: parent.width; spacing: 0

            // ── Avatar dynamique ──────────────────────────────
            Item {
                width: parent.width; height: 130
                Column {
                    anchors.centerIn: parent; spacing: 8
                    Rectangle {
                        width: 80; height: 80; radius: 40; color: "#005da7"
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text {
                            anchors.centerIn: parent
                            text: {
                                var p = prenomField.text.length > 0 ? prenomField.text[0].toUpperCase() : "?"
                                var n = nomField.text.length > 0    ? nomField.text[0].toUpperCase()    : ""
                                return p + n
                            }
                            font.pixelSize: 28; font.bold: true; color: "white"
                        }
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: (prenomField.text + " " + nomField.text).trim()
                        font.pixelSize: 13; color: "#374151"; font.bold: true
                    }
                }
            }

            // ── Informations personnelles ─────────────────────
            Item { width: parent.width; height: 16 }
            Text { text: "INFORMATIONS PERSONNELLES"; color: "#9ca3af"; font.pixelSize: 11; font.bold: true; leftPadding: 20 }
            Item { width: parent.width; height: 8 }

            Rectangle {
                width: parent.width; implicitHeight: colInfo.implicitHeight
                color: "white"; border.color: "#e5e7eb"; border.width: 0.5

                Column {
                    id: colInfo; width: parent.width

                    Column {
                        width: parent.width; topPadding: 12; bottomPadding: 8; spacing: 4
                        Text { text: "Prénom *"; font.pixelSize: 12; color: "#374151"; font.bold: true; leftPadding: 20 }
                        TextField {
                            id: prenomField; x: 20; width: parent.width - 40
                            placeholderText: "Ex: Jean"
                            background: Rectangle { color: "#f9fafb"; radius: 8; border.color: "#e5e7eb" }
                            font.pixelSize: 14; color: "#111827"; leftPadding: 12
                        }
                    }

                    Rectangle { width: parent.width; height: 1; color: "#f3f4f6" }

                    Column {
                        width: parent.width; topPadding: 12; bottomPadding: 12; spacing: 4
                        Text { text: "Nom *"; font.pixelSize: 12; color: "#374151"; font.bold: true; leftPadding: 20 }
                        TextField {
                            id: nomField; x: 20; width: parent.width - 40
                            placeholderText: "Ex: Atangana"
                            background: Rectangle { color: "#f9fafb"; radius: 8; border.color: "#e5e7eb" }
                            font.pixelSize: 14; color: "#111827"; leftPadding: 12
                        }
                    }

                    Rectangle { width: parent.width; height: 1; color: "#f3f4f6" }

                    Column {
                        width: parent.width; topPadding: 12; bottomPadding: 12; spacing: 4
                        Text { text: "Localité"; font.pixelSize: 12; color: "#374151"; font.bold: true; leftPadding: 20 }
                        TextField {
                            id: localiteField; x: 20; width: parent.width - 40
                            placeholderText: "Ex: Yaoundé"
                            background: Rectangle { color: "#f9fafb"; radius: 8; border.color: "#e5e7eb" }
                            font.pixelSize: 14; color: "#111827"; leftPadding: 12
                        }
                    }
                }
            }

            // ── Coordonnées (téléphones multiples + email) ────
            Item { width: parent.width; height: 20 }
            Text { text: "COORDONNÉES"; color: "#9ca3af"; font.pixelSize: 11; font.bold: true; leftPadding: 20 }
            Item { width: parent.width; height: 8 }

            Rectangle {
                width: parent.width; implicitHeight: colCoord.implicitHeight + 20
                color: "white"; border.color: "#e5e7eb"; border.width: 0.5

                Column {
                    id: colCoord; width: parent.width
                    spacing: 14; topPadding: 16; bottomPadding: 16

                    // ================= TOUS LES TELEPHONES =================
                    Repeater {
                        model: phoneModel

                        delegate: Item {
                            width: parent.width
                            height: rowTel.implicitHeight

                            Row {
                                id: rowTel
                                anchors { left: parent.left; leftMargin: 20; right: parent.right; rightMargin: 20 }
                                spacing: 12

                                Rectangle {
                                    width: 36; height: 36; radius: 10; color: "#dbeafe"
                                    Text { anchors.centerIn: parent; text: "📞"; font.pixelSize: 18 }
                                }

                                Column {
                                    width: parent.width - 120; spacing: 4

                                    Text {
                                        text: index === 0 ? "Téléphone" : "Téléphone " + (index + 1)
                                        font.pixelSize: 12; font.bold: true; color: "#374151"
                                    }

                                    ComboBox {
                                        width: parent.width
                                        model: ["Mobile", "WhatsApp", "Maison", "Bureau"]
                                        Component.onCompleted: currentIndex = (modelData.type || 1) - 1
                                        onCurrentIndexChanged: phoneModel.setProperty(index, "type", currentIndex + 1)
                                    }

                                    TextField {
                                        width: parent.width
                                        text: numero
                                        placeholderText: "Numéro téléphone"
                                        font.pixelSize: 14; color: "#111827"; leftPadding: 12
                                        background: Rectangle { color: "#f9fafb"; radius: 8; border.color: "#e5e7eb" }
                                        onTextChanged: phoneModel.setProperty(index, "numero", text)
                                    }
                                }

                                // Bouton supprimer (caché si c'est le seul numéro)
                                Rectangle {
                                    width: 36; height: 36; radius: 18; color: "#fee2e2"
                                    visible: phoneModel.count > 1
                                    Text { anchors.centerIn: parent; text: "🗑"; font.pixelSize: 16 }
                                    MouseArea { anchors.fill: parent; onClicked: phoneModel.remove(index) }
                                }
                            }
                        }
                    }

                    // AJOUTER NUMERO
                    Rectangle {
                        width: 170; height: 38; radius: 8; color: "#eff6ff"
                        anchors.left: parent.left; anchors.leftMargin: 20
                        Text { anchors.centerIn: parent; text: "+ Ajouter numéro"; color: "#005da7"; font.bold: true; font.pixelSize: 13 }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: phoneModel.append({ numero: "", type: 1 })
                        }
                    }

                    Rectangle { width: parent.width; height: 1; color: "#f3f4f6" }

                    // ================= EMAIL =================
                    Item {
                        width: parent.width; height: rowEmail.implicitHeight
                        Row {
                            id: rowEmail
                            anchors { left: parent.left; leftMargin: 20; right: parent.right; rightMargin: 20 }
                            spacing: 12

                            Rectangle { width: 36; height: 36; radius: 10; color: "#d1fae5"
                                Text { anchors.centerIn: parent; text: "✉️"; font.pixelSize: 18 }
                            }

                            Column {
                                width: parent.width - 48; spacing: 4
                                Text { text: "E-mail"; font.pixelSize: 12; color: "#374151"; font.bold: true }
                                TextField {
                                    id: emailField; width: parent.width
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

            // ── Détails supplémentaires ───────────────────────
            Item { width: parent.width; height: 20 }
            Text { text: "DÉTAILS SUPPLÉMENTAIRES"; color: "#9ca3af"; font.pixelSize: 11; font.bold: true; leftPadding: 20 }
            Item { width: parent.width; height: 8 }

            Rectangle {
                width: parent.width; implicitHeight: colDetails.implicitHeight
                color: "white"; border.color: "#e5e7eb"; border.width: 0.5

                Column {
                    id: colDetails; width: parent.width; topPadding: 12; bottomPadding: 12; spacing: 4
                    Text { text: "Entreprise / Organisation"; font.pixelSize: 12; color: "#374151"; font.bold: true; leftPadding: 20 }
                    TextField {
                        id: orgField; x: 20; width: parent.width - 40
                        placeholderText: "Nom de l'entreprise"
                        background: Rectangle { color: "#f9fafb"; radius: 8; border.color: "#e5e7eb" }
                        font.pixelSize: 14; color: "#111827"; leftPadding: 12
                    }
                }
            }

            Item { width: parent.width; height: 20 }
        }
    }

    // ── Barre du bas ──────────────────────────────────────────
    Rectangle {
        id: bottomBar
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
        height: 72; color: "white"; border.color: "#e5e7eb"; border.width: 0.5

        Row {
            anchors.centerIn: parent; spacing: 16

            Rectangle {
                width: 140; height: 44; radius: 10
                color: "#f3f4f6"; border.color: "#d1d5db"
                Text { anchors.centerIn: parent; text: "Annuler"; font.pixelSize: 15; color: "#374151"; font.bold: true }
                MouseArea { anchors.fill: parent; onClicked: popupAnnuler.visible = true }
            }

            Rectangle {
                width: 140; height: 44; radius: 10; color: "#005da7"
                Text { anchors.centerIn: parent; text: "Enregistrer"; font.pixelSize: 15; color: "white"; font.bold: true }
                MouseArea { anchors.fill: parent; onClicked: validerEtConfirmer() }
            }
        }
    }
}