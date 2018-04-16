import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: ta.height
        Column {
            width: parent.width
            PageHeader {
                title: qsTr("About %1").arg("Notizen.md")
            }
            SectionHeader { text: qsTr("Author") }
            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2*Theme.horizontalPageMargin
                wrapMode: Text.Wrap
                text: "Michael Fuchs <michfu@gmx.at>"
            }
            SectionHeader { text: qsTr("Source") }
            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2*Theme.horizontalPageMargin
                wrapMode: Text.Wrap
                text: "https://github.com/fuchsmich/notizenmd"
            }
            SectionHeader { text: qsTr("Other Projects") }
            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2*Theme.horizontalPageMargin
                wrapMode: Text.Wrap
                text: 'Markdown rendering by '+
                      '<a href="https://github.com/markedjs/marked">marked.js</a> and ' +
                      '<a href="https://github.com/lepture/mistune">mistune.py</a>.'
                onLinkActivated: {
                    console.log("opening " + link)
                    Qt.openUrlExternally(link)
                }
            }
        }
    }
}
