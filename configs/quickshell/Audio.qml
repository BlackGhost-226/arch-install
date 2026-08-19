import Quickshell
import QtQuick

import Quickshell.Services.Pipewire
import QtQuick.Layouts

CustomItem {
    id: wrapper

    function nodeVol(node, mut_str, str) {
        if (node === null) return str+" None"
        if (node.audio.muted) {
            return mut_str+" Muted"
        } else {
            return str+" "+Math.round(node.audio.volume*100)+"%"
        }
    }
    
    RowLayout {
        PwObjectTracker{objects: [sink.node, source.node]}
        Run {id: run}
        
        Text {
            id: sink
            property PwNode node: Pipewire.defaultAudioSink
            text: nodeVol(node, "", " ")
            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
            color: root.colPassive

            MouseArea {
                anchors.fill: parent
                onClicked: run.launch(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"])

                onWheel: event => {
                    if (event.angleDelta.y > 0) {
                        run.launch(["wpctl", "set-volume", "-l", "1", "@DEFAULT_AUDIO_SINK@", "5%+"])
                    } else if (event.angleDelta.y < 0) {
                        run.launch(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"])
                    }
                }
            }
        }

        Text {
            text: "-"
            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
            color: root.colPassive
        }

        Text {
            id: source
            property PwNode node: Pipewire.defaultAudioSource
            text: nodeVol(node, "", "")
            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
            color: root.colPassive

            MouseArea {
                anchors.fill: parent
                onClicked: run.launch(["wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle"])

                onWheel: event => {
                    if (event.angleDelta.y > 0) {
                        run.launch(["wpctl", "set-volume", "-l", "1", "@DEFAULT_AUDIO_SOURCE@", "5%+"])
                    } else if (event.angleDelta.y < 0) {
                        run.launch(["wpctl", "set-volume", "@DEFAULT_AUDIO_SOURCE@", "5%-"])
                    }
                }
            }
        }
    }
}
