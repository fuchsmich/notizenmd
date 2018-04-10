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

    Column {
        id:col
        width: parent.width

        PageHeader {
            title: flick.title
            description: flick.description
        }

        TextArea {
            //http://doc.qt.io/qt-5/qtextdocument.html#defaultStyleSheet-prop
            id: textArea
            width: parent.width

            readOnly: true
            wrapMode: TextEdit.Wrap
            Component.onCompleted: {
                _editor.textFormat = TextEdit.RichText
            }
            function showHTML() {
                _editor.textFormat = ( _editor.textFormat == TextEdit.RichText ?
                                          TextEdit.PlainText :
                                          TextEdit.RichText)
            }
        }
    }
}
