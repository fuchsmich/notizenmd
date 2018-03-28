import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit.experimental 1.0
//import QtWebChannel 1.0
//import Sailfish.WebView 1.0

Page {
    id: page

    allowedOrientations: Orientation.All
    property string filePath

    SilicaWebView {
        id: webView
        anchors.fill: parent
        property string text: ""

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
                    //console.log(req.responseText)
                    //webView.updateText('# ein Test und noch einer')
                    webView.text = req.responseText;
                    webView.updateText(req.responseText);
                }
            }
            req.send()
//            webView.experimental.evaluateJavaScript("loadFile(\"" + page.filePath + "\")" , function(){})
        }

        Component.onCompleted: {
        }
        signal messageReceived(var message)

//        Connections {
//            target: app
//            onWebViewRunJavaScript: webView.runJavaScript(script, callback)
//        }

        function runJavaScript(script, callback) {
            return webView.experimental.evaluateJavaScript(script, callback);
        }

//        property Item _webPage: webView.experimental.page
//        experimental.preferredMinimumContentsWidth: _webPage.width
//        experimental.deviceWidth: Screen.width
//        experimental.deviceHeight: Screen.height
//        experimental.enableInputFieldAnimation: false

        experimental.preferences.navigatorQtObjectEnabled: true
        experimental.onMessageReceived: webView.messageReceived(message)

        onLoadingChanged: if (loadRequest.status === WebView.LoadSucceededStatus) loadFile()

    }
}
