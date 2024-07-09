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
    }//使用ColorOverlay效果在图像上应用颜色覆盖。覆盖的颜色由color属性指定，颜色覆盖效果填充整个图像
}//允许动态更改颜色覆盖效果
