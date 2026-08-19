import Quickshell
import QtQuick

Item {
  id: wrapper
  property real margin: root.margin
  required default property Item child

  //anchors.horizontalCenter: parent.horizontalCenter

  implicitWidth: child.implicitWidth + margin * 2
  implicitHeight: child.implicitHeight + margin * 2

  Rectangle {
    anchors.fill: parent
    color: root.colBg
    radius: 8
  }

  Component.onCompleted: {
        if (child) {
            child.parent = wrapper
            child.x = Qt.binding(() => wrapper.margin)
            child.y = Qt.binding(() => wrapper.margin)
        }
    }
}