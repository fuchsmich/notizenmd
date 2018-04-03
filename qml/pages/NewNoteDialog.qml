import QtQuick 2.0
import Sailfish.Silica 1.0
//import Nemo.FileManager 1.0
import "../components"

Dialog {
    id: dialog

    property string path
    canAccept: fileName.text.length > 0
    onAccepted: {
        file.path = path + "/" + fileName.text;
        file.create();
//        if (!FileEngine.mkdir(path, fileName.text, true)) {
            //% "Cannot create folder %1"
//            errorNotification.show(qsTrId("filemanager-la-cannot_create_folder").arg(fileName.text))
//        }
    }

    FileIO {
        id: file
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
                //% "New folder"
                placeholderText: qsTrId("New note")
                label: placeholderText
                focus: true

                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-accept"
                EnterKey.onClicked: dialog.accept()
            }
        }
        VerticalScrollDecorator {}
    }
}
