import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    height: 50
    radius: 25
    color: "#edeeef"

    TextField {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 20

        placeholderText: "Rechercher"
        background: null
    }
}