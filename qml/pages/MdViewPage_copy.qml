import QtQuick 2.0
import Sailfish.Silica 1.0
//import QtWebKit.experimental 1.0
import io.thp.pyotherside 1.4

Page {
    id: page

    allowedOrientations: Orientation.All
    property string filePath
    onFilePathChanged: loadFile(filePath)
    property string md: ""
    onMdChanged: py.call('mistune.markdown', [md], function(text){textArea.text = text})

    function loadFile() {
        if (!page.filePath) {
            webView.updateText("No file selected");
            return;
        }
        var req =  new XMLHttpRequest();
        req.open('GET', page.filePath);
        req.onreadystatechange = function(event) {
            if (req.readyState === XMLHttpRequest.DONE) {
                page.md = req.responseText;
            }
        }
        req.send()
    }

    SilicaFlickable {
        anchors.fill: parent        
        contentWidth: parent.width
        contentHeight: col.height + Theme.paddingLarge


        PullDownMenu {
            MenuItem {
                enabled: false
                text: qsTr("Edit")
                onClicked: pageStack.push(Qt.resolvedUrl("NoteEditPage.qml"), {
                                              filePath: page.filePath,
                                              text: webView.text
                                          })
            }
        }
        Column {
            id:col
            width: parent.width
            TextArea {
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

            Python {
                id: py
                Component.onCompleted: {
                    addImportPath(Qt.resolvedUrl('.'));
                    importModule('mistune', function() {});
                }
            }
        }
    }
}
