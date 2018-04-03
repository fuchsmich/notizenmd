import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: page
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        VerticalScrollDecorator {}
        Column {
            id:col
            width: parent.width
            PageHeader {
                title: currentFile.path
            }
            TextArea {
                id: ta
                property bool loaded: false
                width: parent.width
                text: currentFile.content
                onTextChanged: if (loaded) autosaveTimer.restart()
                Component.onCompleted: loaded = true;
            }
            Timer {
                id: autosaveTimer
                interval: 5000
                onTriggered: currentFile.save(ta.text)
            }
        }
    }
    Component.onDestruction: currentFile.save(ta.text)
}
