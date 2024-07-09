import QtQuick

Rectangle {
    id: playListLable
    property alias button: btn
    property alias imgSourceSize: coverImg.sourceSize
    property string imgSource: "qrc:/Images/HuoHuo.png"
    property string fontColor: ""
    property string normalColor: ""
    property string hoverdColor: ""
    property string text: ""
    property int fontSize: 11

    width: 220
    height: width*1.3
    radius: 12
    signal clicked()
    signal btnClicked()

    state: "noraml"
    states: [
        State {
            name: "noraml"
            PropertyChanges {
                target: playListLable
                color: normalColor
            }
            PropertyChanges {
                target: btn
                y: btn.parent.height
            }
            PropertyChanges {
                target: btn
                opacity: 0
            }
        },
        State {
            name: "hoverd"
            PropertyChanges {
                target: playListLable
                color: hoverdColor
            }
            PropertyChanges {
                target: btn
                y: btn.parent.height - btn.height - 15
            }
            PropertyChanges {
                target: btn
                opacity: 1
            }
        }
    ]
    transitions: [
        Transition {
            from: "normal"
            to: "hoverd"
            ColorAnimation {
                target: playListLable
                easing.type: Easing.InOutQuart
                duration: 300
            }
            PropertyAnimation {
                target: btn
                property: "y"
                easing.type: Easing.InOutQuart
                duration: 300
            }
            PropertyAnimation {
                target: btn
                property: "opacity"
                easing.type: Easing.InOutQuart
                duration: 300
            }
        },
        Transition {
            from: "hoverd"
            to: "normal"
            ColorAnimation {
                target: playListLable
                easing.type: Easing.InOutQuart
                duration: 300
            }
            PropertyAnimation {
                target: btn
                property: "y"
                easing.type: Easing.InOutQuart
                duration: 300
            }
            PropertyAnimation {
                target: btn
                property: "opacity"
                easing.type: Easing.InOutQuart
                duration: 300
            }
        }
    ]

	TapHandler {
		id: tapHandler
		onTapped: {
			playListLable.clicked()
		}
	}

	HoverHandler {
		id: hoverHandler

		onHoveredChanged: {
			if (hoverHandler.hovered) {
				parent.state = "hoverd"
			}
			else {
				parent.state = "normal"
			}
		}
	}


	// MouseArea {
	// 	anchors.fill: parent
	// 	hoverEnabled: true
	// 	onClicked: {
	// 		playListLable.clicked()
	// 	}

	// 	onEntered: {
	// 		parent.state = "hoverd"
	// 	}
	// 	onExited: {
	// 		parent.state = "normal"
	// 	}
		Column {
			width: parent.width - 30
			height: parent.height - 30
			anchors.centerIn: parent
			spacing: 15
			RoundImage {
				id: coverImg
				width: parent.width
				height: width
				radius: 10
				source: playListLable.imgSource
				clip: true
				QCToolTipButton {
					id: btn
					width: 50
					height: width
					x: parent.width - width - 15
					y: parent.height
					scale: isHoverd ? 1.1 : 1
					opacity: 0

					TapHandler {

						onTapped: {
							playListLable.btnClicked()
						}
					}

					// onClicked: {
					// 	playListLable.btnClicked()
					// }
					Behavior on scale {
						PropertyAnimation {
							target: btn
							property: "scale"
							easing.type: Easing.InOutQuart
							duration: 300
						}
					}
				}
			}
			Text {
				width: parent.width
				height: parent.height - coverImg.height - parent.spacing
				font.pointSize: playListLable.fontSize
				wrapMode: Text.Wrap
				elide: Text.ElideRight
				color: fontColor
				text: playListLable.text
			}
		}

	// }

}
