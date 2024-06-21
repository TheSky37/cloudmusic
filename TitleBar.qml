import QtQuick 2.15
import qc.window
import QtQuick.Controls
import QtQuick.Layouts

// 标题栏
Rectangle {
    z: 1
    id: titleBar
    width: parent.width
    height: 50
    color: "#c72e2e"

    DragHandler {
        id: dragHandler
        // target: titleBar

        onActiveChanged: {
            // 开始拖动时移动窗口
            if (dragHandler.active) {
                window.startSystemMove()
            }
        }

        onCentroidChanged: {
            // 如果正在拖动，则计算偏移并移动窗口
            if (dragHandler.active) {
                if (!window.startSystemMove()) {
                    var offset = Qt.point(dragHandler.centroid.position.x - titleBar.click_pos.x, dragHandler.centroid.position.y - titleBar.click_pos.y)
                    window.x += offset.x
                    window.y += offset.y
                }
            }
        }
    }


    RowLayout {
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        //标题和图标
        Row {
            width: 80
            height: 50
            spacing:15
            //图标
            Image {
                id: icon
                width: 40
                height: 32
                source: "qrc:/source/icon.png"
                anchors.verticalCenter: parent.verticalCenter
            }
            //标题
            Text {
                            id: title
                            font.pixelSize: 18
                            font.bold: true
                            font.family: "宋体"
                            color: "white"
                            text: qsTr("云音乐")
                            anchors.verticalCenter: parent.verticalCenter
            }
            Component.onCompleted: {
                width = children[0].width + children[1].contentWidth + spacing
            }
        }


        Item {
            Layout.preferredWidth: 10
            Layout.fillWidth: true
        }


        Row {
            width: 30*3 + 3
            spacing: 1
            //最小化按钮
            Rectangle {
                id: smallWindow
                width: 30
                height: width
                // radius: 100
                color: smallWindow.hovered ? "#a92727" : "#c72e2e"
                property bool hovered: false

                Rectangle{
                    width: 15
                    height:1.75
                    anchors.centerIn: parent
                    color: "#eec0c0"

                }



                HoverHandler{
                    onHoveredChanged: {
                        smallWindow.hovered = hovered
                    }
                }

                TapHandler{
                    // acceptedDevices: PointerDevice.Mouse
                    onTapped: {
                        window.showMinimized()
                    }
                }
            }


            //缩放窗口
            Rectangle {
                id: changeWindow
                width: 30
                height: width
                // radius: 100
                color: changeWindow.hovered ? "#a92727" : "#c72e2e"
                property bool hovered: false

                Rectangle{
                    width: 12
                    height:10
                    anchors.centerIn: parent
                    color: "#eec0c0"

                    Rectangle{
                        width: 10
                        height: 8
                        anchors.centerIn: parent
                        color: changeWindow.hovered ? "#a92727" : "#c72e2e"
                    }

                }

                TapHandler{
                    // acceptedDevices: PointerDevice.Mouse
                    onTapped: {
                        if(window.visibility === Window.Maximized){
                            window.showNormal()
                        }else {
                            window.showMaximized()
                        }
                    }
                }

                HoverHandler{
                    onHoveredChanged: changeWindow.hovered = hovered
                }
            }


            //关闭窗口
            Rectangle {
                id: closeWindow
                width: 30
                height: width
                // radius: 100
                color: closeWindow.hovered ? "#a92727" : "#c72e2e"
                property bool hovered: false

                Rectangle{
                    width: 13
                    height:1.5
                    anchors.centerIn: parent
                    rotation: 45                                              //旋转45度
                    color: "#eec0c0"

                }

                Rectangle{
                    width: 13
                    height:1.5
                    anchors.centerIn: parent
                    rotation: -45                                              //旋转-45度
                    color: "#eec0c0"

                }

                TapHandler{
                    // acceptedDevices: PointerDevice.Mouse
                    onTapped: {
                        Qt.quit()
                    }
                }

                HoverHandler{
                    onHoveredChanged: closeWindow.hovered = hovered
                }
            }
        }
    }
}
