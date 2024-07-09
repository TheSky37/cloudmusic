<<<<<<< HEAD
import QtQuick
import Qt5Compat.GraphicalEffects
Item {
    property alias sourceSize: img.sourceSize
    property alias fillMode: img.fillMode
    property string source: ""
    property double radius: 10
    Image {
        id: img
        anchors.fill: parent
        visible: false
        source: parent.source
        fillMode: Image.PreserveAspectCrop
    }
    OpacityMask {
        anchors.fill: parent
        source: img
        maskSource: mask
    }

    Rectangle {
        id: mask
        anchors.fill: parent
        visible: false
        radius: parent.radius
    }
}
=======
import QtQuick
import Qt5Compat.GraphicalEffects
Item {
    property alias sourceSize: img.sourceSize
    property alias fillMode: img.fillMode
    property string source: ""
    property double radius: 10
    Image {
        id: img
        anchors.fill: parent
        visible: false
        source: parent.source
        fillMode: Image.PreserveAspectCrop
    }
    OpacityMask {
        anchors.fill: parent
        source: img
        maskSource: mask
    }
//使用 OpacityMask 组件将遮罩效果应用于图像。遮罩源为一个圆角矩形 Rectangle，实现图像的圆角效果
    Rectangle {
        id: mask
        anchors.fill: parent
        visible: false
        radius: parent.radius
    }
}//使用属性别名和父子组件属性绑定，外部可以方便地设置图像源路径 (source)、图像填充模式 (fillMode)、遮罩圆角半径 (radius) 等属性
>>>>>>> origin/main
