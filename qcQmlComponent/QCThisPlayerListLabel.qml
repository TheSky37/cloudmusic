import QtQuick

Rectangle {
    id: qcThisPlayListLabel

    property string backgroundColor: "#FAF2F1"
    property string fontColor: thisTheme.fontColor
    property string activeFontColor: "#FF" + thisTheme.subBackgroundColor
    property string contentItemColor: "#1F" + thisTheme.subBackgroundColor
    property string contentItemHoverdColor: "#4F" + thisTheme.subBackgroundColor

    width: 350
    height: 500
    radius: 12
    color: qcThisPlayListLabel.backgroundColor
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

	WheelHandler {
		onWheel: function (mouse) {}
	}

	// MouseArea { // 捕获掉鼠标事件不让传递
	//     anchors.fill: parent
	//     onWheel: function (mouse) {}
	// }

    ListView {
        id: qcThisPlayListLabelListView
        anchors.fill: parent
        clip: true
        currentIndex: p_musicRes.thisPlayCurrent
        header: Item {
            id: header
            width: qcThisPlayListLabel.width
            height: children[0].height
            Column {
                width: parent.width  - 40
                height: setHeight(children,spacing) + 20
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 12
                Text {
                    width: parent.width
                    wrapMode: Text.Wrap
                    font.pointSize: bottomBar.fontSize + 5
                    font.weight: 1
                    text: "当前播放: " + p_musicRes.thisPlayMusicInfo.name
                    color: qcThisPlayListLabel.fontColor
                }
                Item {
                    width: parent.width
                    height: children[0].contentHeight
                    Text {
                        font.pointSize: bottomBar.fontSize
                        font.weight: 1
                        text: "总共: "+ p_musicRes.thisPlayListInfo.count
                        color: qcThisPlayListLabel.fontColor
                    }
                    Text {
                        anchors.right: parent.right
                        font.pointSize: bottomBar.fontSize
                        font.weight: 1
                        text: "清空列表"
                        color: qcThisPlayListLabel.fontColor

						TapHandler {
							id: tapHandler2
							cursorShape: Qt.PointingHandCursor
							onTapped: {
								p_musicRes.thisPlayListInfo.clear()
								p_musicRes.thisPlayMusicInfo = {
									"id": "",
									"name": "",
									"artists": "",
									"album": "",
									"coverImg": "",
									"url": "",
									"allTime": "00:00",
								}
								p_musicRes.thisPlayMusicInfoChanged()
								p_musicRes.thisPlayCurrent = -1
							}
						}

						// MouseArea {
						//     anchors.fill: parent
						//     cursorShape: Qt.PointingHandCursor
						//     onClicked: {
						//         p_musicRes.thisPlayListInfo.clear()
						//         p_musicRes.thisPlayMusicInfo = {
						//             "id": "",
						//             "name": "",
						//             "artists": "",
						//             "album": "",
						//             "coverImg": "",
						//             "url": "",
						//             "allTime": "00:00",
						//         }
						//         p_musicRes.thisPlayMusicInfoChanged()
						//         p_musicRes.thisPlayCurrent = -1
						//     }
						// }

                    }
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    radius: width/2
                    color: qcThisPlayListLabel.fontColor
                }
            }
        }
        model: p_musicRes.thisPlayListInfo
        delegate: Rectangle {
            property string fontColor: if(qcThisPlayListLabelListView.currentIndex === index) return qcThisPlayListLabel.activeFontColor
            else return qcThisPlayListLabel.fontColor
            property bool isHoverd: false
            width: qcThisPlayListLabel.width
            height: children[0].height + 20
            color: if(isHoverd) return qcThisPlayListLabel.contentItemHoverdColor
            else if(index % 2) return qcThisPlayListLabel.contentItemColor
            else return qcThisPlayListLabel.backgroundColor
            Row {
                width: parent.width - 40
                height: children[0].contentHeight
                anchors.centerIn: parent
                spacing: 12
                Text {
                    width: parent.width *.3
                    font.pointSize: bottomBar.fontSize - 1
                    elide: Text.ElideRight
                    text: name
                    color: fontColor
                }
                Text {
                    width: parent.width *.25
                    font.pointSize: bottomBar.fontSize - 1
                    elide: Text.ElideRight
                    text: artists
                    color: fontColor
                }
                Text {
                    width: parent.width *.2
                    font.pointSize: bottomBar.fontSize - 1
                    elide: Text.ElideRight
                    text: album
                    color: fontColor
                }
                Text {
                    width: parent.width *.25 - 30
                    font.pointSize: bottomBar.fontSize - 1
                    elide: Text.ElideRight
                    text: allTime
                    color: fontColor
                }
            }

			TapHandler {
				onDoubleTapped: {
					p_musicRes.thisPlayCurrent = index
					p_musicPlayer.playMusic(id,p_musicRes.thisPlayListInfo.get(index))
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
			//     onDoubleClicked: {
			//         p_musicRes.thisPlayCurrent = index
			//         p_musicPlayer.playMusic(id,p_musicRes.thisPlayListInfo.get(index))
			//     }
			//     onEntered: {
			//         parent.isHoverd = true
			//     }
			//     onExited: {
			//         parent.isHoverd = false
			//     }
			// }
        }

        onCurrentItemChanged: {
            if(currentItem != null) {
                qcThisPlayListLabelPausePlay.parent = currentItem
            } else {
                qcThisPlayListLabelPausePlay.parent = qcThisPlayListLabel
            }

        }
    }
    QCImage {
        id: qcThisPlayListLabelPausePlay
        width: 10
        height: width
        anchors.verticalCenter: parent.verticalCenter
        visible: parent != qcThisPlayListLabel
        source: if(p_musicPlayer.playbackState === 1) return "qrc:/Images/stop.svg"
        else return "qrc:/Images/player.svg"
        color: qcThisPlayListLabel.activeFontColor
    }
    Text {
        visible: p_musicRes.thisPlayListInfo.count <= 0
        anchors.centerIn: parent
        font.pointSize: bottomBar.fontSize + 5
        text: "当前还未添加任何歌曲哦！"
        color: qcThisPlayListLabel.fontColor
    }
}
