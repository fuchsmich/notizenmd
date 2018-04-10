# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-notizenmd

CONFIG += sailfishapp_qml

DISTFILES += qml/harbour-notizenmd.qml \
    qml/cover/CoverPage.qml \
    qml/html/* \
    qml/python/* \
    rpm/harbour-notizenmd.changes.in \
    rpm/harbour-notizenmd.changes.run.in \
    rpm/harbour-notizenmd.spec \
    rpm/harbour-notizenmd.yaml \
    translations/*.ts \
    harbour-notizenmd.desktop \
    qml/pages/DirectoryPickerPage.qml \
    qml/pages/NewNoteDialog.qml \
    qml/pages/NotesBrowser.qml \
    qml/pages/Settings.qml \
    qml/pages/EditNotePage.qml \
    qml/components/Mistune.qml \
    qml/pages/MdViewPage.qml \
    qml/components/MdTextArea.qml \
    qml/components/MdViewPullDown.qml \
    qml/components/MdWebView.qml


SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

TRANSLATIONS += translations/harbour-notizenmd-de.ts
