import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {

    property string title: ""
    property bool showBack: false

    signal backClicked()

    width: parent.width
    height: 64

    color: "white"

    border.color: "#eeeeee"

    Row {
        anchors.fill: parent
        anchors.margins: 16

        spacing: 16

        ToolButton {

            visible: showBack

            text: "←"

            onClicked: backClicked()
        }

        Label {
            text: title

            font.pixelSize: 20
            font.bold: true

            anchors.verticalCenter: parent.verticalCenter
        }
    }
}