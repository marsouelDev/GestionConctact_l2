import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml 2.15
import "qrc:/design/Components"

Page {
    //  CHANGEMENT : root → ajoutPage (évite le conflit avec main.qml)
    id: ajoutPage

    property bool loading: false

    background: Rectangle { color: "#f0f2f5" }

    //  Fonction centralisée pour quitter proprement
    function quitter() {
        //  root fait référence à l'ApplicationWindow de main.qml
        root.nav.pop()
    }

    // ================= MODELE TELEPHONE =================
    ListModel {
        id: phoneModel
        ListElement { numero: ""; type: 1 }
    }

    function sauvegarder() {
        // VALIDATION : au moins Nom ou Prénom
        if (nomField.text.trim() === "" && prenomField.text.trim() === "") {
            erreurMsg.text = "Veuillez entrer au moins un Nom ou un Prénom."
            popupErreur.visible = true
            return
        }

        //  Construction du tableau de TOUS les téléphones
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

        //  UN SEUL appel à addContact avec tous les numéros
        var ok = contactsManager.addContact(
            nomField.text.trim(),
            prenomField.text.trim(),
            emailField.text.trim(),
            localiteField.text.trim(),
            orgField.text.trim(),
            telephones
        )

        if (ok) {
            contactsManager.contactsChanged()
            //  Retour à la liste après enregistrement
            quitter()
        } else {
            erreurMsg.text = "Erreur lors de l'enregistrement en base de données."
            popupErreur.visible = true
        }
    }

    // ================= HEADER =================
    Rectangle {
        id: appBar
        z: 10
        anchors { top: parent.top; left: parent.left; right: parent.right }
        height: 56
        color: "white"
        border.color: "#e5e7eb"; border.width: 0.5

        //  BOUTON CROIX
        Rectangle {
            width: 32; height: 32; radius: 16
            color: closeHover.containsMouse ? "#f3f4f6" : "transparent"
            anchors { left: parent.left; leftMargin: 16; verticalCenter: parent.verticalCenter }
            Text { anchors.centerIn: parent; text: "✕"; font.pixelSize: 16; color: "#374151" }
            MouseArea {
                id: closeHover; hoverEnabled: true; anchors.fill: parent
                onClicked: {
                    console.log(" Bouton croix cliqué")
                    quitter()
                }
            }
        }

        Text {
            anchors.centerIn: parent
            text: "Nouveau contact"
            font.pixelSize: 16; font.bold: true; color: "#111827"
        }

        Rectangle {
            width: 110; height: 34; radius: 8; color: "#005da7"
            anchors { right: parent.right; rightMargin: 16; verticalCenter: parent.verticalCenter }
            Text { anchors.centerIn: parent; text: "Enregistrer"; color: "white"; font.pixelSize: 13; font.bold: true }
            MouseArea { anchors.fill: parent; onClicked: sauvegarder() }
        }
    }

    // ================= BODY =================
    Flickable {
        anchors { top: appBar.bottom; left: parent.left; right: parent.right; bottom: bottomBar.top }
        clip: true
        contentHeight: mainCol.implicitHeight + 40

        Column {
            id: mainCol
            width: parent.width
            spacing: 0

            // ================= AVATAR =================
            Item {
                width: parent.width; height: 130
                Column {
                    anchors.centerIn: parent; spacing: 8
                    Rectangle {
                        width: 80; height: 80; radius: 40; color: "#e5e7eb"
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text { anchors.centerIn: parent; text: "👤"; font.pixelSize: 36 }
                        Rectangle {
                            width: 24; height: 24; radius: 12; color: "#005da7"
                            anchors { right: parent.right; bottom: parent.bottom }
                            Text { anchors.centerIn: parent; text: "📷"; font.pixelSize: 12 }
                        }
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Ajouter une photo"; color: "#005da7"; font.pixelSize: 13
                    }
                }
            }

            // ================= INFORMATIONS =================
            Item { width: parent.width; height: 16 }
            Text { text: "INFORMATIONS PERSONNELLES"; color: "#9ca3af"; font.pixelSize: 11; font.bold: true; leftPadding: 20 }
            Item { width: parent.width; height: 8 }

            Rectangle {
                width: parent.width; color: "white"
                border.color: "#e5e7eb"; border.width: 0.5
                implicitHeight: colInfo.implicitHeight

                Column {
                    id: colInfo; width: parent.width

                    Column {
                        width: parent.width; topPadding: 12; bottomPadding: 8; spacing: 4
                        Text { text: "Prénom *"; font.pixelSize: 12; font.bold: true; color: "#374151"; leftPadding: 20 }
                        TextField {
                            id: prenomField; x: 20; width: parent.width - 40
                            placeholderText: "Ex: Jean"; font.pixelSize: 14; color: "#111827"; leftPadding: 12
                            background: Rectangle { color: "#f9fafb"; radius: 8; border.color: "#e5e7eb" }
                        }
                    }

                    Rectangle { width: parent.width; height: 1; color: "#f3f4f6" }

                    Column {
                        width: parent.width; topPadding: 12; bottomPadding: 12; spacing: 4
                        Text { text: "Nom *"; font.pixelSize: 12; font.bold: true; color: "#374151"; leftPadding: 20 }
                        TextField {
                            id: nomField; x: 20; width: parent.width - 40
                            placeholderText: "Ex: Atangana"; font.pixelSize: 14; color: "#111827"; leftPadding: 12
                            background: Rectangle { color: "#f9fafb"; radius: 8; border.color: "#e5e7eb" }
                        }
                    }

                    Rectangle { width: parent.width; height: 1; color: "#f3f4f6" }

                    Column {
                        width: parent.width; topPadding: 12; bottomPadding: 12; spacing: 4
                        Text { text: "Localité"; font.pixelSize: 12; font.bold: true; color: "#374151"; leftPadding: 20 }
                        TextField {
                            id: localiteField; x: 20; width: parent.width - 40
                            placeholderText: "Ex: Yaoundé"; font.pixelSize: 14; color: "#111827"; leftPadding: 12
                            background: Rectangle { color: "#f9fafb"; radius: 8; border.color: "#e5e7eb" }
                        }
                    }
                }
            }

            // ================= COORDONNEES =================
            Item { width: parent.width; height: 20 }
            Text { text: "COORDONNÉES"; color: "#9ca3af"; font.pixelSize: 11; font.bold: true; leftPadding: 20 }
            Item { width: parent.width; height: 8 }

            Rectangle {
                width: parent.width; color: "white"
                border.color: "#e5e7eb"; border.width: 0.5
                implicitHeight: coordCol.implicitHeight + 20

                Column {
                    id: coordCol; width: parent.width; spacing: 14
                    topPadding: 16; bottomPadding: 16

                    // ================= PREMIER TELEPHONE =================
                    Item {
                        width: parent.width; height: rowTel.implicitHeight
                        Row {
                            id: rowTel
                            anchors { left: parent.left; leftMargin: 20; right: parent.right; rightMargin: 20 }
                            spacing: 12

                            Rectangle { width: 36; height: 36; radius: 10; color: "#dbeafe"
                                Text { anchors.centerIn: parent; text: "📞" }
                            }

                            Column {
                                width: parent.width - 48; spacing: 4
                                Text { text: "Téléphone"; font.pixelSize: 12; font.bold: true; color: "#374151" }

                                ComboBox {
                                    id: typeBox; width: parent.width
                                    model: ["Mobile", "WhatsApp", "Maison", "Bureau"]
                                    onCurrentIndexChanged: phoneModel.setProperty(0, "type", currentIndex + 1)
                                }

                                TextField {
                                    id: telField
                                    width: parent.width
                                    placeholderText: "671 46 22 46"
                                    font.pixelSize: 14
                                    color: "#111827"
                                    leftPadding: 12
                                    maximumLength: 12
                                    inputMethodHints: Qt.ImhDigitsOnly

                                    validator: RegularExpressionValidator {
                                        regularExpression: /^[0-9]*$/
                                    }

                                    onTextChanged: {
                                        var filtered = text.replace(/[^0-9]/g, '')
                                        if (filtered !== text) {
                                            text = filtered
                                        }
                                        if (phoneModel.count > 0) {
                                            phoneModel.setProperty(0, "numero", text)
                                        }
                                    }

                                    background: Rectangle {
                                        color: "#f9fafb"
                                        radius: 8
                                        border.color: telField.activeFocus ? "#005da7" : "#e5e7eb"
                                        border.width: telField.activeFocus ? 2 : 1
                                    }
                                }
                            }
                        }
                    }

                    // ================= AUTRES NUMEROS =================
                    Repeater {
                        model: phoneModel
                        delegate: Item {
                            visible: index > 0
                            width: parent.width; height: rowExtra.implicitHeight

                            Row {
                                id: rowExtra
                                anchors { left: parent.left; leftMargin: 20; right: parent.right; rightMargin: 20 }
                                spacing: 12

                                Rectangle { width: 36; height: 36; radius: 10; color: "#dbeafe"
                                    Text { anchors.centerIn: parent; text: "📞" }
                                }

                                Column {
                                    width: parent.width - 120; spacing: 4
                                    ComboBox {
                                        width: parent.width
                                        model: ["Mobile", "WhatsApp", "Maison", "Bureau"]
                                        onCurrentIndexChanged: phoneModel.setProperty(index, "type", currentIndex + 1)
                                    }

                                    TextField {
                                        width: parent.width
                                        text: numero
                                        placeholderText: "Numéro téléphone"
                                        font.pixelSize: 14
                                        color: "#111827"
                                        leftPadding: 12
                                        maximumLength: 12
                                        inputMethodHints: Qt.ImhDigitsOnly

                                        validator: RegularExpressionValidator {
                                            regularExpression: /^[0-9]*$/
                                        }

                                        onTextChanged: {
                                            var filtered = text.replace(/[^0-9]/g, '')
                                            if (filtered !== text) {
                                                text = filtered
                                            }
                                            phoneModel.setProperty(index, "numero", text)
                                        }

                                        background: Rectangle {
                                            color: "#f9fafb"
                                            radius: 8
                                            border.color: "#e5e7eb"
                                        }
                                    }
                                }

                                Rectangle { width: 36; height: 36; radius: 18; color: "#fee2e2"
                                    Text { anchors.centerIn: parent; text: "🗑" }
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

                    // EMAIL
                    Item {
                        width: parent.width; height: rowEmail.implicitHeight
                        Row {
                            id: rowEmail
                            anchors { left: parent.left; leftMargin: 20; right: parent.right; rightMargin: 20 }
                            spacing: 12

                            Rectangle { width: 36; height: 36; radius: 10; color: "#d1fae5"
                                Text { anchors.centerIn: parent; text: "✉️" }
                            }

                            Column {
                                width: parent.width - 48; spacing: 4
                                Text { text: "E-mail"; font.pixelSize: 12; font.bold: true; color: "#374151" }
                                TextField {
                                    id: emailField; width: parent.width
                                    placeholderText: "exemple@email.com"; font.pixelSize: 14; color: "#111827"; leftPadding: 12
                                    background: Rectangle { color: "#f9fafb"; radius: 8; border.color: "#e5e7eb" }
                                }
                            }
                        }
                    }
                }
            }

            // ================= ENTREPRISE =================
            Item { width: parent.width; height: 20 }
            Text { text: "DÉTAILS SUPPLÉMENTAIRES"; color: "#9ca3af"; font.pixelSize: 11; font.bold: true; leftPadding: 20 }
            Item { width: parent.width; height: 8 }

            Rectangle {
                width: parent.width; color: "white"
                border.color: "#e5e7eb"; border.width: 0.5
                implicitHeight: detailCol.implicitHeight + 20

                Column {
                    id: detailCol; width: parent.width; topPadding: 16; bottomPadding: 16
                    Text { text: "Entreprise"; font.pixelSize: 12; font.bold: true; color: "#374151"; leftPadding: 20 }
                    TextField {
                        id: orgField; x: 20; width: parent.width - 40
                        placeholderText: "Nom entreprise"; font.pixelSize: 14; color: "#111827"; leftPadding: 12
                        background: Rectangle { color: "#f9fafb"; radius: 8; border.color: "#e5e7eb" }
                    }
                }
            }

            Item { width: parent.width; height: 30 }
        }
    }

    // ================= POPUP ERREUR =================
    Rectangle {
        id: popupErreur
        visible: false; z: 200
        anchors.fill: parent
        color: "#80000000"

        Rectangle {
            width: 300; height: 190; radius: 16; color: "white"
            anchors.centerIn: parent

            Column {
                anchors.centerIn: parent
                spacing: 18; width: parent.width - 48

                Text { anchors.horizontalCenter: parent.horizontalCenter; text: "⚠️"; font.pixelSize: 36 }
                Text {
                    id: erreurMsg
                    width: parent.width
                    text: "Veuillez remplir les informations obligatoires."
                    font.pixelSize: 14; color: "#111827"
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }
                Rectangle {
                    width: 120; height: 42; radius: 10; color: "#005da7"
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text { anchors.centerIn: parent; text: "OK"; font.pixelSize: 14; color: "white"; font.bold: true }
                    MouseArea { anchors.fill: parent; onClicked: popupErreur.visible = false }
                }
            }
        }
    }

    // ================= BOTTOM BAR =================
    Rectangle {
        id: bottomBar
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        height: 72; color: "white"
        border.color: "#e5e7eb"; border.width: 0.5

        Row {
            anchors.centerIn: parent; spacing: 16

            //BOUTON ANNULER
            Rectangle {
                width: 140; height: 44; radius: 10
                color: "#f3f4f6"; border.color: "#d1d5db"
                Text { anchors.centerIn: parent; text: "Annuler"; font.pixelSize: 15; font.bold: true; color: "#374151" }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log(" Bouton Annuler cliqué")
                        quitter()
                    }
                }
            }

            Rectangle {
                width: 140; height: 44; radius: 10; color: "#005da7"
                Text { anchors.centerIn: parent; text: "Enregistrer"; font.pixelSize: 15; font.bold: true; color: "white" }
                MouseArea { anchors.fill: parent; onClicked: sauvegarder() }
            }
        }
    }
}