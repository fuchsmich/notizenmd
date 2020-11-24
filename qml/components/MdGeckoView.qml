import QtQuick 2.1
import Sailfish.Silica 1.0
import Sailfish.WebEngine 1.0
import Sailfish.WebView 1.0

WebViewFlickable {
    id: wv

    property string markDown: ""
    onMarkDownChanged: {
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
                                         "markDown": wv.markDown,
                                         "textFormat": wv.textFormat
                                     })
        }
    }

    webView {
        url: Qt.resolvedUrl("../html/index.html")

        onViewInitialized: {
            webView.loadFrameScript(Qt.resolvedUrl("../html/marked/marked.min.js"))
            webView.loadFrameScript(Qt.resolvedUrl("../html/utils.js"))
            webView.addMessageListeners(["NotizenMD:OpenLink"])
            //console.log("webView initialized")
        }

        onFirstPaint: {
            contentReady = true
        }

        onRecvAsyncMessage: {
            switch (message) {
            case "NotizenMD:OpenLink":
                console.log("open link", data.uri)
                linkActivated(data.uri)
                break
            default:
                break
            }
        }
    }
}
