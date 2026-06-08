import QtQuick 2.15
import QtQuick.Controls 2.15

Page {
    id: detailPage
    background: Rectangle { color: "#f0f2f5" }

    property int contactId: -1

    property string contactNom:      ""
    property string contactPrenom:   ""
    property string contactEmail:    ""
    property string contactTel:      ""
    property string contactOrg:      ""
    property string contactLocalite: ""
    property bool   contactFavori:   false

    // ✅ ListModel avec type et libellé
    ListModel { id: telephonesModel }

    // ✅ Fonction pour supprimer le contact
    function supprimerContact() {
        console.log("🗑️ Suppression du contact id:", contactId)
        var ok = contactsManager.deleteContact(contactId)
        console.log("🗑️ Résultat:", ok)
        if (ok) {
            contactsManager.contactsChanged()
            root.nav.pop()
        } else {
            console.error("❌ Échec de la suppression")
        }
    }

    function chargerContact() {
        if (contactId < 0) return
        var c = contactsManager.getContactById(contactId)
        if (c && c.id !== undefined) {
            contactNom      = c.nom          || ""
            contactPrenom   = c.prenom       || ""
            contactEmail    = c.email        || ""
            contactTel      = c.telephone    || ""
            contactOrg      = c.organisation || ""
            contactLocalite = c.localite     || ""
            contactFavori   = c.favori       === true

            telephonesModel.clear()
            if (c.telephones && c.telephones.length > 0) {
                for (var i = 0; i < c.telephones.length; i++) {
                    var telData = c.telephones[i]
                    var num = (typeof telData === "string") ? telData : (telData.numero || "")
                    // ✅ Récupérer le type et le libellé
                    var type = (typeof telData === "string") ? 1 : (telData.type || 1)
                    var libelle = (typeof telData === "string") ? "Mobile" : (telData.libelle || "Mobile")
                    telephonesModel.append({
                        numero: num,
                        type: type,
                        libelle: libelle
                    })
                }
            } else if (c.telephone && c.telephone.length > 0) {
                telephonesModel.append({
                    numero: c.telephone,
                    type: 1,
                    libelle: "Mobile"
                })
            } else {
                telephonesModel.append({
                    numero: "",
                    type: 1,
                    libelle: "Mobile"
                })
            }
        }
    }

    Component.onCompleted:  chargerContact()
    StackView.onActivating: chargerContact()

    Connections {
        target: contactsManager
        function onContactsChanged() { chargerContact() }
    }

    // ── Header ────────────────────────────────────────────────
    Rectangle {
        id: appBar; z: 10
        anchors { top: parent.top; left: parent.left; right: parent.right }
        height: 56; color: "white"; border.color: "#e5e7eb"; border.width: 0.5

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

        Rectangle {
            id: editBtn
            width: 84; height: 34; radius: 8; color: "#005da7"
            anchors { right: parent.right; rightMargin: 12; verticalCenter: parent.verticalCenter }
            Text { anchors.centerIn: parent; text: "Modifier"; color: "white"; font.pixelSize: 13; font.bold: true }
            MouseArea {
                anchors.fill: parent
                onClicked: root.nav.push("qrc:/design/page/ModifierContacts.qml", { contactId: contactId })
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
            width: parent.width; spacing: 0

            // ── Carte avatar ──────────────────────────────────
            Rectangle {
                width: parent.width; height: 180
                color: "white"; border.color: "#e5e7eb"; border.width: 0.5

                Column {
                    anchors.centerIn: parent; spacing: 10

                    Rectangle {
                        width: 90; height: 90; radius: 45; color: "#005da7"
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            anchors.centerIn: parent
                            text: {
                                var p = contactPrenom.length > 0 ? contactPrenom[0].toUpperCase() : ""
                                var n = contactNom.length    > 0 ? contactNom[0].toUpperCase()    : "?"
                                return p + n
                            }
                            font.pixelSize: 32; font.bold: true; color: "white"
                        }

                        Rectangle {
                            visible: contactFavori
                            width: 26; height: 26; radius: 13; color: "#f59e0b"
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
                anchors.horizontalCenter: parent.horizontalCenter; spacing: 28

                Column {
                    spacing: 6
                    Rectangle {
                        width: 52; height: 52; radius: 26; color: "#dbeafe"
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text { anchors.centerIn: parent; text: "📞"; font.pixelSize: 22 }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                var tel = telephonesModel.count > 0 ? telephonesModel.get(0).numero : contactTel
                                if (tel.length > 0) Qt.openUrlExternally("tel:" + tel)
                            }
                        }
                    }
                    Text { anchors.horizontalCenter: parent.horizontalCenter; text: "Appel"; font.pixelSize: 11; color: "#374151" }
                }

                Column {
                    spacing: 6
                    Rectangle {
                        width: 52; height: 52; radius: 26; color: "#d1fae5"
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text { anchors.centerIn: parent; text: "💬"; font.pixelSize: 22 }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                var tel = telephonesModel.count > 0 ? telephonesModel.get(0).numero : contactTel
                                if (tel.length > 0) Qt.openUrlExternally("sms:" + tel)
                            }
                        }
                    }
                    Text { anchors.horizontalCenter: parent.horizontalCenter; text: "SMS"; font.pixelSize: 11; color: "#374151" }
                }

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
            Text { text: "COORDONNÉES"; color: "#9ca3af"; font.pixelSize: 11; font.bold: true; leftPadding: 20 }
            Item { width: parent.width; height: 8 }

            Rectangle {
                width: parent.width; height: coordCol.height
                color: "white"; border.color: "#e5e7eb"; border.width: 0.5

                Column {
                    id: coordCol; width: parent.width; height: childrenRect.height

                    Repeater {
                        model: telephonesModel

                        delegate: Column {
                            width: parent.width; spacing: 0

                            Item {
                                width: parent.width; height: 64

                                Row {
                                    anchors {
                                        left: parent.left; leftMargin: 20
                                        right: parent.right; rightMargin: 20
                                        verticalCenter: parent.verticalCenter
                                    }
                                    spacing: 14

                                    // ✅ Icône avec couleur selon le type
                                    Rectangle {
                                        width: 40; height: 40; radius: 12
                                        color: {
                                            switch(libelle) {
                                                case "Mobile": return "#dbeafe"
                                                case "WhatsApp": return "#d1fae5"
                                                case "Maison": return "#fef3c7"
                                                case "Bureau": return "#ede9fe"
                                                default: return "#dbeafe"
                                            }
                                        }
                                        anchors.verticalCenter: parent.verticalCenter
                                        Text {
                                            anchors.centerIn: parent
                                            text: {
                                                switch(libelle) {
                                                    case "Mobile": return "📱"
                                                    case "WhatsApp": return "💬"
                                                    case "Maison": return "🏠"
                                                    case "Bureau": return "🏢"
                                                    default: return "📞"
                                                }
                                            }
                                            font.pixelSize: 20
                                        }
                                    }

                                    Column {
                                        anchors.verticalCenter: parent.verticalCenter; spacing: 2

                                        // ✅ Afficher le type (Mobile, WhatsApp, etc.) au lieu de "Téléphone X"
                                        Text {
                                            text: libelle.length > 0 ? libelle : "Téléphone"
                                            font.pixelSize: 11
                                            color: "#9ca3af"
                                        }
                                        Text {
                                            text: numero.length > 0 ? numero : "—"
                                            font.pixelSize: 15
                                            color: numero.length > 0 ? "#005da7" : "#9ca3af"
                                            font.bold: numero.length > 0

                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: {
                                                    if (numero.length > 0) Qt.openUrlExternally("tel:" + numero)
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                width: parent.width; height: 1; color: "#f3f4f6"
                                visible: index < telephonesModel.count - 1
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
                                anchors.verticalCenter: parent.verticalCenter; spacing: 2
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
            Text { text: "INFORMATIONS PERSONNELLES"; color: "#9ca3af"; font.pixelSize: 11; font.bold: true; leftPadding: 20 }
            Item { width: parent.width; height: 8 }

            Rectangle {
                width: parent.width; height: infoCol.height
                color: "white"; border.color: "#e5e7eb"; border.width: 0.5

                Column {
                    id: infoCol; width: parent.width; height: childrenRect.height

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
                    anchors.centerIn: parent; spacing: 8
                    Text { text: "🗑"; font.pixelSize: 18; color: "#ef4444" }
                    Text { text: "Supprimer ce contact"; font.pixelSize: 15; font.bold: true; color: "#ef4444" }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("🔵 Bouton Supprimer cliqué")
                        deleteDialog.visible = true
                    }
                }
            }

            Item { width: parent.width; height: 30 }
        }
    }

    // ══════════════════════════════════════════════════════════
    // ✅ DIALOGUE DE SUPPRESSION - DÉPLACÉ À LA FIN
    // ══════════════════════════════════════════════════════════
    Rectangle {
        id: deleteDialog
        visible: false
        z: 9999
        anchors.fill: parent
        color: "#80000000"

        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }

        Rectangle {
            width: 320; height: 200; radius: 16; color: "white"
            anchors.centerIn: parent
            border.color: "#e5e7eb"
            border.width: 1

            Column {
                anchors.centerIn: parent
                spacing: 16
                width: parent.width - 48

                Rectangle {
                    width: 50; height: 50; radius: 25
                    color: "#fee2e2"
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text {
                        anchors.centerIn: parent
                        text: "🗑"
                        font.pixelSize: 24
                    }
                }

                Text {
                    width: parent.width
                    text: "Supprimer ce contact ?"
                    font.pixelSize: 17
                    font.bold: true
                    color: "#111827"
                    horizontalAlignment: Text.AlignHCenter
                }

                Text {
                    width: parent.width
                    text: "Cette action est irréversible."
                    font.pixelSize: 13
                    color: "#6b7280"
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 12

                    Rectangle {
                        width: 120; height: 42; radius: 10
                        color: cancelHover.containsMouse ? "#e5e7eb" : "#f3f4f6"
                        border.color: "#d1d5db"
                        border.width: 1
                        Text {
                            anchors.centerIn: parent
                            text: "Annuler"
                            font.pixelSize: 14
                            font.bold: true
                            color: "#374151"
                        }
                        MouseArea {
                            id: cancelHover
                            hoverEnabled: true
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                console.log("🔵 Annulation suppression")
                                deleteDialog.visible = false
                            }
                        }
                    }

                    Rectangle {
                        width: 120; height: 42; radius: 10
                        color: deleteHover.containsMouse ? "#dc2626" : "#ef4444"
                        Text {
                            anchors.centerIn: parent
                            text: "Supprimer"
                            font.pixelSize: 14
                            font.bold: true
                            color: "white"
                        }
                        MouseArea {
                            id: deleteHover
                            hoverEnabled: true
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                console.log("🗑️ Confirmation suppression")
                                deleteDialog.visible = false
                                supprimerContact()
                            }
                        }
                    }
                }
            }
        }
    }
}