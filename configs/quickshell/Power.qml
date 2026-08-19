import Quickshell
import QtQuick

CustomItem {
    id: wrapper

    Text {
        text: "\uF011"
        font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
        color: '#ed5350'

        MouseArea {
            Run {id: run}
            anchors.fill: parent
            onClicked: run.launch("wlogout")
        }
    }
}
