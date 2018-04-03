import QtQuick 2.0
import Sailfish.Silica 1.0
//import QtWebKit.experimental 1.0
import io.thp.pyotherside 1.4
import "../components"


Page {
    id: page

    allowedOrientations: Orientation.All
    property string filePath: currentFile.path
    property string md: currentFile.content
    onMdChanged: py.call('mistune.markdown', [md], function(text){
        var html = "<html>" + text + "</html>";
        textArea.text = html;
    })

    Python {
        id: py
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../python'));
            importModule('mistune', function() {});
        }
    }

    SilicaFlickable {
        anchors.fill: parent        
        contentWidth: parent.width
        contentHeight: col.height + Theme.paddingLarge

        PullDownMenu {
            MenuItem {
                text: qsTr("Edit")
                onClicked: pageStack.push(Qt.resolvedUrl("EditNotePage.qml"))
            }
        }

        Column {
            id:col
            width: parent.width
            PageHeader {
                title: page.filePath
            }

            TextArea {
                //http://doc.qt.io/qt-5/qtextdocument.html#defaultStyleSheet-prop
                id: textArea
                width: parent.width
                //height: implicitHeight
                //textFormat: TextEdit.RichText
                readOnly: true
                wrapMode: TextEdit.Wrap
                Component.onCompleted: {
                    _editor.textFormat = TextEdit.RichText
                }
            }
        }
    }
    onStatusChanged: {
        if (status === PageStatus.Active) {
            console.log("page active")
            currentFile.read();
        }
    }
}
