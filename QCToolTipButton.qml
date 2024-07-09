import QtQuick

Item {
    property string color: ""
    property string iconColor: ""
    property string hoverdColor: ""
    property string source: ""
    property bool isHoverd: false
    width: 30
    height: width

    Rectangle {
        anchors.fill: parent
        radius: 100
        color: if(parent.isHoverd) return hoverdColor
        else return parent.color
    }//用于绘制按钮的背景，具有圆角效果，并根据是否悬停改变颜色。
    QImage {
        width: parent.width * .5
        height: width
        anchors.centerIn: parent
        source: parent.source
        sourceSize: Qt.size(32,32)
        color: parent.iconColor
    }
//用于显示图标，并根据传入的颜色属性设置图标颜色。
    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
        onHoveredChanged: {
            isHoverd = hoverHandler.hovered
        }
    }//用于检测鼠标悬停事件，改变按钮的背景颜色。
}



