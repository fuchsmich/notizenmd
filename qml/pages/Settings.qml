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
                    id: notePathTF
                    //x: Theme.horizontalPageMargin
                    width: parent.width - x - resetBtn.width
                    label: qsTr("Path to folder containing notes")
                    text: settings.notesLocation
                }
                IconButton {
                    anchors.verticalCenter: notePathTF.verticalCenter
                    id: resetBtn
                    icon.source: "image://theme/icon-m-reset"
                    onClicked: notePathTF.text = ""
                }
            }


            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Choose Folder")
                onClicked: pageStack.push(filePickerPage)
                width: Theme.buttonWidthLarge
            }

            Component {
                id: filePickerPage
                DirectoryPickerPage {
                    title: "Location of Notes"
                    homePath: "/"
                    onDirectoryPicked: {
                        settings.notesLocation = path
                    }
                    callerPage: page
                }
            }

            TextField {
                id: fileFilterTF
                //x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                label: qsTr("File filters separated by comma")
                text: settings.fileNameFilters
                onTextChanged: settings.fileNameFilters = text;
            }

            ComboBox {
                id: viewItemSelector
                width: parent.width
                currentIndex: settings.viewItemIndex
                //label:
                description: qsTr("Select WebView (md by marked.js) or TextArea (md by mistune.py) for viewing notes.")
                menu: ContextMenu {
                    MenuItem { text:"TextArea (mistune.py)"
                        onClicked: settings.viewItemIndex = 0 }
                    MenuItem { text:"WebView (marked.js)"
                        onClicked: settings.viewItemIndex = 1 }
                }
            }

            ComboBox {
                id: horAlignSelector
                width: parent.width
                currentIndex: values.indexOf(settings.horAlign)
                label: qsTr("Horizontal alignment in TextArea")
                property var values: [Text.AlignLeft, Text.AlignJustify, Text.AlignRight, Text.AlignHCenter]
                property var texts: [qsTr("Left"), qsTr("Justify"), qsTr("Right"), qsTr("Center")]

                menu: ContextMenu {
                    Repeater {
                        model: horAlignSelector.values
                        MenuItem { text: horAlignSelector.texts[model.index]
                            onClicked: settings.horAlign = horAlignSelector.values[model.index] }
                    }
                }
                onCurrentIndexChanged: console.log(currentIndex, currentItem)
            }
        }
    }
}
