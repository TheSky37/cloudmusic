import QtQuick

Item {
    id: newMusicContent
    property var thisTheme: p_theme.defaultTheme[p_theme.current]
    property var headerData: [{name:"全部",type:"0"},
    {name:"华语",type:"7"},
    {name:"欧美",type:"96"},
    {name:"日本",type:"8"},
    {name:"韩国",type:"16"},]
    property var loadItems: []
    property double fontSize: 11
    property int startY: parent.y
    property int headerCurrent: 0
    property int contentCurrent: -1
    property int contentItemHeight: 80
    width: parent.width
    height: header.height + content.height + 80

    onHeaderCurrentChanged: {
        setContentModel()
    }

    Component.onCompleted: {
        setContentModel()
    }

    function setContentModel() {
        content.height = 0
        contentModel.clear()
        var callBack = res => {
            console.log(JSON.stringify(res[0]))
            content.height = res.length * 80 + 20
            contentModel.append(res)
        }
        p_musicRes.getNewMusic({type: headerData[headerCurrent].type,callBack:callBack})
    }
    function setContentItemVisible(contentY) {
        var wheelStep = findMusicFlickable.wheelStep
        var t = loadItems.slice(0,loadItems.length) // 保存上次加载的组件项
        var i = 0
        loadItems = []
        for(i = 0; i < contentRepeater.count;i++) {
            var startY = content.startY + i * newMusicContent.contentItemHeight
            var endY = contentY + findMusicFlickable.height
            if(startY + wheelStep >= contentY) {
                if(startY <= endY + wheelStep) {
                    loadItems.push(i)
                } else {
                    break
                }
            }
        }
        for(i = 0; i < loadItems.length;i++) { // 加载
            contentRepeater.itemAt(loadItems[i]).visible = true
        }
        for(i = 0; i < t.length;i++) { // 清理
            if(loadItems.indexOf(t[i]) === -1) { // 查找当前加载项哪些需要清理
                contentRepeater.itemAt(t[i]).visible = false
            }
        }
        console.log("当前清理的项: " + JSON.stringify(t))
        console.log("当前加载的项: " + JSON.stringify(loadItems))
    }

    Connections {
        target: findMusicFlickable
        function onContentYChanged() {
            setContentItemVisible(findMusicFlickable.contentY)
        }
    }

    Row {
        id: header
        spacing: 10
        width: parent.width * .9
        height: 20
        anchors.horizontalCenter: parent.horizontalCenter
        Repeater {
            model: ListModel{}
            delegate: headerDelegate
            Component.onCompleted: {
                model.append(newMusicContent.headerData)
            }
        }
        Component {
            id: headerDelegate
            Text {
                property bool isHoverd: false
                font.bold: isHoverd || newMusicContent.headerCurrent === index
                font.pointSize: newMusicContent.fontSize
                text: name
                color: "#C3C3C3"
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        newMusicContent.headerCurrent = index
                    }
                    onEntered: {
                        parent.isHoverd = true
                    }
                    onExited: {
                        parent.isHoverd = false
                    }
                }
            }
        }
    }

    Rectangle {
        id: content
        property int startY: newMusicContent.startY + y
        width: parent.width * .9
        height: 0
        anchors.top: header.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        radius: 10
        Item {
            width: parent.width - 20
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater {
                id: contentRepeater
                model: ListModel {
                    id: contentModel
                }
                delegate: contentDelegate
                onCountChanged: {
                    setContentItemVisible(findMusicFlickable.contentY)
                }
            }
        }
        Component {
            id: contentDelegate
            Rectangle {
                property bool isHoverd: false
                width: content.width - 20
                height: newMusicContent.contentItemHeight
                radius: 10
                visible: false
                y: index * newMusicContent.contentItemHeight + 10
                color: if(newMusicContent.contentCurrent === index) return "#2F" + thisTheme.subBackgroundColor
                else if(isHoverd) return "#1F" + thisTheme.subBackgroundColor
                else return "#00000000"
                Row {
                    width: parent.width -20
                    height: parent.height - 20
                    anchors.centerIn: parent
                    spacing: 10
                    Text {
                        width: parent.width*0.1 - 40
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.weight: 2
                        font.pointSize: newMusicContent.fontSize
                        elide: Text.ElideRight
                        text: index+1
                        color: thisTheme.fontColor
                    }
                    RoundImage {
                        width: parent.height
                        height: width
                        source: coverImg + "?param=" + width +"y"+height
                        radius: 8
                    }
                    Text {
                        width: parent.width*0.3
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignLeft
                        font.weight: 2
                        font.pointSize: newMusicContent.fontSize
                        elide: Text.ElideRight
                        text: name
                        color: thisTheme.fontColor
                    }
                    Text {
                        width: parent.width*0.2
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignLeft
                        font.weight: 2
                        font.pointSize: newMusicContent.fontSize
                        elide: Text.ElideRight
                        text: artists
                        color: thisTheme.fontColor
                    }
                    Text {
                        width: parent.width*0.2
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignLeft
                        font.weight: 2
                        font.pointSize: newMusicContent.fontSize
                        elide: Text.ElideRight
                        text: album
                        color: thisTheme.fontColor
                    }
                    Text {
                        width: parent.width*0.2 - parent.height
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignLeft
                        font.weight: 2
                        font.pointSize: newMusicContent.fontSize
                        elide: Text.ElideRight
                        text: allTime
                        color: thisTheme.fontColor
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onDoubleClicked: {
                        var musicInfo = {id: id,name: name,artists: artists,
                            album: album,coverImg: coverImg,url: "", allTime: allTime
                        }
                        p_musicPlayer.playMusic(id,musicInfo)

                        p_musicRes.thisPlayListInfo.clear()
                        for(var i = 0; i < contentModel.count;i++) {
                            p_musicRes.thisPlayListInfo.append(contentModel.get(i))
                        }
                        p_musicRes.thisPlayCurrent = index
                        p_musicRes.thisPlayListInfoChanged()
                    }
                    onClicked: {
                        newMusicContent.contentCurrent = index
                    }
                    onEntered: {
                        parent.isHoverd = true
                    }
                    onExited: {
                        parent.isHoverd = false
                    }
                }
            }
        }
    }
}
