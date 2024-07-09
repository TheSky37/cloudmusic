import QtQuick
import QtQuick.Controls

Item {
    id: qcVolumeBtn
    property string backgroundColor: "#FFFFFF"
    property string fontColor: "#FF" + thisTheme.subBackgroundColor
    property string sliderBackgroundColor: "#2F" + thisTheme.subBackgroundColor
    property string sliderColor: "#FF" + thisTheme.subBackgroundColor
    property string handleBorderColor: "#FF" + thisTheme.subBackgroundColor
    property string handleColor:  "WHITE"
    property string btnColor:  "#00000000"
    property string btnIconColor:  "#FF" + thisTheme.subBackgroundColor
    property string btnHoverdColor:  "#1F" + thisTheme.subBackgroundColor
    width: parent.height
    height: 170
    anchors.bottom: parent.bottom
    state: "normal"
    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: bottomBarVolumeSliderBackgournd
                height: 0
                opacity: 0
            }
        },
        State {
            name: "hoverd"
            PropertyChanges {
                target: bottomBarVolumeSliderBackgournd
                height: 120
                opacity: 1
            }
        }
    ]

    transitions: [
        Transition {
            from: "normal"
            to: "hoverd"
            NumberAnimation {
                target: bottomBarVolumeSliderBackgournd
                property: "height"
                duration: 300
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: bottomBarVolumeSliderBackgournd
                property: "opacity"
                duration: 300
                easing.type: Easing.InOutQuad
            }
        },
        Transition {
            from: "hoverd"
            to: "normal"
            NumberAnimation {
                target: bottomBarVolumeSliderBackgournd
                property: "height"
                duration: 300
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: bottomBarVolumeSliderBackgournd
                property: "opacity"
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }
    ]
//鼠标悬停时显示音量滑块，离开时隐藏
    HoverHandler {
        id: hoverHandler1
        cursorShape: Qt.PointingHandCursor
        onHoveredChanged: {
            if (!hoverHandler1.hovered) {
                state = "normal"
            }
        }
    }
//点击音量按钮可以在静音和恢复音量之间切换
    Rectangle {
        id: bottomBarVolumeSliderBackgournd
        width: parent.width
        height: parent.height - bottomBarVolumeBtn.height - 5
        anchors.bottom: bottomBarVolumeBtn.top
        anchors.bottomMargin: 5
        radius: 12
        color: qcVolumeBtn.backgroundColor
        Text {
            visible: bottomBarVolumeSlider.pressed
            anchors.bottom: bottomBarVolumeSlider.top
            anchors.bottomMargin: 1
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: bottomBar.fontSize - 1
            text:  parseInt(bottomBarVolumeSlider.value*100)
            color: qcVolumeBtn.fontColor
        }//根据状态切换高度和透明度，实现音量滑块的显示和隐藏

        Slider {
            id: bottomBarVolumeSlider
            width: 15
            height: parent.height - 35
            from: 0
            value: p_musicPlayer.volume
            to: 1.
            orientation: Qt.Vertical // 竖向布局
            anchors.centerIn: parent
            background: Rectangle {
                radius: 12
                color: qcVolumeBtn.sliderBackgroundColor
                Rectangle {
                    width: parent.width
                    height: (1- bottomBarVolumeSlider.visualPosition) * parent.height
                    anchors.bottom: parent.bottom
                    radius: 12
                    color: qcVolumeBtn.sliderColor
                }
            }
            handle: Rectangle {
                implicitWidth: 20
                implicitHeight: 20
                x: -((width - bottomBarVolumeSlider.width)/2)
                y: (bottomBarVolumeSlider.availableHeight - height) * bottomBarVolumeSlider.visualPosition
                radius: 100
                border.width: 1.5
                border.color: qcVolumeBtn.handleBorderColor
                color: bottomBarVolumeSlider.pressed ? qcVolumeBtn.handleBorderColor : qcVolumeBtn.handleColor
            }

            onMoved: {
                p_musicPlayer.lastVolume = p_musicPlayer.volume
                p_musicPlayer.volume = value
            }
        }

    }
//使用 Slider 控件调节音量，并实时更新播放器的音量
    QCToolTipButton {
        id: bottomBarVolumeBtn
        width: 35
        height: width
        anchors.bottom: parent.bottom
        source: "qrc:/Images/volume.svg"

        hoverdColor: qcVolumeBtn.btnHoverdColor
        color: qcVolumeBtn.btnColor
        iconColor: qcVolumeBtn.btnIconColor

        HoverHandler {
            id: hoverHandler
            cursorShape: Qt.PointingHandCursor
            onHoveredChanged: {
                if (hoverHandler.hovered) {
                    state = "hoverd"
                }
            }
        }

        TapHandler {
            id: tapHandler
            onTapped: {
                if(p_musicPlayer.volume !== 0) {
                    p_musicPlayer.volume = 0
                } else {
                    p_musicPlayer.volume = p_musicPlayer.lastVolume
                }
            }
        }
    }
}
