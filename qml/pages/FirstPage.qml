import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit.experimental 1.0
//import QtWebChannel 1.0
//import Sailfish.WebView 1.0

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaWebView {
        id: webView
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Show Page 2")
                onClicked: webView.runJavaScript('updateText("# schwubidubi")',
                                          function(){});
            }
        }

        url: Qt.resolvedUrl("../marked/index.html")

        Component.onCompleted: {
//            runJavaScript("document.title", function(result) {console.log(result)});
        }
        signal messageReceived(var message)

        Connections {
            target: app
            onWebViewRunJavaScript: webView.runJavaScript(script, callback)
        }

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

    }
}
