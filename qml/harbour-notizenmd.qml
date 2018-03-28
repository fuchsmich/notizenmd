import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0

import "pages"

ApplicationWindow
{
    id: app
    //initialPage: Component { FirstPage { } }
    initialPage: filePickerPage

    Component {
        id: filePickerPage
        FilePickerPage {
            title: "Notes"
            nameFilters: [ '*.md', '*.txt']
            onSelectedContentPropertiesChanged: {
                pageStack.push(Qt.resolvedUrl("pages/MdViewPage.qml"), {filePath: selectedContentProperties.filePath});
            }
        }
    }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    signal webViewRunJavaScript(string script, var callback)
}
