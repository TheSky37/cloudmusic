import QtQuick
import QtQuick.Controls

Rectangle {
    id: bottomBar
    property double fontSize: 11
    height: 80
    anchors.bottom: window.bottom
    width: parent.width
    color: "#f6f6f8"

    Item {
        //设置大小边距
        width: parent.width - 15
        height: parent.height -20
        anchors.centerIn: parent

        //左侧布局 ：歌曲封面和歌名歌手名
        Row{

            width: parent.width* .3
            height: parent.height
            spacing: 10
            anchors.left: parent.left
            //添加歌曲封面
            RoundImage{
                id: musicImg
                width: parent.height
                height: width
                source: "qrc:/source/musicIcon.jpg"
            }
            Column{
                width: parent.width - musicImg.width - parent.spacing
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
            height: parent.height
            spacing: 5
            ToolTipButton {
                width: 35
                height: width
                source: "qrc:/source/loop1.png"
                hoverdColor: "red"
                color: "#00000000"/*"#9196A1"*/
                iconColor: "red"
            }
            ToolTipButton {
                width: 35
                height: width
                source: "qrc:/source/Previous.png"
                hoverdColor: "red"
                color: "#00000000"/*"#9196A1"*/
                iconColor: "red"
            }
            ToolTipButton {
                width: 35
                height: width
                source: "qrc:/source/play.png"
                hoverdColor: "red"
                color: "#00000000"/*"#9196A1"*/
                iconColor: "red"
            }
            ToolTipButton {
                width: 35
                height: width
                source: "qrc:/source/Previous.png"
                transformOrigin: Item.Center
                rotation: -180
                hoverdColor: "red"
                color: "#00000000"/*"#9196A1"*/
                iconColor: "red"
            }
        }
    }
}

