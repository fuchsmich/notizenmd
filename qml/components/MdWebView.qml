import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit.experimental 1.0

SilicaWebView {
    id: webView
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
        textFormat = ( textFormat === TextEdit.RichText ?
                                  TextEdit.PlainText :
                                  TextEdit.RichText)
    }

    header: PageHeader {
        title: webView.title
        description: webView.description
    }

    url: Qt.resolvedUrl("../html/index.html")

    function updateText() {
        var script = 'updateText(' + JSON.stringify(markdown) + ',' + textFormat + ')';
        console.log(textFormat);
        webView.experimental.evaluateJavaScript(script , function(){})
    }

    experimental.preferences.navigatorQtObjectEnabled: true
    experimental.onMessageReceived: console.log(message.data)

    onLoadingChanged: if (loadRequest.status === WebView.LoadSucceededStatus) updateText(markdown)
}
