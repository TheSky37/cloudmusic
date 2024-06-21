import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: leftBar
    property var leftBarData: [
        {
            headerText: "推荐",
            btnData: [
                {btnText: "发现音乐", btnIcon: "qrc:/source/icon1.png", qml: "", isActive: true},
                {btnText: "私人FM", btnIcon: "qrc:/source/icon2.png", qml: "", isActive: true},
                {btnText: "关注", btnIcon: "qrc:/source/icon3.png", qml: "", isActive: true}],
          isActive:true
        },{
            headerText: "我的音乐",
            btnData: [
                {btnText: "我喜欢的音乐", btnIcon: "qrc:/source/icon4.png", qml: "", isActive: true},
                {btnText: "本地与下载", btnIcon: "qrc:/source/icon5.png", qml: "", isActive: true},
                {btnText: "最近播放", btnIcon: "qrc:/source/icon6.png", qml: "", isActive: true},
                {btnText: "我的收藏", btnIcon: "qrc:/source/icon7.png", qml: "", isActive: true}
            ],
            isActive:true
        },
    ]

    property var thisData: filterLeftBarData(leftBarData)
    property string thisQm: ""
    property string thisBtnText: "发现音乐"
    property int count: thisData.length
    property int btnHeight: 40
    property int fontSize: 10 // 增加字体大小
    width: 200
    height: parent.height
    color: "#f5f5f7"

    function filterLeftBarData(leftBarData) {
        let filteredData = leftBarData.map(item => {
            if (item.isActive) {
                let filteredBtnData = item.btnData.filter(btn => btn.isActive);
                return { headerText: item.headerText, btnData: filteredBtnData };
            }
            return null;
        }).filter(item => item !== null);
        return filteredData;
    }

    Flickable {
        id: leftBarFlickable
        anchors.fill: parent
        Column {
            topPadding: 10
            spacing: 10
            Repeater {
                id: leftBarRepeater
                model: leftBar.count
                delegate: repeaterDelegate
            }
        }
    }

    Component {
        id: repeaterDelegate
        Item {
            width: leftBarFlickable.width
            height: leftBar.thisData[index].btnData.length * (leftBar.btnHeight + 7) + leftBar.btnHeight // 动态计算高度

            Column {
                width: parent.width
                spacing: 7
                Text {
                    font.pointSize: leftBar.fontSize
                    text: leftBar.thisData[index].headerText
                    color: "#7f7f7f"
                }
                ListView {
                    width: parent.width
                    height: leftBar.thisData[index].btnData.length * (leftBar.btnHeight + 7) // 动态计算高度
                    interactive: false
                    spacing: 7
                    model: ListModel { }
                    delegate: listViewDelegate
                    Component.onCompleted: {
                        model.append(leftBar.thisData[index].btnData)
                    }
                }
            }
        }
    }

    Component {
        id: listViewDelegate
        Rectangle {
            property bool isHovered: false
            width: leftBarFlickable.width
            height: leftBar.btnHeight
            color: isHovered ? "#e8e9ec" : "#f5f5f7"

            Row {
                anchors.fill: parent
                spacing: 10 // 设置图标和文本之间的间距
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    width: 20
                    height: width
                    source: model.btnIcon
                    sourceSize: Qt.size(32, 32)
                }

                Text {
                    font.pointSize: leftBar.fontSize
                    text: model.btnText
                    color: "#7f7f7f" // 设置较浅的颜色
                }
            }

            TapHandler {
                onTapped: {
                    parent.color = "#e8e9ec"
                }
            }

            HoverHandler {
                onHoveredChanged: {
                    parent.isHovered = hovered
                }
            }
        }
    }
}
