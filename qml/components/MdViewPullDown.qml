import QtQuick 2.0
import Sailfish.Silica 1.0

PullDownMenu {
    id: pullDown
    signal toggleHtmlClicked()
    signal switchViewModeClicked()
    signal editClicked()

    MenuItem {
        text: qsTr("View html")
        onClicked: toggleHtmlClicked()
    }
    MenuItem {
        text: qsTr("Switch to %1").arg("TextArea")
        onClicked: switchViewModeClicked()
    }
    MenuItem {
        text: qsTr("Edit")
        onClicked: pageStack.push(Qt.resolvedUrl("EditNotePage.qml"))
    }
}
