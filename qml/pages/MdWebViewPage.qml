import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit.experimental 1.0
import "../components"

Page {
    id: page

    allowedOrientations: Orientation.All
    property string title: ""
    property string filePath: currentFile.path
    property string text: currentFile.content
    onTextChanged: {
        //console.log(text);
        webView.updateText(text)
    }

    FileIO {
        id: file
    }

    SilicaWebView {
        id: webView
        anchors.fill: parent

        PullDownMenu {
            id: pullDown
            MenuItem {
                text: qsTr("View html")
                onClicked: webView.showHTML()
            }
            MenuItem {
                text: qsTr("Switch to %1").arg("TextArea")
                onClicked: pageStack.replace(Qt.resolvedUrl("MdViewTextAreaPage.qml"))
            }
            MenuItem {
                text: qsTr("Edit")
                onClicked: pageStack.push(Qt.resolvedUrl("EditNotePage.qml"))
            }
        }

        header: PageHeader {
            title: page.title
            description: page.filePath
        }

        url: Qt.resolvedUrl("../html/index.html")

        function updateText(text) {
            var script = 'updateText(' + JSON.stringify(text) + ')';
            //console.log(script);
            webView.experimental.evaluateJavaScript(script , function(){})
        }
        function showHTML(text) {
            var script = 'showHTML()';
            //console.log(script);
            webView.experimental.evaluateJavaScript(script , function(){})
        }


        signal messageReceived(var message)

        function runJavaScript(script, callback) {
            return webView.experimental.evaluateJavaScript(script, callback);
        }

        experimental.preferences.navigatorQtObjectEnabled: true
        experimental.onMessageReceived: webView.messageReceived(message)

        onLoadingChanged: if (loadRequest.status === WebView.LoadSucceededStatus) updateText(page.text)

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
        }
    ]
}
