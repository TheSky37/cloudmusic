<<<<<<< HEAD
import QtQuick

Flickable {
    id: findMusicFlickable
    property var thisTheme: p_theme.defaultTheme[p_theme.current]
    property var headerData: [{headerText:"歌单",qml:"FindMusicPlayListContent.qml"},
    {headerText:"最新音乐",qml:"FindMusicNewMusicContent.qml"},
    {headerText:"个性推荐",qml:""},
    {headerText:"专属定制",qml:""},]
    property double fontSize: 11
    property int wheelStep: 300
    anchors.fill: parent
    contentWidth: parent.width
    contentHeight: findMusicHeader.height + findMusicContent.height + 30
    clip: true
    interactive: false
    signal contentYChanged()
    onContentYChanged: {

    }

    PropertyAnimation {
        id: findMusicFlickableAni
        target: findMusicFlickable
        property: "contentY"
        duration: 300
        easing.type: Easing.InOutQuart
        onStopped: {
            contentYChanged()
        }
    }

    MouseArea {
        anchors.fill: parent
        onWheel: function (wheel) {
            var step = contentY
            if(wheel.angleDelta.y > 0) {
                if(contentY - wheelStep < 0) {
                    step = 0
                } else {
                    step = contentY - wheelStep
                }
            } else if(wheel.angleDelta.y < 0){
                if(contentY + wheelStep + findMusicFlickable.height > findMusicFlickable.contentHeight ) {
                    step = findMusicFlickable.contentHeight - findMusicFlickable.height
                } else {
                    step = contentY + wheelStep
                }
            }
            findMusicFlickableAni.to = step
            findMusicFlickableAni.start()
        }
    }


    Rectangle {
        id: findMusicHeader
        property int current: 0
        property double topBottomPadding: 25
        property double leftRightPadding: 35
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 25
        radius: width/2
        color: "#0F" + thisTheme.subBackgroundColor
        Row {
            Repeater {
                model: ListModel{}
                delegate: findMusicHeaderDelegate
                Component.onCompleted: {
                    model.append(findMusicFlickable.headerData)
                }
                onCountChanged: {
                    var w = 0
                    var h = 0
                    for(var i = 0; i < count;i++) {
                        w += itemAt(i).width
                        if(h < itemAt(i).height) {
                            h = itemAt(i).height
                        }
                        findMusicHeader.width = w
                        findMusicHeader.height = h
                    }
                }
            }

        }
        Component {
            id: findMusicHeaderDelegate
            Rectangle {
                property bool isHoverd: false
                width: children[0].contentWidth + findMusicHeader.leftRightPadding
                height: children[0].contentHeight + findMusicHeader.topBottomPadding
                radius: width/2
                color: if(findMusicHeader.current === index) return "#2F" + thisTheme.subBackgroundColor
                else if(isHoverd) return "#1F" + thisTheme.subBackgroundColor
                else return "#00000000"
                Text {
                    anchors.centerIn: parent
                    font.pointSize: findMusicFlickable.fontSize
                    font.bold: findMusicHeader.current === index
                    text:  headerText
                    color: thisTheme.fontColor
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: {
                        findMusicHeader.current = index
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

    Loader {
        id: findMusicContent

        width: parent.width
        height: item  != null ? item.height : 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: findMusicHeader.bottom
        anchors.topMargin: 25
        source: findMusicFlickable.headerData[findMusicHeader.current].qml
        onStatusChanged: {
            if(status === Loader.Ready) {
                console.log("加载内容: " + source)
            }
        }
    }
}
=======
import QtQuick

// 定义一个可滑动容器，用于垂直滚动内容
Flickable {
    id: findMusicFlickable
    property var thisTheme: p_theme.defaultTheme[p_theme.current]

    //头部数据的数组，包含标题和对应的QML文件路径
    property var headerData: [{headerText:"歌单",qml:"./pageFindMusicContent/FindMusicPlayListContent.qml"},
    {headerText:"最新音乐",qml:"./pageFindMusicContent/FindMusicNewMusicContent.qml"},
    {headerText:"个性推荐",qml:""},
    {headerText:"专属定制",qml:""},]
    property double fontSize: 11
    property int wheelStep: 300
    anchors.fill: parent
    contentWidth: parent.width
    contentHeight: findMusicHeader.height + findMusicContent.height + 30
    clip: true
    interactive: false
    signal contentYChanged()
    onContentYChanged: {

    }

    // 属性动画，用于平滑过渡内容Y位置
    PropertyAnimation {
        id: findMusicFlickableAni
        target: findMusicFlickable
        property: "contentY"
        duration: 300
        easing.type: Easing.InOutQuart
        onStopped: {
            contentYChanged()
        }
    }

    // 滚轮事件处理，用于滚动内容
    WheelHandler {
        onWheel: function (wheel) {
            var step = contentY
            if(wheel.angleDelta.y > 0) {
                if(contentY - wheelStep < 0) {
                    step = 0
                } else {
                    step = contentY - wheelStep
                }
            } else if(wheel.angleDelta.y < 0){
                if(contentY + wheelStep + findMusicFlickable.height > findMusicFlickable.contentHeight ) {
                    step = findMusicFlickable.contentHeight - findMusicFlickable.height
                } else {
                    step = contentY + wheelStep
                }
            }
            findMusicFlickableAni.to = step
            findMusicFlickableAni.start()
        }
    }

    //头部区域
    Rectangle {
        id: findMusicHeader
        property int current: 0
        property double topBottomPadding: 25
        property double leftRightPadding: 35
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 25
        radius: width/2
        color: "#0F" + thisTheme.subBackgroundColor
        Row {
            Repeater {
                model: ListModel{}
                delegate: findMusicHeaderDelegate
                Component.onCompleted: {
                    model.append(findMusicFlickable.headerData)
                }

                // 计数改变时更新宽度
                onCountChanged: {
                    var w = 0
                    var h = 0
                    for(var i = 0; i < count;i++) {
                        w += itemAt(i).width
                        if(h < itemAt(i).height) {
                            h = itemAt(i).height
                        }
                        findMusicHeader.width = w
                        findMusicHeader.height = h
                    }
                }
            }

        }


        Component {
            id: findMusicHeaderDelegate
            Rectangle {
                property bool isHoverd: false// 是否悬停
                width: children[0].contentWidth + findMusicHeader.leftRightPadding
                height: children[0].contentHeight + findMusicHeader.topBottomPadding
                radius: width/2
                color: if(findMusicHeader.current === index) return "#2F" + thisTheme.subBackgroundColor
                else if(isHoverd) return "#1F" + thisTheme.subBackgroundColor
                else return "#00000000"
                Text {
                    anchors.centerIn: parent
                    font.pointSize: findMusicFlickable.fontSize
                    font.bold: findMusicHeader.current === index
                    text:  headerText
                    color: thisTheme.fontColor
                }

                // 头部委托组件
                TapHandler {
                    id: tapHandler
                    onTapped: {
                        findMusicHeader.current = index
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

    Loader {
        id: findMusicContent

        width: parent.width
        height: item  != null ? item.height : 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: findMusicHeader.bottom
        anchors.topMargin: 25
        source: findMusicFlickable.headerData[findMusicHeader.current].qml// Loader加载的QML文件的来源
        onStatusChanged: {
            if(status === Loader.Ready) {
                console.log("加载内容: " + source) // 当Loader状态变为Ready时，打印加载的QML文件路径
            }
        }
    }
}

>>>>>>> origin/main
