import QtQuick 2.15
import QtQuick.Controls 2.15
import "qrc:/design/Components"

Page {

    property int contactIndex: -1
    property var contact: contactsManager.getContact(contactIndex)

    background: Rectangle { color: "#f8f9fa" }

    Column {
        anchors.fill: parent
        spacing: 20

        CustomAppBar {
            title: "Détails"
            showBack: true

            onBackClicked: root.nav.pop()
        }

        Column {
            width: parent.width
            spacing: 14
            anchors.horizontalCenter: parent.horizontalCenter

            Avatar {
                anchors.horizontalCenter: parent.horizontalCenter
                size: 120
                firstName: Contact.prenom
                lastName: Contact.nom
                avatarColor: "#005da7"
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: contact.prenom + " " + contact.nom
                font.pixelSize: 28
                font.bold: true
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: contact.company
                color: "#6b7280"
            }
        }

        Rectangle {
            width: parent.width - 40
            height: 180
            radius: 20
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter

            Column {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20

                Text { text: "Téléphone : " + contact.phone }
                Text { text: "Email : " + contact.email }
                Text { text: "Entreprise : " + contact.company }
            }
        }
    }
}