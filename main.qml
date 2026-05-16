import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: root
    visible: true
    width: 480
    height: 884
    minimumWidth: 360
    title: "Manager_contact"

    // ══════════════════════════════════════════════════════════
    // MODÈLE PARTAGÉ  — source unique de vérité
    // ══════════════════════════════════════════════════════════
    ListModel {
        id: contactsModel

        ListElement {
            firstName: "Alice";  lastName: "Martin"
            phone: "+33 6 12 34 56 78"; email: "alice.martin@mail.com"
            company: "Studio Créatif";  favorite: false;  avatarColor: "#dce3eb"; avatarText: "#40484e"
        }
        ListElement {
            firstName: "Arthur"; lastName: "Meyer"
            phone: "+33 7 98 76 54 32"; email: "arthur.meyer@mail.com"
            company: "Meyer & Co";      favorite: false;  avatarColor: "#008645"; avatarText: "#f6fff4"
        }
        ListElement {
            firstName: "Benoît"; lastName: "Dubois"
            phone: "+33 6 55 44 33 22"; email: "benoit.dubois@mail.com"
            company: "Dubois SARL";     favorite: false;  avatarColor: "#c0c7cf"; avatarText: "#ffffff"
        }
        ListElement {
            firstName: "Céline"; lastName: "Durand"
            phone: "+33 6 11 22 33 44"; email: "celine.durand@mail.com"
            company: "Agence Gamma";    favorite: true;   avatarColor: "#2976c7"; avatarText: "#fdfcff"
        }
        ListElement {
            firstName: "Charles"; lastName: "Petit"
            phone: "+33 6 77 88 99 00"; email: "charles.petit@mail.com"
            company: "Petit Solutions"; favorite: false;  avatarColor: "#e1e3e4"; avatarText: "#40484e"
        }
        ListElement {
            firstName: "Sophie"; lastName: "Bernard"
            phone: "+33 7 33 22 11 00"; email: "sophie.b@mail.com"
            company: "Design Studio";   favorite: true;   avatarColor: "#a4c9ff"; avatarText: "#001c39"
        }
    }

    // ══════════════════════════════════════════════════════════
    // NAVIGATION  — StackView couvre toute la fenêtre
    // ══════════════════════════════════════════════════════════
    StackView {
        id: stack
        anchors.fill: parent
        initialItem: "ListeContacts.qml"

        property var model: contactsModel


        pushEnter: Transition {
            PropertyAnimation { property: "x"; from: stack.width; to: 0; duration: 220; easing.type: Easing.OutCubic }
        }
        pushExit: Transition {
            PropertyAnimation { property: "x"; from: 0; to: -stack.width * 0.3; duration: 220; easing.type: Easing.OutCubic }
        }
        popEnter: Transition {
            PropertyAnimation { property: "x"; from: -stack.width * 0.3; to: 0; duration: 220; easing.type: Easing.OutCubic }
        }
        popExit: Transition {
            PropertyAnimation { property: "x"; from: 0; to: stack.width; duration: 220; easing.type: Easing.OutCubic }
        }
    }
}
