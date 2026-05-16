// import QtQuick 2.15
// import QtQuick.Controls 2.15
// import QtQuick.Layouts 1.15

// Rectangle {
//     id: root
//     width: 480
//     height: 884
//     color: "#f8f9fa"

//     // ══════════════════════════════════════════════════════════
//     // HEADER  ─ TopAppBar sticky
//     // ══════════════════════════════════════════════════════════
//     Rectangle {
//         id: header
//         anchors.top: parent.top
//         anchors.left: parent.left
//         anchors.right: parent.right
//         height: 64
//         color: "#ffffff"
//         z: 50

//         Rectangle {
//             anchors.bottom: parent.bottom
//             anchors.left: parent.left
//             anchors.right: parent.right
//             height: 1
//             color: "#f3f4f6"
//         }

//         // Menu icon + Title
//         Row {
//             anchors.left: parent.left
//             anchors.leftMargin: 20
//             anchors.verticalCenter: parent.verticalCenter
//             spacing: 16

//             Rectangle {
//                 width: 36
//                 height: 36
//                 radius: 18
//                 color: "transparent"

//                 Column {
//                     anchors.centerIn: parent
//                     spacing: 4

//                     Rectangle { width: 18; height: 2; color: "#3b82f6"; radius: 1 }
//                     Rectangle { width: 18; height: 2; color: "#3b82f6"; radius: 1 }
//                     Rectangle { width: 18; height: 2; color: "#3b82f6"; radius: 1 }
//                 }
//             }

//             Text {
//                 anchors.verticalCenter: parent.verticalCenter
//                 text: "Favoris"
//                 font.pixelSize: 16
//                 font.weight: Font.SemiBold
//                 color: "#111827"
//             }
//         }

//         // User avatar
//         Rectangle {
//             anchors.right: parent.right
//             anchors.rightMargin: 20
//             anchors.verticalCenter: parent.verticalCenter
//             width: 34
//             height: 34
//             radius: 17
//             color: "#d4e3ff"
//             border.color: "#ffffff"
//             border.width: 2

//             Text {
//                 anchors.centerIn: parent
//                 text: "U"
//                 font.pixelSize: 14
//                 font.weight: Font.Bold
//                 color: "#005da7"
//             }
//         }
//     }

//     // ══════════════════════════════════════════════════════════
//     // SCROLLABLE BODY
//     // ══════════════════════════════════════════════════════════
//     Flickable {
//         id: flickable
//         anchors.top: header.bottom
//         anchors.left: parent.left
//         anchors.right: parent.right
//         anchors.bottom: bottomNav.top
//         contentWidth: width
//         contentHeight: bodyCol.implicitHeight + 80
//         clip: true

//         Column {
//             id: bodyCol
//             width: flickable.width
//             topPadding: 16
//             bottomPadding: 32
//             spacing: 0
//             leftPadding: 20
//             rightPadding: 20

//             // ── Search Bar ────────────────────────────────────
//             Rectangle {
//                 width: parent.width - 40
//                 height: 52
//                 radius: 999
//                 color: "#dce3eb"
//                 anchors.horizontalCenter: parent.horizontalCenter

//                 Row {
//                     anchors.left: parent.left
//                     anchors.leftMargin: 16
//                     anchors.verticalCenter: parent.verticalCenter
//                     spacing: 10

//                     Text {
//                         anchors.verticalCenter: parent.verticalCenter
//                         text: "\uD83D\uDD0D"
//                         font.pixelSize: 18
//                         color: "#717783"
//                     }

//                     Text {
//                         anchors.verticalCenter: parent.verticalCenter
//                         text: "Rechercher dans les favoris"
//                         font.pixelSize: 16
//                         color: "#9ca3af"
//                     }
//                 }
//             }

//             Item { width: 1; height: 24 }

//             // ══════════════════════════════════════════════════
//             // BENTO GRID  (2-col layout)
//             // ══════════════════════════════════════════════════
//             Item {
//                 width: parent.width - 40
//                 anchors.horizontalCenter: parent.horizontalCenter
//                 height: bentoRow1.height + bentoRow2.height + 12

//                 // ── Row 1: Main Hero card + Two small cards ───
//                 Row {
//                     id: bentoRow1
//                     width: parent.width
//                     spacing: 12

//                     // ── Main Hero card (col-span-2 / row-span-2) ──────
//                     Rectangle {
//                         id: heroCard
//                         width: (parent.width - 12) / 2
//                         height: 300
//                         radius: 12
//                         color: "#2976c7"
//                         clip: true

//                         // Gradient overlay to darken bottom for text legibility
//                         Rectangle {
//                             anchors.bottom: parent.bottom
//                             width: parent.width
//                             height: parent.height * 0.6
//                             radius: 12

//                             gradient: Gradient {
//                                 GradientStop { position: 0.0; color: "#00000000" }
//                                 GradientStop { position: 1.0; color: "#cc000000" }
//                             }
//                         }

//                         // Content at bottom
//                         Column {
//                             anchors.bottom: parent.bottom
//                             anchors.left: parent.left
//                             anchors.right: parent.right
//                             anchors.margins: 20
//                             anchors.bottomMargin: 20
//                             spacing: 6

//                             // Badge pill
//                             Rectangle {
//                                 width: badgeText.implicitWidth + 16
//                                 height: 22
//                                 radius: 4
//                                 color: "#33ffffff"

//                                 Text {
//                                     id: badgeText
//                                     anchors.centerIn: parent
//                                     text: "MEILLEUR CONTACT"
//                                     font.pixelSize: 9
//                                     font.weight: Font.Bold
//                                     font.letterSpacing: 1.2
//                                     color: "#ffffff"
//                                 }
//                             }

//                             Text {
//                                 text: "Sophie Bernard"
//                                 font.pixelSize: 24
//                                 font.weight: Font.Bold
//                                 color: "#ffffff"
//                             }

//                             Text {
//                                 text: "Designer UI/UX"
//                                 font.pixelSize: 14
//                                 color: "#ccffffff"
//                             }
//                         }
//                     }

//                     // ── Right column: 2 small avatar cards ───────────
//                     Column {
//                         width: (parent.width - 12) / 2
//                         spacing: 12

//                         // Marc Dupont card
//                         Rectangle {
//                             width: parent.width
//                             height: 144
//                             radius: 12
//                             color: "#ffffff"
//                             border.color: "#f3f4f6"
//                             border.width: 1

//                             Column {
//                                 anchors.centerIn: parent
//                                 spacing: 8

//                                 // Avatar
//                                 Rectangle {
//                                     width: 64
//                                     height: 64
//                                     radius: 32
//                                     color: "#4ae183"
//                                     anchors.horizontalCenter: parent.horizontalCenter

//                                     Text {
//                                         anchors.centerIn: parent
//                                         text: "MD"
//                                         font.pixelSize: 20
//                                         font.weight: Font.Bold
//                                         color: "#00210c"
//                                     }
//                                 }

//                                 Text {
//                                     anchors.horizontalCenter: parent.horizontalCenter
//                                     text: "Marc Dupont"
//                                     font.pixelSize: 13
//                                     font.weight: Font.SemiBold
//                                     color: "#191c1d"
//                                 }

//                                 Text {
//                                     anchors.horizontalCenter: parent.horizontalCenter
//                                     text: "Développeur"
//                                     font.pixelSize: 12
//                                     color: "#585f66"
//                                 }
//                             }
//                         }

//                         // Claire Petit card
//                         Rectangle {
//                             width: parent.width
//                             height: 144
//                             radius: 12
//                             color: "#ffffff"
//                             border.color: "#f3f4f6"
//                             border.width: 1

//                             Column {
//                                 anchors.centerIn: parent
//                                 spacing: 8

//                                 Rectangle {
//                                     width: 64
//                                     height: 64
//                                     radius: 32
//                                     color: "#a4c9ff"
//                                     anchors.horizontalCenter: parent.horizontalCenter

//                                     Text {
//                                         anchors.centerIn: parent
//                                         text: "CP"
//                                         font.pixelSize: 20
//                                         font.weight: Font.Bold
//                                         color: "#001c39"
//                                     }
//                                 }

//                                 Text {
//                                     anchors.horizontalCenter: parent.horizontalCenter
//                                     text: "Claire Petit"
//                                     font.pixelSize: 13
//                                     font.weight: Font.SemiBold
//                                     color: "#191c1d"
//                                 }

//                                 Text {
//                                     anchors.horizontalCenter: parent.horizontalCenter
//                                     text: "Marketing"
//                                     font.pixelSize: 12
//                                     color: "#585f66"
//                                 }
//                             }
//                         }
//                     }
//                 }

//                 // ── Row 2: Two small tiles (col-span-2) ──────────────
//                 Row {
//                     id: bentoRow2
//                     anchors.top: bentoRow1.bottom
//                     anchors.topMargin: 12
//                     width: parent.width
//                     spacing: 12

//                     // Jean Doe tile
//                     Rectangle {
//                         width: (parent.width - 12) / 2
//                         height: 68
//                         radius: 12
//                         color: "#f3f4f5"

//                         Row {
//                             anchors.left: parent.left
//                             anchors.leftMargin: 16
//                             anchors.verticalCenter: parent.verticalCenter
//                             spacing: 12

//                             Rectangle {
//                                 width: 40
//                                 height: 40
//                                 radius: 20
//                                 color: "#008645"

//                                 Text {
//                                     anchors.centerIn: parent
//                                     text: "JD"
//                                     font.pixelSize: 13
//                                     font.weight: Font.Bold
//                                     color: "#ffffff"
//                                 }
//                             }

//                             Column {
//                                 anchors.verticalCenter: parent.verticalCenter
//                                 spacing: 2

//                                 Text {
//                                     text: "Jean Doe"
//                                     font.pixelSize: 13
//                                     font.weight: Font.SemiBold
//                                     color: "#191c1d"
//                                 }
//                                 Text {
//                                     text: "Ami"
//                                     font.pixelSize: 10
//                                     color: "#585f66"
//                                 }
//                             }
//                         }
//                     }

//                     // Nouveau Favori tile
//                     Rectangle {
//                         width: (parent.width - 12) / 2
//                         height: 68
//                         radius: 12
//                         color: "#f3f4f5"

//                         Row {
//                             anchors.left: parent.left
//                             anchors.leftMargin: 16
//                             anchors.verticalCenter: parent.verticalCenter
//                             spacing: 12

//                             Rectangle {
//                                 width: 40
//                                 height: 40
//                                 radius: 20
//                                 color: "#005da7"

//                                 Text {
//                                     anchors.centerIn: parent
//                                     text: "+"
//                                     font.pixelSize: 22
//                                     font.weight: Font.Light
//                                     color: "#ffffff"
//                                 }
//                             }

//                             Column {
//                                 anchors.verticalCenter: parent.verticalCenter
//                                 spacing: 2

//                                 Text {
//                                     text: "Nouveau"
//                                     font.pixelSize: 13
//                                     font.weight: Font.SemiBold
//                                     color: "#191c1d"
//                                 }
//                                 Text {
//                                     text: "Favori"
//                                     font.pixelSize: 10
//                                     color: "#585f66"
//                                 }
//                             }
//                         }
//                     }
//                 }
//             }

//             Item { width: 1; height: 32 }

//             // ══════════════════════════════════════════════════
//             // SECTION "Tous les favoris"
//             // ══════════════════════════════════════════════════
//             Column {
//                 width: parent.width - 40
//                 anchors.horizontalCenter: parent.horizontalCenter
//                 spacing: 12

//                 // Section heading
//                 Text {
//                     text: "TOUS LES FAVORIS"
//                     font.pixelSize: 11
//                     font.weight: Font.SemiBold
//                     font.letterSpacing: 1.4
//                     color: "#717783"
//                 }

//                 // ── Row: Antoine Morel ────────────────────────
//                 Rectangle {
//                     width: parent.width
//                     height: 72
//                     radius: 12
//                     color: "#ffffff"
//                     border.color: "#f9fafb"
//                     border.width: 1

//                     Row {
//                         anchors.fill: parent
//                         anchors.leftMargin: 12
//                         anchors.rightMargin: 16
//                         anchors.topMargin: 12
//                         anchors.bottomMargin: 12
//                         spacing: 0

//                         // Avatar placeholder
//                         Rectangle {
//                             width: 48
//                             height: 48
//                             radius: 24
//                             color: "#c0c7cf"
//                             anchors.verticalCenter: parent.verticalCenter

//                             Text {
//                                 anchors.centerIn: parent
//                                 text: "AM"
//                                 font.pixelSize: 15
//                                 font.weight: Font.Bold
//                                 color: "#ffffff"
//                             }
//                         }

//                         Item { width: 16; height: 1 }

//                         Column {
//                             anchors.verticalCenter: parent.verticalCenter
//                             spacing: 3
//                             width: parent.width - 48 - 16 - 28 - 16

//                             Text {
//                                 text: "Antoine Morel"
//                                 font.pixelSize: 15
//                                 font.weight: Font.SemiBold
//                                 color: "#191c1d"
//                             }
//                             Text {
//                                 text: "Directeur Artistique"
//                                 font.pixelSize: 13
//                                 color: "#585f66"
//                             }
//                         }

//                         // Star icon
//                         Text {
//                             anchors.verticalCenter: parent.verticalCenter
//                             text: "\u2605"
//                             font.pixelSize: 22
//                             color: "#005da7"
//                         }
//                     }
//                 }

//                 // ── Row: Lucie Roux ───────────────────────────
//                 Rectangle {
//                     width: parent.width
//                     height: 72
//                     radius: 12
//                     color: "#ffffff"
//                     border.color: "#f9fafb"
//                     border.width: 1

//                     Row {
//                         anchors.fill: parent
//                         anchors.leftMargin: 12
//                         anchors.rightMargin: 16
//                         anchors.topMargin: 12
//                         anchors.bottomMargin: 12
//                         spacing: 0

//                         Rectangle {
//                             width: 48
//                             height: 48
//                             radius: 24
//                             color: "#a4c9ff"
//                             anchors.verticalCenter: parent.verticalCenter

//                             Text {
//                                 anchors.centerIn: parent
//                                 text: "LR"
//                                 font.pixelSize: 15
//                                 font.weight: Font.Bold
//                                 color: "#001c39"
//                             }
//                         }

//                         Item { width: 16; height: 1 }

//                         Column {
//                             anchors.verticalCenter: parent.verticalCenter
//                             spacing: 3
//                             width: parent.width - 48 - 16 - 28 - 16

//                             Text {
//                                 text: "Lucie Roux"
//                                 font.pixelSize: 15
//                                 font.weight: Font.SemiBold
//                                 color: "#191c1d"
//                             }
//                             Text {
//                                 text: "Consultante RH"
//                                 font.pixelSize: 13
//                                 color: "#585f66"
//                             }
//                         }

//                         Text {
//                             anchors.verticalCenter: parent.verticalCenter
//                             text: "\u2605"
//                             font.pixelSize: 22
//                             color: "#005da7"
//                         }
//                     }
//                 }

//                 // ── Row: Emma Garcia ──────────────────────────
//                 Rectangle {
//                     width: parent.width
//                     height: 72
//                     radius: 12
//                     color: "#ffffff"
//                     border.color: "#f9fafb"
//                     border.width: 1

//                     Row {
//                         anchors.fill: parent
//                         anchors.leftMargin: 12
//                         anchors.rightMargin: 16
//                         anchors.topMargin: 12
//                         anchors.bottomMargin: 12
//                         spacing: 0

//                         Rectangle {
//                             width: 48
//                             height: 48
//                             radius: 24
//                             color: "#dce3eb"
//                             anchors.verticalCenter: parent.verticalCenter

//                             Text {
//                                 anchors.centerIn: parent
//                                 text: "EG"
//                                 font.pixelSize: 15
//                                 font.weight: Font.Bold
//                                 color: "#40484e"
//                             }
//                         }

//                         Item { width: 16; height: 1 }

//                         Column {
//                             anchors.verticalCenter: parent.verticalCenter
//                             spacing: 3
//                             width: parent.width - 48 - 16 - 28 - 16

//                             Text {
//                                 text: "Emma Garcia"
//                                 font.pixelSize: 15
//                                 font.weight: Font.SemiBold
//                                 color: "#191c1d"
//                             }
//                             Text {
//                                 text: "Product Manager"
//                                 font.pixelSize: 13
//                                 color: "#585f66"
//                             }
//                         }

//                         Text {
//                             anchors.verticalCenter: parent.verticalCenter
//                             text: "\u2605"
//                             font.pixelSize: 22
//                             color: "#005da7"
//                         }
//                     }
//                 }
//             }
//         }
//     }

//     // ══════════════════════════════════════════════════════════
//     // FAB  ─ Floating Action Button
//     // ══════════════════════════════════════════════════════════
//     Rectangle {
//         id: fab
//         anchors.right: parent.right
//         anchors.rightMargin: 20
//         anchors.bottom: bottomNav.top
//         anchors.bottomMargin: 16
//         width: 56
//         height: 56
//         radius: 28
//         color: "#005da7"
//         z: 40

//         // Soft ambient shadow rings
//         Rectangle {
//             anchors.fill: parent
//             anchors.margins: -6
//             radius: 34
//             color: "transparent"
//             border.color: "#1a005da7"
//             border.width: 6
//             z: -1
//         }

//         Text {
//             anchors.centerIn: parent
//             text: "+"
//             font.pixelSize: 28
//             font.weight: Font.Light
//             color: "#ffffff"
//         }
//     }

//     // ══════════════════════════════════════════════════════════
//     // BOTTOM NAV BAR
//     // ══════════════════════════════════════════════════════════
//     Rectangle {
//         id: bottomNav
//         anchors.bottom: parent.bottom
//         anchors.left: parent.left
//         anchors.right: parent.right
//         height: 72
//         color: "#f5ffffff"
//         z: 50

//         Rectangle {
//             anchors.top: parent.top
//             anchors.left: parent.left
//             anchors.right: parent.right
//             height: 1
//             color: "#f3f4f6"
//         }

//         Row {
//             anchors.fill: parent
//             anchors.topMargin: 8
//             anchors.bottomMargin: 8

//             // Contacts tab (inactive)
//             Item {
//                 width: parent.width / 2
//                 height: parent.height

//                 Column {
//                     anchors.centerIn: parent
//                     spacing: 2

//                     Text {
//                         anchors.horizontalCenter: parent.horizontalCenter
//                         text: "\uD83D\uDC64"
//                         font.pixelSize: 22
//                         color: "#6b7280"
//                     }
//                     Text {
//                         anchors.horizontalCenter: parent.horizontalCenter
//                         text: "Contacts"
//                         font.pixelSize: 12
//                         font.weight: Font.Medium
//                         color: "#6b7280"
//                     }
//                 }
//             }

//             // Favoris tab (active)
//             Item {
//                 width: parent.width / 2
//                 height: parent.height

//                 Rectangle {
//                     anchors.centerIn: parent
//                     width: favTabContent.implicitWidth + 40
//                     height: 46
//                     radius: 16
//                     color: "#eff6ff"

//                     Row {
//                         id: favTabContent
//                         anchors.centerIn: parent
//                         spacing: 6

//                         Text {
//                             anchors.verticalCenter: parent.verticalCenter
//                             text: "\u2605"
//                             font.pixelSize: 22
//                             color: "#2563eb"
//                         }
//                         Text {
//                             anchors.verticalCenter: parent.verticalCenter
//                             text: "Favoris"
//                             font.pixelSize: 12
//                             font.weight: Font.Medium
//                             color: "#2563eb"
//                         }
//                     }
//                 }
//             }
//         }
//     }
// }

import QtQuick 2.15
import QtQuick.Controls 2.15

// Délégué réutilisable pour une ligne de contact
Item {
    id: root
    height: 72

    // Propriétés exposées
    property int    contactIndex: 0
    property string firstName:    ""
    property string lastName:     ""
    property string avatarBg:     "#dce3eb"
    property string avatarFg:     "#40484e"
    property bool   isFav:        false

    signal clicked()

    // Fond interactif
    Rectangle {
        anchors.fill: parent
        color: tap.pressed ? "#f0f4f8" : "transparent"
        Behavior on color { ColorAnimation { duration: 120 } }
    }

    // Carte blanche avec marges latérales
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        height: parent.height
        color: "#ffffff"
        radius: 0   // les coins sont gérés par le groupe de la section

        Row {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            anchors.topMargin: 12
            anchors.bottomMargin: 12
            spacing: 0

            // Avatar
            Rectangle {
                width: 48; height: 48; radius: 24
                color: root.avatarBg
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    anchors.centerIn: parent
                    text: (root.firstName.length > 0 ? root.firstName[0] : "") +
                          (root.lastName.length  > 0 ? root.lastName[0]  : "")
                    font.pixelSize: 15; font.weight: Font.Bold
                    color: root.avatarFg
                }

                // Petite étoile si favori
                Rectangle {
                    visible: root.isFav
                    anchors.right: parent.right; anchors.bottom: parent.bottom
                    width: 16; height: 16; radius: 8
                    color: "#005da7"
                    Text {
                        anchors.centerIn: parent
                        text: "★"; font.pixelSize: 9; color: "#ffffff"
                    }
                }
            }

            Item { width: 16; height: 1 }

            // Nom complet
            Text {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 48 - 16 - 24 - 16
                text: root.firstName + " " + root.lastName
                font.pixelSize: 16
                color: "#191c1d"
                elide: Text.ElideRight
            }

            // Chevron
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "›"; font.pixelSize: 24
                color: "#c1c7d3"
            }
        }

        // Séparateur interne (sauf dernier élément de section — géré visuellement)
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 80
            height: 1
            color: "#f3f4f6"
        }
    }

    TapHandler {
        id: tap
        onTapped: root.clicked()
    }
}

