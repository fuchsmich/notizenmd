import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: page
    allowedOrientations: Orientation.All
//    property string cheatText: ""
//    onCheatTextChanged: if (status == PageStatus.Active) attachCheatPage();

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        VerticalScrollDecorator {}
        Column {
            id:col
            width: parent.width
            PageHeader {
                description: currentFile.path
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

    function attachCheatPage() {
        var pageFile = settings.viewItemIndex == 0 ?
                    "MdViewTextAreaPage.qml":
                    "MdWebViewPage.qml";
        pageStack.pushAttached(Qt.resolvedUrl(pageFile), {
                                   "state": "cheatSheet"
                               });
    }

    Component.onCompleted: loadCheatsheet()

    onStatusChanged:
        if (status == PageStatus.Active && cheatText != "") {
            attachCheatPage();
        }
}
