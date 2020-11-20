import QtQuick 2.1
import Sailfish.Silica 1.0
//import Sailfish.Engine 1.0
import Sailfish.WebView 1.0

WebViewFlickable {
    id: wv
    property string markdown: ""
    onMarkdownChanged: {
        //updateText()
    }
    property string title: ""
    property string description: ""
    property int textFormat: TextEdit.RichText
    onTextFormatChanged: {
        //updateText()
    }

    function toggleHtmlText() {
        textFormat = ( textFormat === TextEdit.RichText ?
                                  TextEdit.PlainText :
                                  TextEdit.RichText)
    }

    signal linkActivated(string link)

    header: PageHeader {
        title: wv.title
        description: wv.description
    }

    Connections {
        target: wv.webView
        function onLinkActivated(link){ wv.linkActivated(link) }
    }

    function updateText() {
//        var script = 'setBaseUrl("' + currentFile.folder + '")';
//        wv.experimental.evaluateJavaScript(script , function(){})
        var script = 'data:,updateText(%1, %2)'.arg(JSON.stringify(wv.markdown)).arg(wv.textFormat)
        webView.loadFrameScript(script, true)
//        wv.experimental.evaluateJavaScript(script , function(){})
    }

    webView {
        url: Qt.resolvedUrl("../html/index.html")

        //onViewInitialized: updateText()

        onRecvAsyncMessage: console.log(JSON.stringify(data))

    }

//    experimental.preferences.navigatorQtObjectEnabled: true
//    experimental.onMessageReceived: console.log(message.data)

//    onLoadingChanged: if (loadRequest.status === wv.LoadSucceededStatus) updateText(markdown)
}
