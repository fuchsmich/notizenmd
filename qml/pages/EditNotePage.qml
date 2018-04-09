import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: page
    allowedOrientations: Orientation.All
    property string cheatText: ""
    onCheatTextChanged: if (status == PageStatus.Active) attachCheatPage();

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
    function loadCheatsheet() {
        var req =  new XMLHttpRequest();
        req.open('GET', Qt.resolvedUrl("/usr/share/harbour-notizenmd/qml/docs/Markdown Cheatsheet.md"));
        req.onreadystatechange = function(event) {
            if (req.readyState === XMLHttpRequest.DONE) {
                //console.log("cheat text")
                cheatText = req.responseText;
            }
        }
        req.send()
    }

    function attachCheatPage() {
        var pageFile = settings.viewItemIndex == 0 ?
                    "MdViewTextAreaPage.qml":
                    "MdWebViewPage.qml";
        pageStack.pushAttached(Qt.resolvedUrl(pageFile), {
                                   "text": cheatText,
                                   "title": qsTr("CheatSheet"),
                                   "filePath": ""});
    }

    Component.onCompleted: loadCheatsheet()

    onStatusChanged:
        if (status == PageStatus.Active && cheatText != "") {
            attachCheatPage();
        }
}
