import Quickshell
import Quickshell.Io
import QtQuick

CustomItem {
    Text {
        id: child

        font { family: root.fontFamily; pixelSize: root.fontSize-3; bold: true }
        color: root.colPassive

        Process {
            id: update_time
            command: ["sh", Quickshell.shellPath("datetime.sh")]
            running: true
            stdout: StdioCollector {
                onStreamFinished: child.text = text
            }
        }

        MouseArea {
            Run{id: run}
            anchors.fill: parent
            onClicked: run.launch("kclock")
        }

        Timer {
            interval: 500
            repeat: true
            running: true
            onTriggered: update_time.running = true
        }
    }
}
