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

    signal linkActivated(string link)

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
        var script = 'setBaseUrl("' + currentFile.folder + '")';
        webView.experimental.evaluateJavaScript(script , function(){})
        script = 'updateText(' + JSON.stringify(markdown) + ',' + textFormat + ')';
        webView.experimental.evaluateJavaScript(script , function(){})
    }
    onNavigationRequested: {
        if (request.url !== webView.url) {
            request.action = WebView.IgnoreRequest;
            linkActivated(request.url);
        }
    }

    experimental.preferences.navigatorQtObjectEnabled: true
    experimental.onMessageReceived: console.log(message.data)

    onLoadingChanged: if (loadRequest.status === WebView.LoadSucceededStatus) updateText(markdown)
}
