import QtQuick 2.0
import Sailfish.Silica 1.0
//import QtWebKit.experimental 1.0
import "../components"

Page {
    id: page

    allowedOrientations: Orientation.All
    property string title: (viewCheatSheet ? qsTr("CheatSheet") : "")
    property string description: (viewCheatSheet ? "" : currentFile.path )
    property int viewMode: settings.viewItemIndex
    property bool viewCheatSheet: false

    function handleLink(link) {
        // detect URL scheme prefix, most likely an external link
        var schemaRE = /^\w+:/;
        if (schemaRE.test(link)) {
            console.log("external", link);
            Qt.openUrlExternally(link)
        } else {
            console.log("internal", link);
            var cf = currentFile.path
            var folderName = cf.substring(0, cf.lastIndexOf("/")+1)
            console.log(folderName + link);
            currentFile.path = folderName + link;
        }
    }

    Loader {
        id: viewLoader
        anchors.fill: parent
        onLoaded: {
            item.title = page.title;
            item.description = page.description;
            if (!viewCheatSheet) {
                item.pullDownMenu = pullDownComp.createObject(item);
                item.markDown = Qt.binding(function(){ return currentFile.content });
                item.linkActivated.connect(handleLink)
            } else {
                loadCheatsheet();
            }
        }
    }

    Component {
        id: pullDownComp
        PullDownMenu {
            MenuItem {
                text: qsTr("Toggle html/text")
                onClicked: viewLoader.item.toggleHtmlText()
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
                viewLoader.item.markdown = req.responseText;
            }
        }
        req.send()
    }

    states: [
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
                source: Qt.resolvedUrl("../components/MdGeckoView.qml")
            }
        }
    ]

    onStateChanged: console.log(state)
}
