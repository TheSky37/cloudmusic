import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    property alias fillMode:img.fillMode
    property string source: ""
    property double radius: 15
    Image {
        id: img
        anchors.fill: parent
        source:parent.source
        fillMode: Image.PreserveAspectCrop
    }
    OpacityMask{
        anchors.fill: parent
        source: img
        maskSource: mask
    }

    Rectangle{
        id:mask
        anchors.fill: parent
        visible: false
        radius:parent.radius
    }


}
