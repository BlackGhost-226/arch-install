import Quickshell
import QtQuick

import QtQuick.Layouts
import Quickshell.Networking
import Quickshell.Bluetooth

CustomItem {
    id: wrapper
    RowLayout {
        Run {id: run}

        Text {
            id: wifi
            readonly property var activeDevice: {
                for (var dev of Networking.devices.values) {
                    if (dev.state === ConnectionState.Connected) {
                        return dev
                    }
                }
                return null
            }

            readonly property var activeNetwork: {
                for (var net of activeDevice.networks.values) {
                    if (net.state === ConnectionState.Connected) {
                        return net
                    }
                }
                return null
            }

            readonly property int nmSignalStrength: {
                if (!activeNetwork || activeNetwork.signalStrength <= 0) return 0

                // Map 0.0 - 1.0 linear back to estimated dBm (-100 to -40 dBm)
                var dbm = -100 + (activeNetwork.signalStrength * 60)

                // NetworkManager non-linear percentage mapping formula
                if (dbm <= -100) return 0
                if (dbm >= -50) return 100

                // Standard NM dBm-to-percent curve
                var nmPercent = Math.round(2 * (dbm + 100))
                return Math.min(100, Math.max(0, nmPercent))
            }
        
            readonly property string statusText: {
                if (!activeDevice) return "Disconnected ⚠"

                if (activeDevice.type === DeviceType.Wifi) {
                    if (activeNetwork) {
                        return `  ${Math.round(activeNetwork.signalStrength*100)}%`
                    }
                    return "  Connected"
                }

                if (activeDevice.type === DeviceType.Wired) {
                    return "\uf796"
                }

                return "Connected"
            }

            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
            color: root.colPassive

            text: statusText

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) {
                        run.launch("nm-connection-editor") 
                    } else if (mouse.button === Qt.RightButton) {
                        run.launch(["sh", Quickshell.shellPath("reloadNet.sh")])
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
            id: bluetooth
            property var devices: Bluetooth.defaultAdapter.devices
            
            readonly property string devicesStr: {
                var dev = ""
                var list = Bluetooth.defaultAdapter.devices.values

                for (var i = 0; i < list.length; i++) {
                    var device = list[i]
                    if (device && device.connected) {
                        dev = dev + device.name + " "
                    }
                }
                return dev.trim()
            }

            readonly property string state: {
                var state = Bluetooth.defaultAdapter.state
                if (Bluetooth.defaultAdapter.enabled === true) {
                    if (devicesStr !== "") return devicesStr
                    
                    if (state === BluetoothAdapterState.Disabled) return "off"
                    if (state === BluetoothAdapterState.Enabled) return "on"
                    if (state === BluetoothAdapterState.Disabling) return "stoping"
                    if (state === BluetoothAdapterState.Enabling) return "starting"
                    if (state === BluetoothAdapterState.Blocked) return "X"
                } else return "X"
            }

            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
            color: root.colPassive

            text: "\uF294 "+state

            MouseArea {
                anchors.fill: parent
                onClicked: run.launch("blueman-manager")
            }
        }
    }
}