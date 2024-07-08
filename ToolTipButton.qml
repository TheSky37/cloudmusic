import QtQuick

Item {
    property string color: ""
    property string hoverdColor: ""
    property string source: ""
    property bool isHovered: false
    property string iconColor: ""

    width: 30
    height: width

    Rectangle {
        anchors.fill: parent
        radius: 100
        color: if(parent.isHovered) return hoverdColor
        else return parent.color
    }

    QImage {
        width: parent.width * .65
        height: width
        anchors.fill: parent
        source: parent.source
        sourceSize: Qt.size(32, 32)
        color: parent.iconColor
    }

    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
        onHoveredChanged: {
            parent.isHovered = hovered
            console("222")
        }
    }

    TapHandler {
        onTapped: {
            console("111")
        }
    }
}

