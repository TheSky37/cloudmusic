import QtQuick 2.15
import qc.window 1.0
import QtQuick.Controls
import QtQuick.Layouts

FramelessWindow {
    id: window
    width: 1015
    height: 670
    minimumHeight: 670
    minimumWidth: 1015
    visible: true

    Column {
        anchors.fill: parent

        // 标题栏
        TitleBar {
            z: 1
            id: titleBar
            width: parent.width
            height: 50
            color: "#c72e2e"
        }


        // 侧边栏和中间组件
        Rectangle {
            id: content
            width: parent.width
            height: parent.height - titleBar.height - bottomBar.height

            Row {
                width: parent.width
                height: window.height - titleBar.height - bottomBar.height
                //左侧边栏
                LeftBar {
                    id: leftBar
                    width: 200
                    height: parent.height
                }

                //右内容栏
                Rectangle {
                    id: rightcontent
                    width: parent.width - leftBar.width
                    height: parent.height
                }

            }
        }

        // 底部栏
        BottomBar {
            id: bottomBar
            height: 50
            width: parent.width
        }
    }
}
