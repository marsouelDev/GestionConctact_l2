import QtQuick 2.15

Rectangle {
    id: root

    property string firstName: ""
    property string lastName: ""

    property color avatarColor: "#2976c7"
    property int size: 52

    width: size
    height: size
    radius: width / 2
    color: avatarColor

    // ================= INITIALS AUTO =================
    function getInitials() {
        var a = firstName.length > 0 ? firstName.charAt(0) : ""
        var b = lastName.length > 0 ? lastName.charAt(0) : ""
        return (a + b).toUpperCase()
    }

    Text {
        anchors.centerIn: parent
        text: root.getInitials()
        color: "white"
        font.pixelSize: size * 0.35
        font.bold: true
    }
}