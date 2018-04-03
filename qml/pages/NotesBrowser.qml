import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Silica.private 1.0 as Private
import Nemo.FileManager 1.0
import Sailfish.FileManager 1.0
import Nemo.Notifications 1.0
import org.nemomobile.contentaction 1.0

Page {
    id: page

    property alias path: fileModel.path
    property string homePath
    property string title
    //property bool showFormat
    property Notification errorNotification
    property bool mounting
    property bool showNewFolder: true

    property alias sortBy: fileModel.sortBy
    property alias sortOrder: fileModel.sortOrder
    property alias caseSensitivity: fileModel.caseSensitivity
    property alias directorySort: fileModel.directorySort
    property alias nameFilters: fileModel.nameFilters

    signal formatClicked

    function refresh() {
        fileModel.refresh()
    }

    backNavigation: !FileEngine.busy

    Component.onCompleted: {
        if (!errorNotification) {
            errorNotification = errorNotificationComponent.createObject(page)
        }
    }

    FileModel {
        id: fileModel

        directorySort: FileModel.SortDirectoriesBeforeFiles

        path: homePath
        active: page.status === PageStatus.Active
        onError: {
            if (error == FileModel.ErrorReadNoPermissions) {
                //% "No permissions to access %1"
                errorNotification.show(qsTrId("filemanager-la-folder_no_permission_to_access").arg(fileName))

            }
        }
    }
    SilicaListView {
        id: fileList

        opacity: {
            if (FileEngine.busy) {
                return 0.6
            } else if (page.mounting) {
                return 0.0
            } else {
                return 1.0
            }
        }
        Behavior on opacity { FadeAnimator {} }

        anchors.fill: parent
        model: fileModel

        PullDownMenu {

//            MenuItem {
//                //% "Format"
//                text: qsTrId("filemanager-me-format")
//                visible: showFormat
//                onClicked: page.formatClicked()
//            }

            MenuItem {
                //% "Sort"
                text: qsTrId("filemanager-me-sort")
                visible: fileModel.count > 0
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("/usr/lib/qt5/qml/Sailfish/FileManager/SortingPage.qml"))
                    dialog.selected.connect(
                        function(sortBy, sortOrder, directorySort) {
                            if (sortBy !== fileModel.sortBy || sortOrder !== fileModel.sortOrder) {
                                fileModel.sortBy = sortBy
                                fileModel.sortOrder = sortOrder
                                fileModel.directorySort = directorySort

                                // Wait for the changes to take effect
                                // before popping the sorting page
                                fileModel.sortByChanged.connect(pop)
                                fileModel.sortOrderChanged.connect(pop)
                            } else {
                                PageStack.pop()
                            }
                        }
                    )
                }
                function pop() {
                    pageStack.pop()
                    fileModel.sortByChanged.disconnect(pop)
                    fileModel.sortOrderChanged.disconnect(pop)
                }
            }

            MenuItem {
                //% "Paste"
                text: qsTrId("filemanager-me-paste")
                visible: FileEngine.clipboardCount > 0
                onClicked: FileEngine.pasteFiles(page.path, true)
            }

            MenuItem {
                visible: homePath == path
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }

            MenuItem {
                //% "New folder"
                text: qsTrId("filemanager-me-new_folder")
                visible: page.showNewFolder
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("/usr/lib/qt5/qml/Sailfish/FileManager/NewFolderDialog.qml"), { path: page.path })
                }
            }

            MenuItem {
                //visible: false
                text: qsTr("New Note")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("NewNoteDialog.qml"), { path: page.path })
                }
            }
        }

        header: PageHeader {
//            title: path == homePath && page.title.length > 0 ? page.title
//                                                             : page.path.split("/").pop()
            title: page.title
            description: path
        }

        delegate: ListItem {
            id: fileItem

            function remove() {
                //% "Deleting"
                remorseAction(qsTrId("filemanager-la-deleting"), function() { FileEngine.deleteFiles(fileModel.fileNameAt(model.index), true) })
            }

            width: ListView.view.width
            contentHeight: Theme.itemSizeMedium
            Row {
                anchors.fill: parent
                spacing: Theme.paddingLarge
                Rectangle {
                    width: height
                    height: parent.height
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Theme.rgba(Theme.primaryColor, 0.1) }
                        GradientStop { position: 1.0; color: "transparent" }
                    }

                    Image {
                        anchors.centerIn: parent
                        source: {
                            var iconSource = model.isDir ? "image://theme/icon-m-file-folder"
                                                         : "image://theme/icon-m-file-note" //Theme.iconForMimeType(model.mimeType)
                            return iconSource + (highlighted ? "?" + Theme.highlightColor : "")
                        }
                    }
                }
                Column {
                    width: parent.width - parent.height - parent.spacing - Theme.horizontalPageMargin
                    anchors.verticalCenter: parent.verticalCenter
                    Label {
                        text: model.fileName
                        width: parent.width
                        truncationMode: TruncationMode.Fade
                        color: highlighted ? Theme.highlightColor : Theme.primaryColor
                    }
                    Label {
                        property string dateString: Format.formatDate(model.modified, Formatter.DateLong)
                        text: model.isDir ? dateString
                                            //: Shows size and modification date, e.g. "15.5MB, 02/03/2016"
                                            //% "%1, %2"
                                          : qsTrId("filemanager-la-file_details").arg(Format.formatFileSize(model.size)).arg(dateString)
                        width: parent.width
                        truncationMode: TruncationMode.Fade
                        font.pixelSize: Theme.fontSizeExtraSmall
                        color: highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    }
                }
            }
            menu: contextMenu

            ListView.onRemove: if (page.status === PageStatus.Active) animateRemoval(fileItem)
            onClicked: {
                if (model.isDir) {
                    pageStack.push(Qt.resolvedUrl("NotesBrowser.qml"), {
                        path: fileModel.appendPath(model.fileName),
                        homePath: page.homePath,
                        title: model.fileName,
                        errorNotification: page.errorNotification,
                        sortBy: page.sortBy,
                        sortOrder: page.sortOrder,
                        caseSensitivity: page.caseSensitivity,
                        directorySort: page.directorySort,
                        nameFilters: page.nameFilters
                    })
                } else {
                    var filePath = fileModel.path + "/" + model.fileName
                    var pageFile = settings.viewItemIndex == 0 ?
                                "MdViewTextAreaPage.qml":
                                "MdWebViewPage.qml"
                    currentFile.path = filePath
                    pageStack.push(Qt.resolvedUrl(pageFile))
                }
            }

            Component {
                id: contextMenu
                ContextMenu {
                    MenuItem {
                        //% "Copy"
                        text: qsTrId("filemanager-me-copy")
                        onClicked: FileEngine.copyFiles([ fileModel.fileNameAt(model.index) ])
                    }
                    MenuItem {
                        //% "Delete"
                        text: qsTrId("filemanager-me-delete")
                        onClicked: remove()
                    }
                }
            }
        }
        ViewPlaceholder {
            enabled: fileModel.count === 0
            //% "No files"
            text: qsTrId("filemanager-la-no_files")
        }
        VerticalScrollDecorator {}
    }
    Component {
        id: errorNotificationComponent
        Notification {
            property bool alreadyPublished
            category: "x-jolla.storage.error"
            function show(errorText) {
                previewSummary = errorText
                if (alreadyPublished) {
                    // Make sure new banner is shown, call close() to avoid server treating
                    // subsequent publish() calls as updates to the existing notification
                    close()
                }

                publish()
                alreadyPublished = true
            }
            property var connections: Connections {
                target: FileEngine
                onError: {
                    switch (error) {
                    case FileEngine.ErrorOperationInProgress:
                        //% "File operation already in progress"
                        show(qsTrId("filemanager-la-operation_already_in_progress"))
                        break
                    case FileEngine.ErrorCopyFailed:
                        //% "Copying failed"
                        show(qsTrId("filemanager-la-copy_failed"))
                        break
                    case FileEngine.ErrorDeleteFailed:
                        //% "Deletion failed"
                        show(qsTrId("filemanager-la-deletion_failed"))
                        break
                    case FileEngine.ErrorMoveFailed:
                        //% "Moving failed"
                        show(qsTrId("filemanager-la-moving_failed"))
                        break
                    case FileEngine.ErrorRenameFailed:
                        //% "Renaming failed"
                        show(qsTrId("filemanager-la-renaming_failed"))
                        break
                    case FileEngine.ErrorCannotCopyIntoItself:
                        //% "You cannot copy a folder into itself"
                        show(qsTrId("filemanager-la-cannot_copy_folder_into_itself"))
                        break
                    case FileEngine.ErrorFolderCopyFailed:
                        //% "Copying folder failed"
                        show(qsTrId("filemanager-la-copying_folder_failed"))
                        break
                    case FileEngine.ErrorFolderCreationFailed:
                        //% "Could not create folder"
                        show(qsTrId("filemanager-la-folder_creation_failed"))
                        break
                    case FileEngine.ErrorChmodFailed:
                        //% "Could not set permission"
                        show(qsTrId("filemanager-la-set_permissions_failed"))
                        break
                    }
                }
            }
            property var busyView: Loader {
                parent: __silica_applicationwindow_instance
                active: FileEngine.busy || page.mounting
                onActiveChanged: active = true // remove binding
                anchors.fill: parent

                sourceComponent: Item {
                    id: busyView

                    enabled: FileEngine.busy || page.mounting
                    opacity: enabled ? 1.0 : 0.0
                    Behavior on opacity { FadeAnimator { duration: 400 } }                    anchors.fill: parent

                    onEnabledChanged: {
                        if (enabled) {
                            busyRectangle.visible = FileEngine.busy
                        }
                    }

                    Rectangle {
                        id: busyRectangle

                        color: Theme.rgba("black",  0.9)

                        anchors.fill: parent

                        TouchBlocker {
                            anchors.fill: parent
                        }
                    }

                    Column {
                        id: busyIndicator
                        anchors.centerIn: parent
                        spacing: Theme.paddingLarge
                        InfoLabel {
                            text: {
                                if (page.mounting) {
                                    //% "Mounting SD card"
                                    return qsTrId("filemanager-la-mounting")
                                } else switch (FileEngine.mode) {
                                case FileEngine.DeleteMode:
                                    //% "Deleting"
                                  return qsTrId("filemanager-la-deleting")
                                case FileEngine.CopyMode:
                                    //% "Copying"
                                    return qsTrId("filemanager-la-copying")
                                default:
                                    return ""
                                }
                            }
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        BusyIndicator {
                            anchors.horizontalCenter: parent.horizontalCenter
                            size: BusyIndicatorSize.Large
                            running: busyView.enabled
                        }
                    }
                }
            }
        }
    }

    Private.WindowGestureOverride {
        active: FileEngine.busy
    }
}
