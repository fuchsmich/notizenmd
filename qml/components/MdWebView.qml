import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit.experimental 1.0

SilicaWebView {
    id: webView
    property string markdown: ""
    onMarkdownChanged: {
        updateText(markdown)
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

    experimental.preferences.navigatorQtObjectEnabled: true
    experimental.onMessageReceived: console.log(message.data)

    onLoadingChanged: if (loadRequest.status === WebView.LoadSucceededStatus) updateText(markdown)
}
