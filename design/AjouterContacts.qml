import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: root

    property var contactsModel: null
    property int editIndex: -1          // -1 = nouveau contact, >= 0 = modification

    readonly property bool isEditing: editIndex >= 0

    // Pré-remplit si mode édition
    Component.onCompleted: {
        if (isEditing && contactsModel) {
            var c = contactsModel.get(editIndex)
            fieldPrenom.text  = c.firstName
            fieldNom.text     = c.lastName
            fieldTel.text     = c.phone
            fieldEmail.text   = c.email
            fieldCompany.text = c.company
        }
    }

    background: Rectangle { color: "#f8f9fa" }

    // ══════════════════════════════════════════════════════════
    // HEADER
    // ══════════════════════════════════════════════════════════
    header: Rectangle {
        width: parent.width; height: 64
        color: "#ffffff"; z: 50

        Rectangle {
            anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right
            height: 1; color: "#f3f4f6"
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16; anchors.rightMargin: 20
            spacing: 12

            // Bouton fermer
            Rectangle {
                width: 40; height: 40; radius: 20
                color: closeTap.pressed ? "#f3f4f5" : "transparent"
                Behavior on color { ColorAnimation { duration: 120 } }

                Text { anchors.centerIn: parent; text: "✕"; font.pixelSize: 18; color: "#6b7280" }

                TapHandler {
                    id: closeTap
                    onTapped: StackView.view.pop()
                }
            }

            Text {
                Layout.fillWidth: true
                text: root.isEditing ? "Modifier le contact" : "Nouveau contact"
                font.pixelSize: 18; font.weight: Font.SemiBold
                color: "#111827"; elide: Text.ElideRight
            }

            // Enregistrer (header)
            Rectangle {
                height: 36
                width: saveLbl.implicitWidth + 32
                radius: 999; color: "#005da7"

                Text {
                    id: saveLbl; anchors.centerIn: parent
                    text: "Enregistrer"
                    font.pixelSize: 13; font.weight: Font.SemiBold; color: "#ffffff"
                }

                scale: saveHdrTap.pressed ? 0.95 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }

                TapHandler { id: saveHdrTap; onTapped: root.save() }
            }
        }
    }

    // ══════════════════════════════════════════════════════════
    // FORMULAIRE
    // ══════════════════════════════════════════════════════════
    ScrollView {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: bottomBar.top
        contentWidth: availableWidth
        clip: true

        ColumnLayout {
            width: Math.min(parent.width, 640)
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 16
            anchors.topMargin: 24
            anchors.bottomMargin: 24

            // Avatar section
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10
                Layout.topMargin: 8

                Item {
                    Layout.alignment: Qt.AlignHCenter
                    width: 100; height: 100

                    Rectangle {
                        id: avatarCircle
                        width: 100; height: 100; radius: 50
                        color: "#dce3eb"
                        border.color: "#ffffff"; border.width: 3

                        Text {
                            anchors.centerIn: parent
                            text: "👤"; font.pixelSize: 38; color: "#717783"
                        }
                    }

                    Rectangle {
                        width: 34; height: 34; radius: 17
                        color: "#005da7"
                        border.color: "#ffffff"; border.width: 2
                        anchors.right: avatarCircle.right
                        anchors.bottom: avatarCircle.bottom
                        anchors.rightMargin: -2; anchors.bottomMargin: -2

                        Text { anchors.centerIn: parent; text: "📷"; font.pixelSize: 13 }
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Ajouter une photo"
                    font.pixelSize: 12; font.weight: Font.SemiBold
                    font.letterSpacing: 0.5; color: "#005da7"
                }
            }

            // ── Card: Informations personnelles ────────────────
            Rectangle {
                Layout.fillWidth: true
                Layout.leftMargin: 20; Layout.rightMargin: 20
                radius: 12; color: "#ffffff"
                border.color: "#f3f4f6"; border.width: 1
                implicitHeight: formPersonal.implicitHeight + 48

                ColumnLayout {
                    id: formPersonal
                    anchors { top: parent.top; left: parent.left; right: parent.right; margins: 20; topMargin: 20 }
                    spacing: 16

                    Text {
                        text: "INFORMATIONS PERSONNELLES"
                        font.pixelSize: 11; font.weight: Font.SemiBold
                        font.letterSpacing: 1.2; color: "#717783"
                    }

                    FormField { label: "Prénom"; placeholder: "Ex: Jean";   id: fieldPrenom }
                    FormField { label: "Nom";    placeholder: "Ex: Dupont"; id: fieldNom;  Layout.bottomMargin: 4 }
                }
            }

            // ── Card: Coordonnées ──────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                Layout.leftMargin: 20; Layout.rightMargin: 20
                radius: 12; color: "#ffffff"
                border.color: "#f3f4f6"; border.width: 1
                implicitHeight: formCoord.implicitHeight + 48

                ColumnLayout {
                    id: formCoord
                    anchors { top: parent.top; left: parent.left; right: parent.right; margins: 20; topMargin: 20 }
                    spacing: 16

                    Text {
                        text: "COORDONNÉES"
                        font.pixelSize: 11; font.weight: Font.SemiBold
                        font.letterSpacing: 1.2; color: "#717783"
                    }

                    FormFieldIcon {
                        id: fieldTel
                        label: "Téléphone"; placeholder: "+33 6 00 00 00 00"
                        iconText: "📞"; iconBg: "#d4e3ff"
                    }
                    FormFieldIcon {
                        id: fieldEmail
                        label: "E-mail"; placeholder: "jean.dupont@exemple.com"
                        iconText: "✉️"; iconBg: "#6bfe9c55"
                        Layout.bottomMargin: 4
                    }
                }
            }

            // ── Card: Détails ──────────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                Layout.leftMargin: 20; Layout.rightMargin: 20
                radius: 12; color: "#ffffff"
                border.color: "#f3f4f6"; border.width: 1
                implicitHeight: formDetails.implicitHeight + 48

                ColumnLayout {
                    id: formDetails
                    anchors { top: parent.top; left: parent.left; right: parent.right; margins: 20; topMargin: 20 }
                    spacing: 16

                    Text {
                        text: "DÉTAILS SUPPLÉMENTAIRES"
                        font.pixelSize: 11; font.weight: Font.SemiBold
                        font.letterSpacing: 1.2; color: "#717783"
                    }

                    FormField { id: fieldCompany; label: "Entreprise"; placeholder: "Nom de l'entreprise"; Layout.bottomMargin: 4 }
                }
            }

            // Bouton supprimer (visible en mode édition seulement)
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 52
                Layout.leftMargin: 20; Layout.rightMargin: 20
                visible: root.isEditing

                Rectangle {
                    anchors.fill: parent; radius: 12
                    color: delHover.containsMouse ? "#fff0f0" : "#ffffff"
                    border.color: "#f3f4f6"; border.width: 1
                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: "🗑  Supprimer ce contact"
                        font.pixelSize: 14; font.weight: Font.Medium; color: "#ba1a1a"
                    }

                    HoverHandler { id: delHover }
                    TapHandler {
                        onTapped: {
                            root.contactsModel.remove(root.editIndex)
                            // Pop deux fois : on revient à la liste
                            StackView.view.pop()
                            StackView.view.pop()
                        }
                    }
                }
            }

            Item { Layout.preferredHeight: 16 }
        }
    }

    // ══════════════════════════════════════════════════════════
    // BARRE DU BAS  ─ Annuler / Enregistrer
    // ══════════════════════════════════════════════════════════
    Rectangle {
        id: bottomBar
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 88; z: 50
        color: Qt.rgba(1, 1, 1, 0.92)

        Rectangle {
            anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right
            height: 1; color: "#f3f4f6"
        }

        RowLayout {
            anchors { fill: parent; leftMargin: 20; rightMargin: 20; topMargin: 20; bottomMargin: 20 }
            spacing: 12

            // Annuler
            Rectangle {
                Layout.preferredWidth: 100
                Layout.fillHeight: true
                radius: 12; color: "#edeeef"

                Text {
                    anchors.centerIn: parent
                    text: "Annuler"
                    font.pixelSize: 13; font.weight: Font.SemiBold; color: "#585f66"
                }

                scale: cancelTap.pressed ? 0.95 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }

                TapHandler { id: cancelTap; onTapped: StackView.view.pop() }
            }

            // Enregistrer
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 12; color: "#005da7"

                Text {
                    anchors.centerIn: parent
                    text: "Enregistrer"
                    font.pixelSize: 13; font.weight: Font.SemiBold; color: "#ffffff"
                }

                scale: saveTap.pressed ? 0.95 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }

                TapHandler { id: saveTap; onTapped: root.save() }
            }
        }
    }

    // ══════════════════════════════════════════════════════════
    // LOGIQUE DE SAUVEGARDE
    // ══════════════════════════════════════════════════════════
    function save() {
        var prenom  = fieldPrenom.text.trim()  || "Nouveau"
        var nom     = fieldNom.text.trim()     || "Contact"
        var phone   = fieldTel.text.trim()     || "+33 6 00 00 00 00"
        var email   = fieldEmail.text.trim()   || "contact@mail.com"
        var company = fieldCompany.text.trim() || "Entreprise"

        // Couleurs avatar par défaut (cycle sur l'index)
        var colors = ["#dce3eb","#a4c9ff","#4ae183","#2976c7","#008645","#c0c7cf","#e1e3e4","#ffd8a8"]
        var texts  = ["#40484e","#001c39","#00210c","#fdfcff","#f6fff4","#ffffff","#40484e","#7c4800"]

        if (root.isEditing) {
            contactsModel.setProperty(editIndex, "firstName", prenom)
            contactsModel.setProperty(editIndex, "lastName",  nom)
            contactsModel.setProperty(editIndex, "phone",     phone)
            contactsModel.setProperty(editIndex, "email",     email)
            contactsModel.setProperty(editIndex, "company",   company)
        } else {
            var ci = contactsModel.count % colors.length
            contactsModel.append({
                firstName:   prenom,
                lastName:    nom,
                phone:       phone,
                email:       email,
                company:     company,
                favorite:    false,
                avatarColor: colors[ci],
                avatarText:  texts[ci]
            })
        }

        StackView.view.pop()
    }
}

// ══════════════════════════════════════════════════════════════
// Composants internes (inline dans le même fichier)
// ══════════════════════════════════════════════════════════════

// Champ simple avec label
component FormField: ColumnLayout {
    property string label:       ""
    property string placeholder: ""
    property alias  text:        tf.text

    Layout.fillWidth: true
    spacing: 6

    Text {
        text: parent.label
        font.pixelSize: 11; font.weight: Font.SemiBold
        font.letterSpacing: 0.5; color: "#585f66"
        leftPadding: 4
    }

    TextField {
        id: tf
        Layout.fillWidth: true
        placeholderText: parent.placeholder
        font.pixelSize: 15; color: "#191c1d"
        leftPadding: 14; rightPadding: 14; topPadding: 12; bottomPadding: 12

        background: Rectangle {
            color: tf.activeFocus ? "#ffffff" : "#f3f4f5"
            radius: 8
            border.color: tf.activeFocus ? "#005da7" : "transparent"
            border.width: tf.activeFocus ? 1.5 : 0
            Behavior on color { ColorAnimation { duration: 180 } }
            Behavior on border.color { ColorAnimation { duration: 180 } }
        }
    }
}

// Champ avec icône à gauche
component FormFieldIcon: RowLayout {
    property string label:       ""
    property string placeholder: ""
    property string iconText:    ""
    property string iconBg:      "#f3f4f5"
    property alias  text:        tfi.text

    Layout.fillWidth: true
    spacing: 14

    Rectangle {
        width: 44; height: 44; radius: 8
        color: parent.iconBg
        anchors.verticalCenter: parent.verticalCenter

        Text { anchors.centerIn: parent; text: parent.parent.iconText; font.pixelSize: 20 }
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 4

        Text {
            text: parent.parent.label
            font.pixelSize: 11; font.weight: Font.SemiBold
            font.letterSpacing: 0.5; color: "#585f66"
        }

        TextField {
            id: tfi
            Layout.fillWidth: true
            placeholderText: parent.parent.placeholder
            font.pixelSize: 15; color: "#191c1d"
            leftPadding: 0; topPadding: 8; bottomPadding: 8

            background: Rectangle {
                color: "transparent"
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width; height: tfi.activeFocus ? 2 : 1
                    color: tfi.activeFocus ? "#005da7" : "#c1c7d3"
                    Behavior on color { ColorAnimation { duration: 180 } }
                    Behavior on height { NumberAnimation { duration: 150 } }
                }
            }
        }
    }
}