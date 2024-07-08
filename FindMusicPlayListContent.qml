import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    id: playListContent
    property var thisTheme: p_theme.defaultTheme[p_theme.current]
    property var headerData: [{name:"ACG"},                           //使用 headerData 属性定义分类
    {name:"电子"},
    {name:"流行"},
    {name:"欧美"},
    {name:"古风"},
    {name:"欧美"},]
    property var boutiquePlayListData: []                             //存储播放列表数据
    property var loadItems: []                                        //存储加载的项目
    property var contentItemSourceSize: Qt.size(minContentItemWidth,minContentItemWidth)
    property double fontSize: 11
    property double minContentItemWidth: 220
    property double minContentItemHeight: minContentItemWidth *1.3
    property double contentItemWidth: minContentItemWidth
    property double contentItemHeight: contentItemWidth * 1.3
    property int headerCurrent: 0
    property int startY: parent.y
    width: parent.width
    height: header.height + content.height + 80

    Component.onCompleted: {
        setContentModel(headerData[headerCurrent].name)
    }
    onHeaderCurrentChanged: {
        setContentModel(headerData[headerCurrent].name)
    }

    function setContentModel(cat) {                         //定义 setContentModel 函数根据分类获取播放列表数据，并更新界面
        content.height = 0
        var boutiquePlayListCallBack = res => {
            boutiquePlayListData = res.slice(0,res.length)
            headerBackground_1.source = boutiquePlayListData[0].coverImg
            headerBoutiquePlayListInfo.nameText =  boutiquePlayListData[0].name
            headerBoutiquePlayListInfo.descriptionText =  boutiquePlayListData[0].description
            console.log("BoutiquePlayList: " + JSON.stringify(res[0]))
        }
        var playListCallBack = res => {
            var rows = Math.ceil(res.length / content.columns)
            contentModel.clear()
            contentModel.append(res)
            content.height = rows* contentItemHeight + rows * content.spacing
            console.log("playListCallBack: " + JSON.stringify(res[0]))
        }
        p_musicRes.getMusicBoutiquePlayList({cat:cat,callBack:boutiquePlayListCallBack})
        p_musicRes.getMusicPlayList({cat:cat,callBack: playListCallBack})
    }
    function setContentItemSize() {                         //定义 setContentItemSize 函数根据界面宽度计算每行显示的项目数和项目大小
        var w = content.width
        var columns = content.columns

        while(true) {
            if(w >= columns * content.spacing + (columns+1)*minContentItemWidth) {
                columns += 1
            } else if(w < (columns-1) * content.spacing + columns*minContentItemWidth) {
                columns -= 1
            } else break
        }

        content.columns = columns
        content.rows = Math.ceil(contentModel.count / columns)
        contentItemWidth = w / columns - ((columns-1) * content.spacing)/columns
        content.height = content.rows * contentItemHeight + content.rows * content.spacing
    }
    function setContentItemVisible(contentY) {              //定义 setContentItemVisible 函数根据滚动位置设置哪些项目是可见的
        var wheelStep = findMusicFlickable.wheelStep
        var t = loadItems.slice(0,loadItems.length) // 保存上次加载的组件项
        var i = 0
        var rows = 0
        loadItems = []
        for(i = 0; i < contentRepeater.count;i++) {
            rows = Math.floor(i / content.columns)
            var startY = content.startY + rows * contentItemHeight + (rows) * content.spacing
            var endY = contentY + findMusicFlickable.height
            if(startY+contentItemHeight + wheelStep >= contentY) {
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
    }

    Column {     //用于显示顶部背景和分类选择栏
        id: header
        width: parent.width * .9
        height: headerBackground.height + headerplayListSelectBar.height + spacing
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20
        Item {
            id: headerBackground
            width: parent.width
            height: 160

            RoundImage {
                id: headerBackground_1
                anchors.fill: parent
                radius: 12
                source: "qrc:/Images/HuoHuo.png"
                sourceSize: Qt.size(50,50)
            }
            RoundImage {
                id: headerBackground_2
                z: headerBackground_1.z+1
                anchors.fill: parent
                radius: 12
                source: headerBackground_1.source
                sourceSize: headerBackground_1.sourceSize
            }
            FastBlur { // 边缘淡发光
                anchors.fill: parent
                radius: 60
                source: headerBackground_1
                transparentBorder: true
            }
            FastBlur { // 模糊背景
                z: headerBackground_2.z+1
                anchors.fill: parent
                radius: 80
                source: headerBackground_2
                ColorOverlay {
                    anchors.fill: parent
                    source: parent
                    color: "#2F000000"
                }
            }

            Item {
                id: headerBoutiquePlayListInfo
                property string nameText: ""
                property string descriptionText: ""
                z: headerBackground_2.z + 1
                width: parent.width - 30
                height: parent.height - 30
                anchors.centerIn: parent
                RoundImage {
                    id: boutiquePlayListCoverImg
                    width: parent.height
                    height: width
                    radius: 10
                    source: headerBackground_2.source
                    sourceSize: Qt.size(width,height)
                }
                Column {
                    width: parent.width-boutiquePlayListCoverImg.width-anchors.leftMargin
                    height: parent.height
                    anchors.left: boutiquePlayListCoverImg.right
                    anchors.leftMargin: 15
                    anchors.verticalCenter: boutiquePlayListCoverImg.verticalCenter
                    spacing: 15
                    Text {
                        width: parent.width
                        height: contentHeight
                        font.pointSize: playListContent.fontSize
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                        color: "WHITE"
                        text: headerBoutiquePlayListInfo.nameText
                    }
                    Text {
                        width: parent.width
                        height: if(parent.height - parent.children[0].height - contentHeight < 0) return contentHeight
                        else return parent.height - parent.children[0].height
                        font.pointSize: playListContent.fontSize - 2
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                        color: "WHITE"
                        text: headerBoutiquePlayListInfo.descriptionText
                    }
                }
            }
        }

        Item {
            id: headerplayListSelectBar
            width: parent.width
            height: children[0].height
            Rectangle {
                width: children[0].contentWidth + 30
                height: children[0].contentHeight + 15
                radius: width/2
                color: "#00000000"
                border.color: thisTheme.fontColor
                Text {
                    font.pointSize: playListContent.fontSize
                    anchors.centerIn: parent
                    color: thisTheme.fontColor
                    text: "ACG"
                }
            }
            Row {
                anchors.right: parent.right
                Repeater {
                    id: headerRepeater
                    model: playListContent.headerData.length
                    delegate: Rectangle {
                        property bool isHoverd: false
                        width: children[0].contentWidth + 25
                        height: children[0].contentHeight + 15
                        radius: width/2
                        color: if(headerCurrent === index) return  "#2F" + thisTheme.subBackgroundColor
                        else return "#00000000"
                        Text {
                            font.pointSize: playListContent.fontSize - 1
                            font.bold: headerCurrent === index || parent.isHoverd
                            anchors.centerIn: parent
                            color: if(headerCurrent === index) return  "#FF" + thisTheme.subBackgroundColor
                                   else return thisTheme.fontColor
                            text: playListContent.headerData[index].name
                        }

                        TapHandler {
                            id: tapHandler
                            cursorShape: Qt.PointingHandCursor

                            onTapped: {
                                headerCurrent = index
                            }
                        }

                        HoverHandler {
                            id: hoverHandler

                            onHoveredChanged: {
                                parent.isHoverd = hoverHandler.hovered
                            }
                        }
                    }
                }
            }
        }


    }
    Item {
        id: content
        property int startY: playListContent.startY + y
        property int spacing: 20
        property int columns: 3
        property int rows: 0

        width: parent.width *.9
        height: 1000
        anchors.top: header.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        onWidthChanged: {
            if(width > 0) {
                contentItemSizeTimer.restart()
            }
        }
        onColumnsChanged: {
            contentItemSourceSize = Qt.size(contentItemWidth,contentItemWidth)
            setContentItemVisible(findMusicFlickable.contentY)
        }

        Repeater {
            id: contentRepeater
            model: ListModel {
                id: contentModel
            }
            onCountChanged: {
                setContentItemVisible(findMusicFlickable.contentY)
            }
            delegate: QCPlayListLable {
                property int rows: Math.floor(index / content.columns) // 当前所在行
                property int columns: Math.abs(rows*content.columns - index) // 当前所在列
                x: if(columns > 0) return columns * contentItemWidth + columns * content.spacing
                else return 0
                y: if(rows > 0) return rows * contentItemHeight + rows * content.spacing
                else return 0
                visible: false
                width: contentItemWidth
                height: contentItemHeight
                button.source: "qrc:/Images/player.svg"
                button.color: "#FF" + thisTheme.subBackgroundColor
                button.hoverdColor: "#FF" + thisTheme.subBackgroundColor
                button.iconColor: "WHITE"
                normalColor: "WHITE"
                hoverdColor: "#2F" + thisTheme.subBackgroundColor
                fontColor: thisTheme.fontColor
                imgSourceSize: contentItemSourceSize
                imgSource: coverImg + "?thumbnail=" + 240 +"y"+ 240
                text: name
                onClicked: {
                    leftBar.thisBtnText = ""
                    rightContent.thisQml = "./qmlPage/PageMusicPlayListDetail.qml"

                    rightContent.loadItem.playListInfo = {id:id,name:name,description:description,coverImg:coverImg}

                    console.log("标签点击 " + imgSource)
                }
                onBtnClicked: {
                    console.log("按钮点击")
                }
            }
        }
    }

    Timer {
        id: contentItemSizeTimer
        interval: 30
        onTriggered: {
            setContentItemSize()
        }
    }

    Connections {
        target: findMusicFlickable
        function onContentYChanged() {
            setContentItemVisible(findMusicFlickable.contentY)
        }
    }
}
