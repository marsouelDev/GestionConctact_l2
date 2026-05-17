import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root

    property int currentIndex: 0

    signal contactsClicked()
    signal favorisClicked()

    height: 75
    width: parent.width

    color: "white"
    border.color: "#e5e7eb"

    Row {
        anchors.centerIn: parent
        spacing: 60

        Button {
            text: "Contacts"

            background: Rectangle {
                radius: 14
                color: root.currentIndex === 0 ? "#dbeafe" : "transparent"
            }

            contentItem: Text {
                text: parent.text
                color: root.currentIndex === 0 ? "#005da7" : "#6b7280"
                font.bold: true
            }

            onClicked: root.contactsClicked()
        }

        Button {
            text: "Favoris"

            background: Rectangle {
                radius: 14
                color: root.currentIndex === 1 ? "#dbeafe" : "transparent"
            }

            contentItem: Text {
                text: parent.text
                color: root.currentIndex === 1 ? "#005da7" : "#6b7280"
                font.bold: true
            }

            onClicked: root.favorisClicked()
        }
    }
}