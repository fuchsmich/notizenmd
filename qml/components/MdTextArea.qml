import QtQuick 2.0
import Sailfish.Silica 1.0

SilicaFlickable {
    id: flick
    contentHeight: col.height + Theme.paddingLarge
    contentWidth: col.width
    property string markdown: ""
    onMarkdownChanged: {
        mistune.call('mistune.markdown', [markdown], function(html){
            textArea.text = html;
        })
    }
    property string title: ""
    property string description: ""
    signal linkActivated(string link)

    function toggleHtmlText() {
        textArea.toggleHtmlText()
    }

    Column {
        id:col

        width: parent.width

        PageHeader {
            title: flick.title
            description: flick.description
        }

        Label {
            //http://doc.qt.io/qt-5/qtextdocument.html#defaultStyleSheet-prop
            id: textArea
            x: Theme.horizontalPageMargin
            width: parent.width - 2*x

            //readOnly: true
            wrapMode: TextEdit.Wrap
            textFormat: TextEdit.RichText
            baseUrl: currentFile.folder
            onLinkActivated: {
                console.log(link);
                flick.linkActivated(Qt.resolvedUrl(baseUrl + link));
            }


            function toggleHtmlText() {
                textFormat = (textFormat == TextEdit.RichText ?
                                          TextEdit.PlainText :
                                          TextEdit.RichText)
            }
        }
    }
}
