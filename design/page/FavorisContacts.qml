import QtQuick 2.15
import QtQuick.Controls 2.15
import "qrc:/design/Components"

Page {

    background: Rectangle {
        color: "#f8f9fa"
    }

    Column {
        anchors.fill: parent
        spacing: 12

        // ================= HEADER =================
        CustomAppBar {
            title: "Favoris"
            showBack: true

            onBackClicked: root.nav.pop()
        }

        // ================= LIST =================
        ListView {

            width: parent.width
            height: parent.height - 100
            clip: true

            model: contactsManager.listFavorites()

            delegate: ContactRow {

                width: ListView.view.width

                firstName: modelData.prenom
                lastName: modelData.nom
                initials: (modelData.prenom.charAt(0) + modelData.nom.charAt(0)).toUpperCase()
                avatarColor: "#005da7"

                //  IMPORTANT FIX QT
                onClicked: {
                    root.nav.push(
                        Qt.resolvedUrl("DetailsContacts.qml"),
                        { contactIndex: index }
                    )
                }
            }
        }
    }
}