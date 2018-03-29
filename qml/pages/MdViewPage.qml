import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit.experimental 1.0

Page {
    id: page

    allowedOrientations: Orientation.All
    property string filePath
    property string text: ""
    onTextChanged: webView.updateText(text)

    SilicaWebView {
        id: webView
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Edit")
                onClicked: pageStack.push(Qt.resolvedUrl("NoteEditPage.qml"), {
                                              filePath: page.filePath,
                                              text: webView.text
                                          })
            }
        }

        url: Qt.resolvedUrl("../html/index.html")

        function updateText(text) {
            var script = 'updateText(' + JSON.stringify(text) + ')';
            //console.log(script);
            webView.experimental.evaluateJavaScript(script , function(){})
        }


        function loadFile() {
            if (!page.filePath) {
                webView.updateText("No file selected");
                return;
            }
            var req =  new XMLHttpRequest();
            req.open('GET', page.filePath);
            req.onreadystatechange = function(event) {
                if (req.readyState === XMLHttpRequest.DONE) {
                    page.text = req.responseText;
                }
            }
            req.send()
        }

        Component.onCompleted: {
        }
        signal messageReceived(var message)

        function runJavaScript(script, callback) {
            return webView.experimental.evaluateJavaScript(script, callback);
        }

        experimental.preferences.navigatorQtObjectEnabled: true
        experimental.onMessageReceived: webView.messageReceived(message)

        onLoadingChanged: if (loadRequest.status === WebView.LoadSucceededStatus) loadFile()

    }
}
