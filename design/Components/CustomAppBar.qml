import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root

    property string title: ""
    property bool showBack: false

    signal backClicked()

    height: 64
    width: parent ? parent.width : 480

    color: "white"
    border.color: "#eeeeee"

    Row {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        Button {
            visible: root.showBack
            text: "←"
            flat: true
            font.pixelSize: 20

            onClicked: root.backClicked()
        }

        Text {
            text: root.title
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 20
            font.bold: true
            color: "#191c1d"
        }
    }
}