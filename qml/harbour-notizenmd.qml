import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

import "pages"

ApplicationWindow
{
    id: app
    //initialPage: Component { FirstPage { } }
    initialPage: Component{
        NotesBrowser {
            homePath: settings.notesLocation
            title: qsTr("Notes")
            nameFilters: settings.fileNameFilters.split(",")
            Component.onCompleted: {
                console.log(nameFilters, typeof nameFilters, nameFilters.length)

            }
        }
    }

    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    ConfigurationGroup {
        id: settings
        path: "/apps/harbour-notizenmd/settings"
        property string notesLocation: StandardPaths.documents
        property string fileNameFilters: ["*.md", "*.txt"].join(",")
    }
}
