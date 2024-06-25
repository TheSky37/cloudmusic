import QtQuick
import QtQuick.Controls

Item {
    property string color: ""
    property string iconColor: ""
    property string hoverdColor: ""
    property string source: ""
    property bool isHoverd: false

    width: 30
    height: width
    hoverEnabled: true

    Rectangle {
        anchors.fill: parent
        radius: 100
        color: parent.isHoverd ? "#e8e9ec" : "#f5f5f7"
    }

    Image {
        width: parent.width * .7
        height: parent.height * .7
        anchors.centerIn: parent
        source: parent.source
        sourceSize: Qt.size(32, 32)
    }

    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
        onHoveredChanged: {
            parent.isHoverd = hovered
        }
    }

    TapHandler {
        onTapped: {
            console
            {

            }
        }
    }
}

