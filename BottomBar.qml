import QtQuick
import QtQuick.Controls

Rectangle {
    id: bottomBar
    property double fontSize: 11
    height: 50
    anchors.bottom: window.bottom
    width: parent.width
    color: "#f6f6f8"

    Item {
        width: parent.width - 15
        height: parent.height -20
        anchors.centerIn: parent

        //左侧布局 ：音乐图标和歌名歌手名
        Row{
            width: parent.width*3
            height: parent.height
            anchors.left: parent.left
            spacing: 10
            RoundImage{
                id: musicImg
                width: parent.height
                height: width
                source: "qrc:/source/musicIcon.jpg"
            }
            Column{
                width: parent.width - musicImg.width - spacing
                anchors.verticalCenter: parent.verticalCenter
                Text{
                    font.pointSize: bottomBar.fontSize
                    text: "歌名"
                    color: "black"
                }
                Text{
                    font.pointSize: bottomBar.fontSize
                    text: "歌手"
                    color: "black"
                }
            }
        }

        Row{
            anchors.centerIn: parent
            width: parent.width*3
            // height: parent.height
            ToolTipButton {
                width: 35
                height: width
                source: "qrc:/source/loop1.png"
                hoverdColor: "#242D41"
                color: "#9196A1"
            }

        }
    }
}

