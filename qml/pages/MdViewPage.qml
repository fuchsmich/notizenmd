import QtQuick 2.0
import Sailfish.Silica 1.0
//import QtWebKit.experimental 1.0
import "../components"

Page {
    id: page

    allowedOrientations: Orientation.All
    property string title: ""
    property string filePath: currentFile.path
    property string text: currentFile.content
    property int viewMode: settings.viewItemIndex

    Loader {
        id: viewLoader
        anchors.fill: parent
        onLoaded: {
            item.header = headerComp;
            item.pullDownMenu = pullDownComp.createObject(item)
            item.markdown = Qt.binding(function(){ return currentFile.content })
        }
    }

    Component {
        id: headerComp
        PageHeader {
            title: page.title
            description: page.filePath
        }
    }

    Component {
        id: pullDownComp
        PullDownMenu {
            MenuItem {
                text: qsTr("View html")
                onClicked: textArea.toggleRT()
            }
            MenuItem {
                text: qsTr("Switch to %1").arg((viewMode === 0 ? "WebView" : "TextArea"))
                onClicked: viewMode = !viewMode*1
            }
            MenuItem {
                text: qsTr("Edit")
                onClicked: pageStack.push(Qt.resolvedUrl("EditNotePage.qml"))
            }
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Active) {
            currentFile.read();
        }
    }

    function loadCheatsheet() {
        var req =  new XMLHttpRequest();
        req.open('GET', Qt.resolvedUrl("/usr/share/harbour-notizenmd/qml/docs/Markdown Cheatsheet.md"));
        req.onreadystatechange = function(event) {
            if (req.readyState === XMLHttpRequest.DONE) {
                //console.log("cheat text")
                page.text = req.responseText;
            }
        }
        req.send()
    }

    states: [
        State {
            name: "cheatsheet"
            PropertyChanges {
                target: pullDown
                visible: false
            }
            PropertyChanges {
                target: page
                title: qsTr("Cheatsheet")
                filePath: settings.cheatSheetURL
            }
            StateChangeScript {
                name: "loadCheatsheet"
                script: loadCheatsheet()
            }
        },
        State {
            name: "textArea"
            when: viewMode === 0
            PropertyChanges {
                target: viewLoader
                source: Qt.resolvedUrl("../components/MdTextArea.qml")
            }
        },
        State {
            name: "webView"
            when: viewMode === 1
            PropertyChanges {
                target: viewLoader
                source: Qt.resolvedUrl("../components/MdWebView.qml")
            }
            PropertyChanges {
                target: viewLoader.item
            }
        }
    ]
}
