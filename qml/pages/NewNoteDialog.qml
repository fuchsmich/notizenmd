import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: dialog

    property string path
    canAccept: fileName.text.length > 0
    onAccepted: {
        currentFile.path = path + "/" + fileName.text + (settings.addExtensionOnCreate ? ".md": "");
        currentFile.create();
        if (settings.editNoteOnCreate) pageStack.replace(Qt.resolvedUrl("EditNotePage.qml"));
    }

    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width

            DialogHeader {
                //% "Create"
                acceptText: qsTrId("filemanager-he-create")
            }
            TextField {
                id: fileName
                width: parent.width
                placeholderText: qsTr("New note")
                label: placeholderText
                focus: true

                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-accept"
                EnterKey.onClicked: dialog.accept()
            }
            TextSwitch {
                text: qsTr("Auto-add extension (.md)")
                checked: settings.addExtensionOnCreate
                onClicked: settings.addExtensionOnCreate = checked
            }
            TextSwitch {
                text: qsTr("Edit note after creation.")
                checked: settings.editNoteOnCreate
                onClicked: settings.editNoteOnCreate = checked
            }
        }
        VerticalScrollDecorator {}
    }
}
