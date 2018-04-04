import QtQuick 2.0
import io.thp.pyotherside 1.4

Python {
    id: py
    Component.onCompleted: {
        addImportPath(Qt.resolvedUrl('../python'));
        importModule('mistune', function() {});
    }
}
