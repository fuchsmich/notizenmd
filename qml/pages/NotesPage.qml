import QtQuick 2.0
import Sailfish.Silica 1.0

DirectoryPage {
    id: directoryPage
    Component {
        id: pdmc
        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }
        }
    }

    title: "Notes"
    nameFilters: [ '*.md', '*.txt']
    homePath: settings.notesLocation
//    onSelectedContentPropertiesChanged: {
//        pageStack.push(Qt.resolvedUrl("pages/MdViewPage.qml"), {filePath: selectedContentProperties.filePath});
//    }
    Component.onCompleted: {
//        console.log(directoryPage.children.length)
//        for (var i=0; i < directoryPage.children.length; i++) {
//            console.log(directoryPage.children[i].toString())
//            if (directoryPage.children[i].toString().indexOf("SilicaListView") > -1) {
//                pdmc.createObject(directoryPage.children[i])
//            }
//        }

        //var pdm = pdmc.createObject(directoryPage.listView)
    }
}
