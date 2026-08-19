import Quickshell
import Quickshell.Io
import QtQuick

Item {
    function launch(cmd) {
        appRunner.command = Array.isArray(cmd) ? cmd : [cmd];
        appRunner.running = true;
    }

    Process {
        id: appRunner
    }
}
