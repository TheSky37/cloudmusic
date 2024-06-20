import QtQuick 2.15
import qc.window 1.0
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: leftBar
    property var thisTheme: p_theme.defaultTheme[p_theme.current]
    property var LeftBarData: [
        {
            headerText: "推荐",
            btnData: [
                {btnText: "发现音乐", btnIcon: "", qml: "", isActive: true},
                {btnText: "私人FM", btnIcon: "", qml: "", isActive: true},
                {btnText: "关注", btnIcon: "", qml: "", isActive: true}
            ]
        },
        {
            headerText: "我的音乐",
            btnData: [
                {btnText: "我喜欢的音乐", btnIcon: "", qml: "", isActive: true},
                {btnText: "本地与下载", btnIcon: "", qml: "", isActive: true},
                {btnText: "最近播放", btnIcon: "", qml: "", isActive: true},
                {btnText: "我的收藏", btnIcon: "", qml: "", isActive: true}
            ]
        }
    ]

    property var thisData: filterLeftBarData(LeftBarData)
    property string thisQm: ""
    property string thisBtnText: "发现音乐"
    property int count: thisData.length
    property int btnHeight: 40
    property int fontSize: 11
    width: 200
    height: parent.height
    color: "#f5f5f7"

    function filterLeftBarData(leftBarData) { // 修正函数名
        let filteredData = leftBarData.map(item => {
            if (item.btnData) {
                let filteredBtnData = item.btnData.filter(btn => btn.isActive);
                return { headerText: item.headerText, btnData: filteredBtnData }; // 使用正确的 btnData
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
                model: leftBar.thisData
                delegate: repeaterDelegate
            }
        }
        Component {
            id: repeaterDelegate
            Column {
                width: leftBarFlickable.width - 15
                spacing: 10
                Text {
                    text: modelData.headerText
                    font.pixelSize: leftBar.fontSize
                }
                ListView {
                    width: leftBarFlickable.width - 15
                    height: modelData.btnData.length * leftBar.btnHeight
                    interactive: false // 禁止拖拽
                    model: modelData.btnData
                    delegate: listViewDelegate
                }
            }
        }
        Component {
            id: listViewDelegate
            Rectangle {
                property bool isHovered: false
                width: leftBarFlickable.width - 15
                height: leftBar.btnHeight
                color: isHovered ? "#f5f5f7" : "#e8e9ec"

                Text {
                    anchors.centerIn: parent
                    text: model.btnText
                }

                TapHandler {
                    onTapped: {
                        color = "#e8e9ec"
                    }
                }

                HoverHandler {
                    onHoveredChanged: {
                        isHovered = hovered
                    }
                }
            }
        }
    }
}
