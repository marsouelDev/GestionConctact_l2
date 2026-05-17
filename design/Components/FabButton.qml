import QtQuick 2.15

Rectangle {
    id: root

    signal clicked()

    width: 58
    height: 58
    radius: 29

    color: "#005da7"

    Text {
        anchors.centerIn: parent
        text: "+"
        color: "white"
        font.pixelSize: 28
        font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}