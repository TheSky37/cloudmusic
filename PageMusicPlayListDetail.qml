import QtQuick


//显示列表
ListView {
    id: musicPlayListDetail
    property var thisTheme: p_theme.defaultTheme[p_theme.current]
    property var playListInfo: null

    property int fontSize: 11

    width: parent.width
    height: parent.height
    clip: true
    currentIndex: -1

    //当播放列表信息改变时触发
    onPlayListInfoChanged: {
        headerItem.id = playListInfo.id
        headerItem.nameText = playListInfo.name
        headerItem.coverImg = playListInfo.coverImg
        headerItem.descriptionText = playListInfo.description

        var musicDetailCallBack = res => {
            contentListModel.append(res)
            console.log(JSON.stringify(res[0]))
        }

        var musicPlayListDetailCallBack = res => {
            var ids = res.trackIds.join(',')
            console.log(JSON.stringify(res))

            //请求获取音乐详情
            p_musicRes.getMusicDetail({ids:ids,callBack:musicDetailCallBack})
        }

        //请求获取音乐播放列表详情
        p_musicRes.getMusicPlayListDetail({id:playListInfo.id,callBack:musicPlayListDetailCallBack})

    }

    //当内容数量改变时触发
    onCountChanged: {
        contentItemBackgound.height = count * 80 + 30
    }

    function setHeight(children,spacing) {
        var h = 0
        for(var i  =0;i < children.length;i++) {
            if(children[i] instanceof Text) {
                h+=children[i].contentHeight
            } else {
                h+= children[i].height
            }
        }
        return h + (children.length-1)*spacing
    }

    //显示播放列表的标题和封面图片
    header: Item {
        id: header
        property string id: ""
        property string nameText: ""
        property string coverImg: ""
        property string descriptionText: ""

        width: parent.width - 60
        height: children[0].height + 50
        anchors.horizontalCenter: parent.horizontalCenter
        Column {
            width: parent.width
            height: setHeight(children,spacing)
            anchors.top: parent.top
            anchors.topMargin: 30
            spacing: 15
            Row {
                width: parent.width
                height: 200
                spacing: 15
                RoundImage {//显示封面
                    id: coverImg
                    width: parent.height
                    height: width
                    source: header.coverImg
                }
                Column {
                    width: parent.width - coverImg.width - parent.spacing
                    height: setHeight(children,spacing)
                    anchors.verticalCenter: coverImg.verticalCenter
                    spacing: 12
                    Text {//显示标题、描述
                        width: parent.width
                        font.pointSize: musicPlayListDetail.fontSize
                        elide: Text.ElideRight
                        text: "歌单"
                        color: "#FF" + thisTheme.subBackgroundColor
                    }
                    Text {
                        width: parent.width
                        font.pointSize: 20
                        elide: Text.ElideRight
                        text: header.nameText
                        color: thisTheme.fontColor
                    }
                    Text {
                        width: parent.width
                        font.pointSize: musicPlayListDetail.fontSize
                        elide: Text.ElideRight
                        text: header.descriptionText
                        color: thisTheme.fontColor
                    }
                }
            }

            Row {
                width: parent.width
                height: 50
                spacing: 15
                QCToolTipButton {
                    width: parent.height
                    height: width
                    source: "qrc:/Images/player.svg"
                    hoverdColor: "#FF" + thisTheme.subBackgroundColor
                    color: "#FF" + thisTheme.subBackgroundColor
                    iconColor: "WHITE"
                    onEntered: {
                        scale = 1.1
                    }
                    onExited: {
                        scale = 1
                    }
                    Behavior on scale {
                        ScaleAnimator {
                            duration: 200
                            easing.type: Easing.InOutQuart
                        }
                    }
                }
                QCToolTipButton {
                    width: parent.height
                    height: width
                    source: "qrc:/Images/addPlayList.svg"
                    hoverdColor: "#1F" + thisTheme.subBackgroundColor
                    color: "#00000000"
                    iconColor: "#FF" + thisTheme.subBackgroundColor
                }
            }

            Row {
                width: parent.width -40
                height: 30
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                Text {
                    width: parent.width*0.15 - 40
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.weight: 2
                    font.pointSize: fontSize
                    elide: Text.ElideRight
                    text: "序号"
                    color: thisTheme.fontColor
                }
                Text {
                    width: parent.width*0.3
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignLeft
                    font.weight: 2
                    font.pointSize: fontSize
                    elide: Text.ElideRight
                    text: "歌名"
                    color: thisTheme.fontColor
                }
                Text {
                    width: parent.width*0.25
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignLeft
                    font.weight: 2
                    font.pointSize: fontSize
                    elide: Text.ElideRight
                    text: "作者"
                    color: thisTheme.fontColor
                }
                Text {
                    width: parent.width*0.2
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignLeft
                    font.weight: 2
                    font.pointSize: fontSize
                    elide: Text.ElideRight
                    text: "专辑"
                    color: thisTheme.fontColor
                }
                Text {
                    width: parent.width*0.1
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignLeft
                    font.weight: 2
                    font.pointSize: fontSize
                    elide: Text.ElideRight
                    text: "时长"
                    color: thisTheme.fontColor
                }
            }

        }
    }

    footer: Rectangle {
        width: parent.width - 80
        height: 50
        color: "#00000000"
    }

    //提供列表数据
    model: ListModel {
        id: contentListModel
    }

    //定义列表项的布局和行为
    delegate: Rectangle {
        property bool isHoverd: false
        width: musicPlayListDetail.width - 80
        height: 80
        radius: 12
        color: if(currentIndex === index) return "#2F" + thisTheme.subBackgroundColor
        else if(isHoverd) return "#1F" + thisTheme.subBackgroundColor
        else return "#00000000"
        onParentChanged: {
            if(parent!=null) {
                anchors.horizontalCenter = parent.horizontalCenter
            }
        }
        Row {
            width: parent.width -20
            height: parent.height - 20
            anchors.centerIn: parent
            spacing: 10
            Text {
                width: parent.width*0.15 - 40
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                font.weight: 2
                font.pointSize: fontSize
                elide: Text.ElideRight
                text: index + 1
                color: thisTheme.fontColor
            }
            Text {
                width: parent.width*0.3
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignLeft
                font.weight: 2
                font.pointSize: fontSize
                elide: Text.ElideRight
                text: name
                color: thisTheme.fontColor
            }
            Text {
                width: parent.width*0.25
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignLeft
                font.weight: 2
                font.pointSize: fontSize
                elide: Text.ElideRight
                text: artists
                color: thisTheme.fontColor
            }
            Text {
                width: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignLeft
                font.weight: 2
                font.pointSize: fontSize
                elide: Text.ElideRight
                text: album
                color: thisTheme.fontColor
            }
            Text {
                width: parent.width*0.1
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignLeft
                font.weight: 2
                font.pointSize: fontSize
                elide: Text.ElideRight
                text: allTime
                color: thisTheme.fontColor
            }
        }

        //点击事件
        TapHandler {
            id: tapHandler

            onTapped: {
                currentIndex = index
            }

            onDoubleTapped: {
                var musicInfo = {id: id,name: name,artists: artists,
                    album: album,coverImg: coverImg,url: "", allTime: allTime
                }
                var findIndex = p_musicRes.indexOf(id)
                if(findIndex === -1) {
                    p_musicRes.thisPlayListInfo.insert(p_musicRes.thisPlayCurrent+1,musicInfo)
                    p_musicRes.thisPlayListInfoChanged()
                    p_musicRes.thisPlayCurrent += 1
                } else {
                    p_musicRes.thisPlayCurrent = findIndex
                }
                p_musicPlayer.playMusic(id,musicInfo)
            }
        }

        //悬停事件
        HoverHandler {
            id: hoverHandler

            onHoveredChanged: {
                parent.isHoverd = hoverHandler.hovered
            }
        }



    }

    //设置列表项的背景
    Rectangle {
        id: contentItemBackgound
        parent: musicPlayListDetail.contentItem
        y: -15
        width: musicPlayListDetail.width - 50
        anchors.horizontalCenter: parent.horizontalCenter
        radius: 12
    }
}

