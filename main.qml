import QtQuick
import qc.window

FramelessWindow {
    id: window
    width: 1000
    height: 618
    minimumHeight: 618
    minimumWidth: 1000
    visible: true
    title: qsTr("hello world")

    Rectangle {
        id: titleBar
        width: parent.width
        height: 70
        color: "red"

        property var click_pos: Qt.point(0, 0)

        anchors.top: parent.top
        anchors.left: parent.left



        DragHandler {
            id: dragHandler
            target: titleBar
            onActiveChanged: {
                // 如果拖动开始，记录点击位置
                if (dragHandler.active) {
                    titleBar.click_pos = Qt.point(dragHandler.centroid.position.x, dragHandler.centroid.position.y)
                }
            }
            onCentroidChanged: {
                // 如果正在拖动，则计算偏移并移动窗口
                if (dragHandler.active) {

                    if(!window.startSystemMove())
                    {
                        var offset = Qt.point(dragHandler.centroid.position.x - titleBar.click_pos.x, dragHandler.centroid.position.y - titleBar.click_pos.y)
                        // console.log(offset)
                        window.x += offset.x
                        window.y += offset.y
                    }
                }
            }
        }
    }
    Component.onCompleted:
    {
        console.log(window.x)
    }
}
