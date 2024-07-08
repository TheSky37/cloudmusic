import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    property alias fillMode:img.fillMode
    property string source: ""
    property double radius: 10
    Image {
        id: img
        anchors.fill: parent
        source:parent.source
        fillMode: Image.PreserveAspectCrop
    }

    //创建模板
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
