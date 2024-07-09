import QtQuick
import QtQuick.Controls
import "./qcQmlComponent"

Rectangle {
    id: bottomBar

    property var thisTheme: p_theme.defaultTheme[p_theme.current]
    property double fontSize: 11
    width: parent.width
    height: 80
    color: thisTheme.backgroundColor
    QCThisPlayerListLabel {
        id: qcThisPlayerListLabel
        visible: false
        anchors.bottom: parent.top
        anchors.right: parent.right
        backgroundColor: "#FAF2F1"
        fontColor: thisTheme.fontColor
        activeFontColor: "#FF" + thisTheme.subBackgroundColor
        contentItemColor: "#1F" + thisTheme.subBackgroundColor
    }
//用于显示播放列表的组件，当点击播放列表按钮时显示。
    Slider {
        id: bottomBarSlider
        property bool movePressed: false
        width: parent.width
        height: 5
        from: 0
        to: p_musicPlayer.duration
        anchors.bottom: parent.top
        background: Rectangle {
            color: "#1F" + thisTheme.subBackgroundColor
            Rectangle {
                width: bottomBarSlider.visualPosition * parent.width
                height: parent.height
                color: "#FF" + thisTheme.subBackgroundColor
            }
        }
        handle: Rectangle {
            implicitWidth: 20
            implicitHeight: 20
            x: (bottomBarSlider.availableWidth - width) * bottomBarSlider.visualPosition
            y: -((height - bottomBarSlider.height)/2)
            radius: 100
            border.width: 1.5
            border.color: "#FF" + thisTheme.subBackgroundColor
            color: bottomBarSlider.pressed ? "#FF" + thisTheme.subBackgroundColor : "WHITE"
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

//播放进度条，可以通过拖动来控制播放进度。

    Item {
        width: parent.width-15
        height: parent.height-20
        anchors.centerIn: parent
        Row {
            width: parent.width*.3
            height: parent.height
            anchors.left: parent.left
            spacing: 10
            RoundImage {
                id: musicCoverImg
                width: parent.height
                height: width
                source: p_musicRes.thisPlayMusicInfo.coverImg

                TapHandler {
                    id: tapHandler
                    onTapped: {
                        musicLyricPage.showPage()
                    }
                }

            }
            Column {
                width: parent.width - musicCoverImg.width - parent.spacing
                clip: true
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    id: nameText
                    width: parent.width
                    font.pointSize: bottomBar.fontSize
                    color: thisTheme.fontColor
                    Connections {
                        target: p_musicRes
                        function onThisPlayMusicInfoChanged() {
                            nameTextAni.stop()
                            nameTextAni.lastText = p_musicRes.thisPlayMusicInfo.name
                            nameText.text = p_musicRes.thisPlayMusicInfo.name
                        }
                    }

                    NumberAnimation {
                        id: nameTextAni
                        property string lastText: ""
                        target: nameText
                        property: "x"
                        to: -nameText.contentWidth/2 - nameText.font.pointSize/4*3
                        duration: nameText.text.length * 60
                        easing.type: Easing.Linear
                        onStopped: {
                            nameText.text = lastText
                            nameText.x = 0
                            lastText = ""
                        }
                    }

                    HoverHandler {
                        id: hoverHandler

                        onHoveredChanged: {
                            if (hoverHandler.hovered && nameText.width < nameText.contentWidth) {
                                nameTextAni.lastText = nameText.text
                                nameText.text += "   " + nameText.text
                                nameTextAni.start()
                            }
                        }
                    }
                }
                Text {
                    id: artistText
                    width: parent.width
                    font.pointSize: bottomBar.fontSize - 1
                    color: thisTheme.fontColor
                    Connections {
                        target: p_musicRes
                        function onThisPlayMusicInfoChanged() {
                            artistTextAni.stop()
                            artistTextAni.lastText = p_musicRes.thisPlayMusicInfo.artists
                            artistText.text = p_musicRes.thisPlayMusicInfo.artists
                        }
                    }

                    NumberAnimation {
                        id: artistTextAni
                        property string lastText: ""
                        target: artistText
                        property: "x"
                        to: -artistText.contentWidth/2 - artistText.font.pointSize/4*3
                        duration: artistText.text.length * 60
                        easing.type: Easing.Linear
                        onStopped: {
                            artistText.text = lastText
                            artistText.x = 0
                            lastText = ""
                        }
                    }

                    HoverHandler {
                        id: hoverHandler2

                        onHoveredChanged: {
                            if (hoverHandler.hovered && artistText.width < artistText.contentWidth) {
                                artistTextAni.lastText = artistText.text
                                artistText.text += "   " + artistText.text
                                artistTextAni.start()
                            }
                        }
                    }
                }
            }
        }
//包含音乐封面图片和歌曲信息的容器。
        Row {
            width: parent.width*.3
            anchors.centerIn: parent
            spacing: 5
            QCToolTipButton {
                id: playerModeIcon
                width: 35
                height: width
                source: "qrc:/Images/loopPlay.svg"

                hoverdColor: "#1F" + thisTheme.subBackgroundColor
                color: "#00000000"
                iconColor: "#FF" + thisTheme.subBackgroundColor

                TapHandler {
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

                hoverdColor: "#1F" + thisTheme.subBackgroundColor
                color: "#00000000"
                iconColor: "#FF" + thisTheme.subBackgroundColor

                TapHandler {
                    cursorShape: Qt.PointingHandCursor
                    onTapped: {
                        p_musicPlayer.preMusicPlay()
                    }
                }

            }
            QCToolTipButton {
                id: toolTipButton
                width: 35
                height: width
                source: if(p_musicPlayer.playbackState === 1) return "qrc:/Images/stop.svg"
                else return "qrc:/Images/player.svg"

                hoverdColor: "#FF" + thisTheme.subBackgroundColor
                color: "#FF" + thisTheme.subBackgroundColor
                iconColor: "WHITE"

                TapHandler {
                    cursorShape: Qt.PointingHandCursor
                    onTapped: {
                        p_musicPlayer.playPauseMusic()
                    }
                }

                HoverHandler {
                    id: hoverHandler1
                    cursorShape: Qt.PointingHandCursor
                    onHoveredChanged: {
                        if (hoverHandler1.hovered) {
                            toolTipButton.scale = 1.1
                        }
                        else {
                            toolTipButton.scale = 1
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
                hoverdColor: "#1F" + thisTheme.subBackgroundColor
                color: "#00000000"
                iconColor: "#FF" + thisTheme.subBackgroundColor

                TapHandler {
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

        }//播放控制按钮的容器，包括播放模式、上一首、播放/暂停、下一首按钮。

        Row {
            height: 35
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5
            Text {
                font.pointSize: bottomBar.fontSize
                font.weight: 1
                anchors.verticalCenter: parent.verticalCenter
                text: p_musicRes.setTime(bottomBarSlider.value)
                color: thisTheme.fontColor

            }
            Text {
                font.pointSize: bottomBar.fontSize
                font.weight: 1
                anchors.verticalCenter: parent.verticalCenter
                text: "/"+ p_musicRes.thisPlayMusicInfo.allTime
                color: thisTheme.fontColor

            }
            QCVolumeBtn {
                backgroundColor: "#FFFFFF"
                fontColor: "#FF" + thisTheme.subBackgroundColor
                sliderBackgroundColor: "#2F" + thisTheme.subBackgroundColor
                sliderColor: "#FF" + thisTheme.subBackgroundColor
                handleBorderColor: "#FF" + thisTheme.subBackgroundColor
                handleColor:  "WHITE"
                btnColor:  "#00000000"
                btnIconColor:  "#FF" + thisTheme.subBackgroundColor
                btnHoverdColor:  "#1F" + thisTheme.subBackgroundColor
            }

            QCToolTipButton {
                width: 35
                height: width
                source: "qrc:/Images/playList.svg"

                hoverdColor: "#1F" + thisTheme.subBackgroundColor
                color: "#00000000"
                iconColor: "#FF" + thisTheme.subBackgroundColor

                TapHandler {
                    cursorShape: Qt.PointingHandCursor
                    onTapped: {
                        qcThisPlayerListLabel.visible = !qcThisPlayerListLabel.visible
                    }
                }

            }

            Component.onCompleted: {
                var w = 0
                for(var i = 0; i < children.length;i++) {
                    if(children[i] instanceof Text) {
                        w += children[i].contentWidth
                    } else w += children[i].width

                }
                w = w + children.length * spacing-spacing
                width = w
            }
        }
    }//显示当前播放时间、总时间、音量控制按钮和播放列表按钮。

}

