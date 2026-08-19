import Quickshell
import QtQuick

import Quickshell.Services.Mpris
import QtQuick.Layouts

CustomItem {
    id: wrapper

    readonly property MprisPlayer activePlayer: {
        var players = Mpris.players.values
        if (players.length === 0) return null
        
        for (var i = 0; i < players.length; i++) {
            if (players[i].playbackState === MprisPlaybackState.Playing) {
                return players[i]
            }
        }
        return players[0]
    }

    readonly property string shortTitle: {
        var max_len = 40
        var after_str = "..."
        if (wrapper.activePlayer.trackTitle.length > max_len) {
            return wrapper.activePlayer.trackTitle.slice(0, max_len-after_str.length)+after_str
        }
        return wrapper.activePlayer.trackTitle
    }

    readonly property string playState: {
        if (wrapper.activePlayer.playbackState === MprisPlaybackState.Paused) {
            return ""
        }
        else if (wrapper.activePlayer.playbackState === MprisPlaybackState.Playing) {
            return ""
        }
        else if (wrapper.activePlayer.playbackState === MprisPlaybackState.Stopped) {
            return ""
        }
    }
        
    RowLayout {
        visible: wrapper.activePlayer !== null

            Text {
                text: wrapper.playState +' '+ wrapper.shortTitle
                font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
                color: root.colPassive

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton) {
                            wrapper.activePlayer.togglePlaying()
                        } else if (mouse.button === Qt.RightButton) {
                            wrapper.activePlayer.next()
                        } else if (mouse.button === Qt.MiddleButton) {
                            wrapper.activePlayer.previous()
                        }
                    }

                    onWheel: event => {
                        if (event.angleDelta.y > 0) {
                            wrapper.activePlayer.seek(5)
                        } else if (event.angleDelta.y < 0) {
                            wrapper.activePlayer.seek(-5)
                        }
                    }
                }
            }
    }
}
