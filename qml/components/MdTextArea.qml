import QtQuick 2.0
import Sailfish.Silica 1.0

SilicaFlickable {
    contentHeight: col.height + Theme.paddingLarge
    contentWidth: col.width
    property string markdown: ""
    onMarkdownChanged: {
        mistune.call('mistune.markdown', [markdown], function(html){
            textArea.text = html;
        })
    }

//header?
    property Component header: Component {
        PageHeader {
            title: "placeholder"
        }
    }

    Column {
        id:col
        width: parent.width
        Loader {
            sourceComponent: header
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
