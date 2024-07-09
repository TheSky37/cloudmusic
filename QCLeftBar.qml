import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    id: leftBar
    property var thisTheme: p_theme.defaultTheme[p_theme.current]
    property var leftBarData: [{headerText:"",
            btnData:[{btnIcon:"qrc:/Images/discoverMusic.svg",btnText:"发现音乐",isActive:true,qml:"./qmlPage/PageFindMusic.qml"},
                {btnIcon:"qrc:/Images/myAttention.svg",btnText:"关注",isActive:true,qml:""},
                {btnIcon:"qrc:/Images/preFM.svg",btnText:"私人FM",isActive:true,qml:""}
            ],
            isActive:true
        },{headerText:"我的音乐",
            btnData:[{btnIcon:"qrc:/Images/myFavorite.svg",btnText:"我喜欢的音乐",isActive:true,qml:""},
                {btnIcon:"qrc:/Images/download.svg",btnText:"本地与下载",isActive:true,qml:""},
                {btnIcon:"qrc:/Images/recentlyPlayed.svg",btnText:"最近播放",isActive:true,qml:""},
                {btnIcon:"qrc:/Images/bookmark.svg",btnText:"我的收藏",isActive:true,qml:""}
            ],
            isActive:true
        },
    ]
    property var thisData: filterLeftBarData(leftBarData)
    property string thisQml: "./qmlPage/PageFindMusic.qml"
    property string thisBtnText: "发现音乐"
    property int count: thisData.length
    property int btnHeight: 40
    property int fontSize: 11
    width: 200
    height: parent.height
    color: thisTheme.backgroundColor
    function filterLeftBarData(leftBarData) { // 筛选需要显示的数据
        let filteredData = leftBarData.map(item => {
            if (item.isActive) {
                let filteredBtnData = item.btnData.filter(btn => btn.isActive);
                return { headerText: item.headerText, btnData: filteredBtnData };
            }
            return null;
        }).filter(item => item !== null);
        return filteredData
    }
    Flickable {
        id: leftBarFlickable
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: leftBarRepeater.allHeight
        Column {
            topPadding: 10
            spacing: 15
            Repeater {
                id: leftBarRepeater
                property int allHeight: 0
                model: leftBar.count
                delegate: repeaterDelegate
                onCountChanged: {
                    var h = 0
                    for(var i = 0;i < count;i++) {
                        h += itemAt(i).height
                    }
                    h = allHeight + parent.spacing * count
                }
            }
        }
        Component {
            id: repeaterDelegate
            ListView {
                id: listView
                width: leftBarFlickable.width
                height: leftBar.btnHeight * count
                interactive: false // 禁止拖拽
                spacing: 4
                model: ListModel {}
                header: Text {
                    width: parent.width
                    height: text === "" ? 0 : contentHeight + 5
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pointSize: leftBar.fontSize - 2
                    text: leftBar.thisData[index].headerText
                    color: leftBar.thisTheme.fontColor
                }

                delegate: listViewDelegate
                Component.onCompleted: {
                    model.append(leftBar.thisData[index].btnData)
                }
            }
        }
        Component {
            id: listViewDelegate
            Rectangle {
                property bool isHoverd: false
                property bool isThisBtn: leftBar.thisBtnText === btnText  //当前按钮是否被选中
                width: leftBarFlickable.width - 15
                height: leftBar.btnHeight
                radius: 50
                color: if(isHoverd) return "#1F" + leftBar.thisTheme.subBackgroundColor
                else return "#00000000"

                onParentChanged: {
                    if(parent!=null) {
                        anchors.horizontalCenter = parent.horizontalCenter
                    }
                }

                Rectangle {
                    width: parent.isThisBtn ? parent.width : 0
                    height: parent.height
                    radius: parent.radius
                    color: "#2F" + leftBar.thisTheme.subBackgroundColor
                    Behavior on width {
                        NumberAnimation {

                            duration: 200
                            easing.type: Easing.InOutQuad
                        }
                    }
                }

                Row {
                    spacing: 10
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: parent.radius  / 4
                    Image {
                        width: 20
                        height: width
                        source: btnIcon
                        sourceSize: Qt.size(32,32)
                    }
                    Text {
                        font.bold: isThisBtn ? true : false
                        font.pointSize: leftBar.fontSize
                        scale: isThisBtn ? 1.1 : 1
                        text: btnText
                        color: leftBar.thisTheme.fontColor
                        Behavior on scale {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }
                }

				TapHandler {
					id: tapHandler
					onTapped: {
						leftBar.thisBtnText = btnText
						leftBar.thisQml = qml
					}
				}

				HoverHandler {
					id: hoverHandler

					onHoveredChanged: {
						parent.isHoverd = hoverHandler.hovered
					}
				}





				// MouseArea {
				//     anchors.fill: parent
				//     cursorShape: Qt.PointingHandCursor
				//     hoverEnabled: true
				//     onClicked: {
				//         leftBar.thisBtnText = btnText
				//         leftBar.thisQml = qml
				//     }
				//     onEntered: {
				//         parent.isHoverd = true
				//     }
				//     onExited: {
				//          parent.isHoverd = false
				//     }
				// }
            }
        }
    }
}
