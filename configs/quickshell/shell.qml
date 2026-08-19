import Quickshell
import QtQuick

ShellRoot {
    PanelWindow {
        id: root
    
        property color colBg: '#cb1a1b26'
        property color colPassive: '#4b799e'
    
        property color colInactive: "#444b6a"
        property color colSome: "#7aa2f7"
        property color colActive: "#0db9d7"
        property color colAlert: '#74ffdf'
    
        property string fontFamily: "JetBrainsMono Nerd Font"
        property int fontSize: 14
        property int margin: 8
    
        anchors.top: true
        anchors.left: true
        anchors.right: true
        margins.top: 6
        implicitHeight: 36
        color: '#0074ffdf'
    
        Clock {anchors.left: parent.left; anchors.leftMargin: 10; id: clock}
        Lang {anchors.left: clock.right; anchors.leftMargin: 10; id: lang}
        Player {anchors.left: lang.right; anchors.leftMargin: 10; id: mpris}
        
        Workspaces {anchors.centerIn: parent; id: ws}

        Network {anchors.right: aud.left; anchors.rightMargin: 10; id: net}
        Audio {anchors.right: upd.left; anchors.rightMargin: 10; id: aud}
        Update {anchors.right: pwbtm.left; anchors.rightMargin: 10; id: upd}
        Power {anchors.right: parent.right; anchors.rightMargin: 10; id: pwbtm}
    }
}
