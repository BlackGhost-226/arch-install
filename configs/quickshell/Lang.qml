import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

CustomItem {
    id: wrapper
    property string currentLang: "en"

    function parseLanguage(layoutName) {
        if (!layoutName) return "??"

        if (layoutName.includes("English")) return "en"
        if (layoutName.includes("Spanish")) return "es"
        if (layoutName.includes("Russian")) return "ru"
        
        return layoutName.substring(0, 2)
    }

    Text {
        anchors.centerIn: parent
        text: parent.currentLang
        font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
        color: root.colPassive

        Connections {
            target: Hyprland
            function onRawEvent(event) {
                if (event.name === "activelayout") {
                    var parts = event.data.split(",")
                    var layoutName = parts[1] ? parts[1].trim() : ""
                    wrapper.currentLang = parseLanguage(layoutName)
                }
            }
        }
        
        MouseArea {
            anchors.fill: parent
            Run {id: run}
            onClicked: {
                run.launch(["hyprctl", "switchxkblayout", "main", "next"])
            }
        }
    }
}