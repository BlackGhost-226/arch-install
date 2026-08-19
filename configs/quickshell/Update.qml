import Quickshell
import QtQuick

import Quickshell.Io

CustomItem {
    Text {
        id: child

        font { family: root.fontFamily; pixelSize: root.fontSize-3; bold: true }
        color: root.colPassive

        Process {
            id: update
            command: ["uname", "-r"]
            running: true
            stdout: StdioCollector {
                onStreamFinished: child.text = text
            }
        }

        MouseArea {
            Run{id: run}
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: mouse => {
                if (mouse.button === Qt.LeftButton) {
                    run.launch(["kitty", "sudo", "pacman", "-Sy"])
                } else {
                    run.launch(["kitty", "sudo", "pacman", "-Syu"])
                }
            }
        }
    }
}
