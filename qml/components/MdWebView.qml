import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit.experimental 1.0

SilicaWebView {
    id: webView
    property string markdown: ""
    onMarkdownChanged: {}

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


    //        signal messageReceived(var message)

    //        function runJavaScript(script, callback) {
    //            return webView.experimental.evaluateJavaScript(script, callback);
    //        }

    experimental.preferences.navigatorQtObjectEnabled: true
    experimental.onMessageReceived: console.log(message.data)

    onLoadingChanged: if (loadRequest.status === WebView.LoadSucceededStatus) updateText(page.text)

}
