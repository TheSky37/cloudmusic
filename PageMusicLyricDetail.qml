import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import qc.window

Item {
    id: musicLyricPage
    width: parent.width
    height: parent.height
    Component.onCompleted: {
        y = parent.height
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#2B3560"
    }


    Item {
        id: content
        width: musicLyricPage.width
        height: musicLyricPage.height - header.height - footer.height
        anchors.top: header.bottom
        Row {
            width: parent.width - 30
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20
            Item { // 左侧内容,包含音乐封面和文字信息的容器
                id: musicInfoItem
                property string fontGlowColor: "#AFFFFFFF"
                property string fontColor: "#AFFFFFFF"
                property double fontSize: 17
                width: parent.width / 2 - parent.spacing
                height: parent.height
                Column {
                    width: parent.width * .7
                    anchors.centerIn: parent
                    spacing: 20
                    Item { // 封面
                        width: parent.width * .7
                        height: width
                        RoundImage {
                            id: coverImg
                            width: parent.width
                            height: width
                            source: p_musicRes.thisPlayMusicInfo.coverImg
                            sourceSize: Qt.size(400,400)
                        }
                        FastBlur {  //FastBlur: 封面图片的模糊效果
                            z: coverImg.z - 1
                            anchors.fill: coverImg
                            source: coverImg
                            radius: 80
                            transparentBorder: true
                        }
                    }

                    Column {

                        width: parent.width
                        spacing: 15
                        Text { // 歌名文本
                            id: nameText
                            width: parent.width
                            height: contentHeight
                            wrapMode: Text.Wrap
                            font.pointSize: musicInfoItem.fontSize + 10
                            text: p_musicRes.thisPlayMusicInfo.name
                            color: musicInfoItem.fontColor
                            layer.enabled: true
                            layer.effect: Glow {
                                anchors.fill: nameText
                                source: nameText
                                samples: radius*2+1
                                radius: 12
                                spread: .1
                                color: musicInfoItem.fontGlowColor
                            }
                        }
                        Text { // 歌手文本
                            id: artistText
                            width: parent.width
                            height: contentHeight
                            wrapMode: Text.Wrap
                            font.pointSize: musicInfoItem.fontSize
                            text: p_musicRes.thisPlayMusicInfo.artists
                            color: musicInfoItem.fontColor
                            layer.enabled: true
                            layer.effect: Glow {
                                anchors.fill: artistText
                                source: artistText
                                samples: radius*2+1
                                radius: 12
                                spread: .1
                                color: musicInfoItem.fontGlowColor
                            }
                        }
                        Text { // 专辑文本
                            id: albumText
                            width: parent.width
                            height: contentHeight
                            wrapMode: Text.Wrap
                            font.pointSize: musicInfoItem.fontSize
                            text: p_musicRes.thisPlayMusicInfo.album
                            color: musicInfoItem.fontColor
                            layer.enabled: true
                            layer.effect: Glow {
                                anchors.fill: albumText
                                source: albumText
                                samples: radius*2+1
                                radius: 12
                                spread: .1
                                color: musicInfoItem.fontGlowColor
                            }
                        }
                    }
                }

            }

            Item { // 右侧内容
                width: parent.width / 2 - parent.spacing
                height: parent.height
                QCLyricListView {  //使用自定义歌词内容
                    id: lyricListView
                    width: parent.width
                    height: parent.height
                    lyricData: p_musicRes.thisPlayMusicLyric
                    mediaPlayer: p_musicPlayer
                }
            }
        }
    }


    MouseArea {
        id: header
        property var click_pos: Qt.point(0,0)
        width: musicLyricPage.width
        height: 60
        onPositionChanged: function (mouse) {
            if(!pressed || window.mouse_pos !== FramelessWindow.NORMAL) return

            if(!window.startSystemMove()) { // 启用系统自带的拖拽功能
                var offset = Qt.point(mouseX - click_pos.x,mouseY - click_pos.y)
                window.x += offset.x
                window.y += offset.y
            }
        }
        onPressedChanged: function (mouse) {
            click_pos = Qt.point(mouseX,mouseY)
        }
        onDoubleClicked: {
            if(window.visibility === Window.Maximized) {
                window.showNormal()
            } else {
                window.showMaximized()
            }
        }

        Item {
            width: parent.width - 30
            height: parent.height - 30
            anchors.centerIn: parent
            Row {
                width: 35*4 + 5*4
                spacing: 5
                QCToolTipButton {
                    width: 35
                    height: width
                    source: "qrc:/Images/dropDown.svg"
                    color: "#00000000"
                    hoverdColor: "#2FFFFFFF"
                    iconColor: "#FFFFFF"
                    TapHandler{
                        onTapped: {
                            musicLyricPage.parent.hidePage()
                        }
                    }
                }
                Rectangle {
                    id: minWindowBtn
                    anchors.fill: parent
                    property bool isHoverd: false
                    width: 35
                    height: width
                    radius: 100
                    color: if(isHoverd) return "#2FFFFFFF"
                           else return "#00000000"
                    Rectangle {
                        width: parent.width-15
                        height: 2
                        anchors.centerIn: parent
                        color: "#FFFFFF"
                    }

                    TapHandler {
                        onTapped: {
                            window.showMinimized()
                        }
                    }

                    HoverHandler {
                        id: hoverHandler

                        onHoveredChanged: {
                            parent.isHoverd = hoverHandler.hovered
                        }
                    }
                }
                Rectangle {
                    id: minMaxWindowBtn
                    property bool isHoverd: false
                    width: 35
                    height: width
                    radius: 100
                    color: if(isHoverd) return "#2FFFFFFF"
                           else return "#00000000"
                    Rectangle {
                        width: parent.width-15
                        height: width
                        anchors.centerIn: parent
                        radius: 100
                        color: "#00000000"
                        border.width: 2
                        border.color: "#FFFFFF"
                    }

                    TapHandler {
                        id: tapHandler
                        onTapped: {
                            if(window.visibility === Window.Maximized) {
                                window.showNormal()
                            } else {
                                window.showMaximized()
                            }
                        }
                    }

                    HoverHandler {
                        id: hoverHandler2

                        onHoveredChanged: {
                            parent.isHoverd = hoverHandler2.hovered
                        }
                    }
                }
                Rectangle {
                    id: quitWindowBtn
                    property bool isHoverd: false
                    width: 35
                    height: width
                    radius: 100
                    color: if(isHoverd) return "#2FFFFFFF"
                           else return "#00000000"
                    Rectangle {
                        width: parent.width-15
                        height: 2.5
                        border.color: "#FFFFFF"
                        anchors.centerIn: parent
                        rotation: 45
                        color: "#FFFFFF"
                    }
                    Rectangle {
                        width: parent.width-15
                        height: 2.5
                        border.color: "#FFFFFF"
                        anchors.centerIn: parent
                        rotation: -45
                        color: "#FFFFFF"
                    }

                    TapHandler {
                        onTapped: {
                            Qt.quit()
                        }
                    }

                    HoverHandler {
                        id: hoverHandler3

                        onHoveredChanged: {
                            parent.isHoverd = hoverHandler3.hovered
                        }
                    }
                }
            }

        }


    }


    QCThisPlayerListLabel {  //播放列表标签，控制播放列表的显示和隐藏
        id: qcThisPlayerListLabel
        visible: false
        anchors.bottom: footer.top
        anchors.right: footer.right
        backgroundColor: "#2F000000"
        fontColor: "#CFFFFFFF"
        activeFontColor: "#FFFFFFFF"
        contentItemColor: "#2FFFFFFF"
        contentItemHoverdColor: "#2FFFFFFF"
    }

    Item {
        id: footer
        width: musicLyricPage.width
        height: 80
        anchors.top: content.bottom
        Item {
            width: parent.width - 30
            height: parent.height - 15
            anchors.centerIn: parent
            Column {
                id: footerContent
                width: 350
                spacing: 5
                anchors.centerIn: parent
                Row {
                    height: 35
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 10
                    QCToolTipButton {
                        id: playerModeIcon
                        width: 35
                        height: width
                        source: "qrc:/Images/loopPlay.svg"
                        hoverdColor: "#2F000000"
                        color: "#00000000"
                        iconColor: "#FFFFFF"

                        TapHandler{
                            cursorShape: Qt.PointingHandCursor
                            onTapped: {
                                p_musicPlayer.setPlayMode()
                            }
                        }



                        Connections {
                            target: p_musicPlayer
                            function onPlayerModeStatusChanged() {
                                switch(p_musicPlayer.playerModeStatus) {
                                case QCMusicPlayer.PlayerMode.ONELOOPPLAY:
                                    playerModeIcon.source = "qrc:/Images/repeatSinglePlay.svg"
                                    break
                                case QCMusicPlayer.PlayerMode.LOOPPLAY:
                                    playerModeIcon.source = "qrc:/Images/loopPlay.svg"
                                    break
                                case QCMusicPlayer.PlayerMode.RANDOMPLAY:
                                    playerModeIcon.source = "qrc:/Images/randomPlay.svg"
                                    break
                                case QCMusicPlayer.PlayerMode.PLAYLISTPLAY:
                                    playerModeIcon.source = "qrc:/Images/playList.svg"
                                    break
                                }
                            }
                        }
                    }
                    QCToolTipButton {
                        width: 35
                        height: width
                        source: "qrc:/Images/prePlayer.svg"
                        hoverdColor: "#2F000000"
                        color: "#00000000"
                        iconColor: "#FFFFFF"
                        TapHandler{
                            cursorShape: Qt.PointingHandCursor
                            onTapped: {
                                p_musicPlayer.preMusicPlay()
                            }
                        }
                    }
                    QCToolTipButton {
                        width: 35
                        height: width
                        source: if(p_musicPlayer.playbackState === 1) return "qrc:/Images/stop.svg"
                        else return "qrc:/Images/player.svg"
                        hoverdColor: "#2F000000"
                        color: "#2F000000"
                        iconColor: "WHITE"
                        TapHandler{
                            cursorShape: Qt.PointingHandCursor
                            onTapped: {
                                p_musicPlayer.playPauseMusic()
                            }
                        }

                        HoverHandler{
                            cursorShape: Qt.PointingHandCursor
                            onHoveredChanged: {
                                if(hovered){
                                    scale = 1.1
                                }else{
                                    scale = 1
                                }
                            }
                        }


                        Behavior on scale {
                            ScaleAnimator {
                                duration: 200
                                easing.type: Easing.InOutQuart
                            }
                        }
                    }
                    QCToolTipButton {
                        width: 35
                        height: width
                        source: "qrc:/Images/prePlayer.svg"
                        transformOrigin: Item.Center
                        rotation: -180
                        hoverdColor: "#2F000000"
                        color: "#00000000"
                        iconColor: "#FFFFFF"

                        TapHandler{
                            cursorShape: Qt.PointingHandCursor
                            onTapped: {
                                p_musicPlayer.nextMusicPlay()
                            }
                        }
                    }

                    Component.onCompleted: {
                        var w = 0
                        for(var i = 0; i < children.length;i++) {
                            w += children[i].width
                        }
                        w = w + children.length * spacing-spacing
                        width = w
                    }

                }
                Row {
                    width: parent.width
                    height: children[0].height
                    spacing: 5
                    Text {
                        font.pointSize: 10
                        width: contentWidth
                        height: contentHeight
                        text: p_musicRes.setTime(bottomBarSlider.value)
                        color: "WHITE"
                    }
                    Slider {
                        id: bottomBarSlider
                        property bool movePressed: false
                        width: parent.width - parent.children[0].width*2 - parent.padding*2
                        height: 5
                        anchors.verticalCenter: parent.verticalCenter
                        from: 0
                        to: p_musicPlayer.duration
                        background: Rectangle {
                            color: "#2F000000"
                            Rectangle {
                                width: bottomBarSlider.visualPosition * parent.width
                                height: parent.height
                                color: "#FF000000"
                            }
                        }
                        handle: Rectangle {
                            implicitWidth: 10
                            implicitHeight: 10
                            x: (bottomBarSlider.availableWidth - width) * bottomBarSlider.visualPosition
                            y: -((height - bottomBarSlider.height)/2)
                            radius: 100
                            border.width: 1.5
                            border.color: "#FFFFFF"
                            color: bottomBarSlider.pressed ? "#FFFFFF" : "#FF000000"
                        }

                        onMoved: {
                            movePressed = true
                        }
                        onPressedChanged: {
                            if(movePressed === true && pressed === false) { // 松手
                                movePressed = pressed
                                p_musicPlayer.position = value
                            }
                        }
                        Connections {
                            target: p_musicPlayer
                            enabled: bottomBarSlider.pressed === false
                            function onPositionChanged() {
                                bottomBarSlider.value = p_musicPlayer.position
                            }
                        }
                    }
                    Text {
                        font.pointSize: 10
                        width: contentWidth
                        height: contentHeight
                        text: p_musicRes.thisPlayMusicInfo.allTime
                        color: "WHITE"
                    }
                }
            }
            Row {
                id: footerRight
                height: 35
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                QCVolumeBtn {

                    backgroundColor: "#2F000000"
                    fontColor: "#FFFFFFFF"
                    sliderBackgroundColor: "#7F000000"
                    sliderColor: "#FF000000"
                    handleBorderColor: "WHITE"
                    handleColor:  "#FF000000"
                    btnColor:  "#00000000"
                    btnIconColor:  "WHITE"
                    btnHoverdColor:  "#2F000000"
                }

                QCToolTipButton {
                    width: 35
                    height: width
                    source: "qrc:/Images/playList.svg"
                    hoverdColor: "#2F000000"
                    color: "#00000000"
                    iconColor: "WHITE"

                    TapHandler{
                        cursorShape: Qt.PointingHandCursor
                        onTapped: {
                            qcThisPlayerListLabel.visible = !qcThisPlayerListLabel.visible
                        }
                    }
                }
            }



        }


    }
}
