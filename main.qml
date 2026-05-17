import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: root
    visible: true
    width: 480
    height: 884
    title: "Manager Contact"

    //  navigation globale accessible partout
    property alias nav: stackView

    color: "#f8f9fa"

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: "qrc:/design/page/ListeContacts.qml"
    }
}