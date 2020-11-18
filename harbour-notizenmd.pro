TARGET = harbour-notizenmd


#Sailfish.WebView:
CONFIG += link_pkgconfig
PKGCONFIG += qt5embedwidget

CONFIG += sailfishapp

SOURCES += \
    src/harbour-notizenmd.cpp

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
    qml/components/MdWebView.qml \
    qml/components/MdGeckoView.qml \
    qml/pages/About.qml


SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

TRANSLATIONS += \
    translations/harbour-notizenmd-de.ts \
    translations/harbour-notizenmd-fr.ts

