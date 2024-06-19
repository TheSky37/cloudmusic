import QtQuick
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
    property string thisQml: ""
    property string thisBtnText: "发现音乐"
    property int count: thisData.length
    property int btnHeight: 40
    property int fontSize: 11
    width: 200
    height: parent.height
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
    Flickable{
        id:leftBarFlickable
        anchors.fill: parent
        Column{
            topPadding:10
            spacing: 10
            Repeater{
                id:leftBarRepeater
                model: leftBar.count
                delegate: repeaterDelegate
            }
        }
    }
    Component{
        id:repeaterDelegate
        ListView{
            id:listview
            width: leftBarFlickable.width-15
            height: 80
            interactive: false//禁止拖拽
            spacing:4
            model:ListModel{}
            header: Text{
                font.pointSize: leftBar.fontSize-1
                text:leftBar.thisData[index].headerText
                color:leftBar.thisTheme.fontColor
            }

            delegate: listViewDelegate
            Component.onCompleted: {
                model.append(leftBar.thisData[index].btnData)
            }
        }
    }
    Component{
        id:listViewDelegate
        Rectangle{
            property bool isHoverd: false
            width: leftBarFlickable.width-15
            height:leftBar.btnHeight
            radius: 50
            color: if(isHoverd) return "#1F"+leftBar.thisTheme.subBackgroundColor//这里有修改
            else return "#00000000"
            Row{
                spacing:10
                anchors.verticalCenter: parent.verticalCenter
                Image {
                    width:20
                    height: width
                    source: btnIcon
                    sourceSize: Qt.size(32,32)
                }
                Text{
                    font.pointSize: leftBar.fontSize
                    text:btnText
                    color:leftBar.thisTheme.fontColor
                }
            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {

                }
                onEntered: {
                    parent.isHoverd=true
                }
                onExited: {
                    parent.isHoverd=false
                }
            }
        }
    }

}
