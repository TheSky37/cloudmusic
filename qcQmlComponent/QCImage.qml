import QtQuick
import Qt5Compat.GraphicalEffects

Image {
    id: img
    property string color: ""
    source: ""

    ColorOverlay {
        anchors.fill: parent
        source: img
        color: parent.color
    }
}
