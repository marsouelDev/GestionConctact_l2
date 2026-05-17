import QtQuick 2.15
import QtQuick.Controls 2.15
import "qrc:/design/Components"

Rectangle {

    id: root

    property string firstName: ""
    property string lastName: ""
    property string initials: ""
    property color avatarColor: "#2976c7"

    signal clicked()

    height: 78
    radius: 10
    color: "white"

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }

    Row {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 14

        Rectangle {
            width: 46
            height: 46
            radius: 23
            color: root.avatarColor

            Text {
                anchors.centerIn: parent
                text: root.initials
                color: "white"
                font.bold: true
                font.pixelSize: 16
            }
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4

            Text {
                text: root.firstName + " " + root.lastName
                font.pixelSize: 16
                font.bold: true
                color: "#191c1d"
            }
        }
    }
}