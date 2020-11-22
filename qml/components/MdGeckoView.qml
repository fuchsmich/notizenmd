import QtQuick 2.1
import Sailfish.Silica 1.0
import Sailfish.WebEngine 1.0
import Sailfish.WebView 1.0

WebViewFlickable {
    id: wv

    property string markdown: ""
    onMarkdownChanged: {
        updateText()
    }
    property string title: ""
    property string description: ""
    property int textFormat: TextEdit.RichText
    onTextFormatChanged: {
        updateText()
    }

    function toggleHtmlText() {
        textFormat = (textFormat === TextEdit.RichText ?
                                  TextEdit.PlainText :
                                  TextEdit.RichText)
    }

    property bool contentReady: false
    onContentReadyChanged: updateText()

    signal linkActivated(string link)

    header: PageHeader {
        title: wv.title
        description: wv.description
    }

    function updateText() {
        if (contentReady) {
            webView.sendAsyncMessage("NotizenMd:UpdateText", {
                                         "markdown": wv.markdown,
                                         "textFormat": wv.textFormat
                                     })
        }
    }

    webView {
        url: Qt.resolvedUrl("../html/index.html")

        onViewInitialized: {
            webView.loadFrameScript(Qt.resolvedUrl("../html/marked/marked.min.js"))
            webView.loadFrameScript(Qt.resolvedUrl("../html/utils.js"))
            console.log("webView initialized")
        }

        onRecvAsyncMessage: console.log(message, JSON.stringify(data))

        onFirstPaint: {
            contentReady = true
        }
    }
}
