import QtQuick 2.1
import Sailfish.Silica 1.0
//import Sailfish.Engine 1.0
import Sailfish.WebView 1.0

WebViewFlickable {
    id: wv
    property string markdown: ""
    onMarkdownChanged: {
        updateText()
    }
    property string title: ""
    property string description: ""
//    property int textFormat: TextEdit.RichText
//    onTextFormatChanged: {
//        updateText()
//    }

    signal linkActivated(string link)

//    function toggleHtmlText() {
//        textFormat = ( textFormat === TextEdit.RichText ?
//                                  TextEdit.PlainText :
//                                  TextEdit.RichText)
//    }

    header: PageHeader {
        title: wv.title
        description: wv.description
    }

//    webView.url: Qt.resolvedUrl("../html/index.html")

//    function updateText() {
//        var script = 'setBaseUrl("' + currentFile.folder + '")';
//        wv.experimental.evaluateJavaScript(script , function(){})
//        script = 'updateText(' + JSON.stringify(markdown) + ',' + textFormat + ')';
//        wv.experimental.evaluateJavaScript(script , function(){})
//    }
//    onNavigationRequested: {
//        if (request.url !== wv.url) {
//            request.action = wv.IgnoreRequest;
//            linkActivated(request.url);
//        }
//    }

//    experimental.preferences.navigatorQtObjectEnabled: true
//    experimental.onMessageReceived: console.log(message.data)

//    onLoadingChanged: if (loadRequest.status === wv.LoadSucceededStatus) updateText(markdown)
}
