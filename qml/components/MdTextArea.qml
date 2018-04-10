import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit.experimental 1.0

SilicaFlickable {
    contentHeight: col.height + Theme.paddingLarge
    property string markdown: ""
    onMarkdownChanged: {}

//header?
    property Item header: PageHeader { }

    Column {
        id:col
        width: parent.width
        Loader {
            source: header
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
