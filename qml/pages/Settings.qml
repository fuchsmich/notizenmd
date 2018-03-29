import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height + Theme.paddingLarge

        VerticalScrollDecorator {}

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
        }

        Column {
            id: col
            spacing: Theme.paddingMedium
            width: parent.width
            PageHeader {
                title: qsTr("Settings")
            }
            SectionHeader {
                text: qsTr("Files")
            }
            Row {
                width: parent.width

                TextField {
                    id: notesPath
                    //x: Theme.horizontalPageMargin
                    width: parent.width - x - resetBtn.width
                    label: qsTr("Path to notes")
                    text: settings.notesLocation
                }
                IconButton {
                    anchors.verticalCenter: notesPath.verticalCenter
                    id: resetBtn
                    icon.source: "image://theme/icon-m-reset"
                    onClicked: notesPath.text = ""
                }
            }


            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Choose File")
                onClicked: pageStack.push(filePickerPage)
                width: Theme.buttonWidthLarge
            }

            Component {
                id: filePickerPage
                DirectoryPickerPage {
                    title: "Location of Notes"
                    homePath: StandardPaths.home
                    onDirectoryPicked: {
                        settings.notesLocation = path
                    }
                    callerPage: page
                }
            }
        }
    }
}
