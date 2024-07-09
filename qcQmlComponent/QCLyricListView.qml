import QtQuick
import QtMultimedia

Item {
    id: lyricListView
    property MediaPlayer mediaPlayer: MediaPlayer{}
    property ListModel lyricData: ListModel{}
    property double fontSize: 16
    property int current: -1
    property int delayFollow: 10000
    property bool isFollow: true // 是否跟随
    width: parent.width
    height: parent.height

    onCurrentChanged: {
        if(isFollow) {
            listView.currentIndex = current
        }
    }

    function offsetScale(index,currentIndex) {
        var offset = Math.abs(index - currentIndex)
        var maxScale = 1.2
        return  maxScale - offset / 10
    }


	WheelHandler {
		onWheel: function (wheel) {
			lyricListView.isFollow = false

			if(wheel.angleDelta.y > 0 && listView.currentIndex > 0) {
				listView.currentIndex -= 1
			} else if(wheel.angleDelta.y < 0 && listView.currentIndex < listView.count-1){
				listView.currentIndex += 1
			}
			lryicFollowTim.restart()
		}
	}

	// MouseArea {
	//     anchors.fill: parent
	//     onWheel: function (wheel) {
	//         lyricListView.isFollow = false

	//         if(wheel.angleDelta.y > 0 && listView.currentIndex > 0) {
	//             listView.currentIndex -= 1
	//         } else if(wheel.angleDelta.y < 0 && listView.currentIndex < listView.count-1){
	//             listView.currentIndex += 1
	//         }
	//         lryicFollowTim.restart()
	//     }
	// }

    Timer {
        id: lryicFollowTim
        interval: lyricListView.delayFollow
        onTriggered: {
            lyricListView.isFollow = true
            console.log("已跟随")
        }

    }

    ListView {
        id: listView
        width: parent.width
        height: parent.height

        preferredHighlightBegin: parent.height/2 - 40
        preferredHighlightEnd: parent.height/2
        highlightMoveDuration: 500
        highlightRangeMode: ListView.StrictlyEnforceRange
        currentIndex: 0
        interactive: false
        model: lyricListView.lyricData
        delegate: lyricDelegate
        spacing: 20
        clip: true
    }
    Component {
        id: lyricDelegate
        Rectangle {
            id: lyricItem
            property double maxWidth: lyricListView.width * .6
            property bool isHoverd: false
            width: children[0].width + 30
            height: children[0].height + 30
            radius: 12
            scale: lyricListView.offsetScale(index,listView.currentIndex)
            transformOrigin: Item.Left
            color: if(isHoverd) return "#2F000000"
            else return "#00000000"

            Behavior on color {
                ColorAnimation {
                    duration: 400
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on scale {

                NumberAnimation {
                    property: "scale"
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }

            Column {
                property double childMaxWidth: children[0].contentWidth
                width: childMaxWidth > lyricItem.maxWidth ? lyricItem.maxWidth : childMaxWidth
                height: children[0].height + children[1].height + spacing
                anchors.centerIn: parent
                spacing: 10
                Text {
                    width: parent.width
                    height: text === "" ? 0 : contentHeight
                    wrapMode: Text.Wrap
                    font.pointSize: lyricListView.fontSize
                    font.bold: true
                    text: lyric
                    color: lyricListView.current === index ? "#FFFFFF" : "#7FFFFFFF"
                    onContentWidthChanged: function (contentWidth) {
                        if(contentWidth > parent.childMaxWidth ) {
                           parent.childMaxWidth = contentWidth
                        }
                    }
                }
                Text {
                    width: parent.width
                    height: text === "" ? 0 : contentHeight
                    wrapMode: Text.Wrap
                    font.pointSize: lyricListView.fontSize
                    font.bold: true
                    text: tlrc
                    color: lyricListView.current === index ? "#FFFFFF" : "#7FFFFFFF"
                    onContentWidthChanged: function (contentWidth) {
                        if(contentWidth > parent.childMaxWidth ) {
                           parent.childMaxWidth = contentWidth
                        }
                    }
                }
            }

			TapHandler {
				id: tapHandler2
				onTapped: {
					lyricListView.current = index
					listView.currentIndex = index
					mediaPlayer.position = tim
				}
			}

			HoverHandler {
				id: hoverHandler2

				onHoveredChanged: {
					parent.isHoverd = hoverHandler2.hovered
				}
			}

			// MouseArea {
			//     anchors.fill: parent
			//     hoverEnabled: true
			//     onClicked: {
			//         lyricListView.current = index
			//         listView.currentIndex = index
			//         mediaPlayer.position = tim
			//     }
			//     onEntered: {
			//         parent.isHoverd = true
			//     }
			//     onExited: {
			//         parent.isHoverd = false
			//     }
			// }
        }
    }

    Connections {
        target: mediaPlayer
        function onPositionChanged(pos) {
            for(let i = 0 ; i < listView.count;i++) {
                if(pos > lyricData.get(i).tim) {
                    if(i === listView.count - 1) {
                        lyricListView.current = i
                        break
                    } else if(lyricData.get(i+1).tim > pos ) {
                        lyricListView.current = i
                        break
                    }
                }
            }
        }
    }
}
