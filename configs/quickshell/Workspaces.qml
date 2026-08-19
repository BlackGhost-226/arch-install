import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Layouts

CustomItem {
    RowLayout {
            Repeater {
                model: 4

                Text {
                    property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                    property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                    text: index + 1
                    font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
                    color: isActive ? root.colActive : (ws ? root.colSome : root.colInactive)

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch('hl.dsp.focus({ workspace = "%1" })'.arg(index+1))
                    }
                }
            }

            Item { Layout.fillWidth: true }
        }
}
