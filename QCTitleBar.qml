import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts
import qc.window

Rectangle {
	id: titleBar
	property var thisTheme: p_theme.defaultTheme[p_theme.current]
	width: parent.width
	height: 80
	// color: thisTheme.backgroundColor
	color: "#EB4141"


	// DragHandler {
	// 	id: pointerHandler
	// 	property var click_pos: Qt.point(0,0)



	// 	onClick_posChanged: function (mouse) {
	// 		click_pos = Qt.point(pointerHandler.position.x,pointerHandler.position.y)
	// 	}

	// 	onParentChanged: function (mouse) {
	// 		if(!pressed || window.mouse_pos !== FramelessWindow.NORMAL) return

	// 		if(!window.startSystemMove()) { // 启用系统自带的拖拽功能
	// 			var offset = Qt.point(pointerHandler.position.x - click_pos.x,pointerHandler.position.y - click_pos.y)
	// 			window.x += offset.x
	// 			window.y += offset.y
	// 		}
	// 	}
	// }

	// MouseArea {
	// 	property var click_pos: Qt.point(0,0)
	// 	anchors.fill: parent
	// 	onPositionChanged: function (mouse) {
	// 		if(!pressed || window.mouse_pos !== FramelessWindow.NORMAL) return

	// 		if(!window.startSystemMove()) { // 启用系统自带的拖拽功能
	// 			var offset = Qt.point(mouseX - click_pos.x,mouseY - click_pos.y)
	// 			window.x += offset.x
	// 			window.y += offset.y
	// 		}
	// 	}
	// 	onPressedChanged: function (mouse) {
	// 		click_pos = Qt.point(mouseX,mouseY)
	// 	}
	// }

	TapHandler {
		id: tapHandler
		target: titleBar
		property var click_pos: Qt.point(0,0)

		onPressedChanged: function (mouse) {
			click_pos = Qt.point(tapHandler.point.position.x,tapHandler.point.position.y)
		}

		onClick_posChanged : function (mouse) {
			if(!pressed || window.mouse_pos !== FramelessWindow.NORMAL) return

			if(!window.startSystemMove()) { // 启用系统自带的拖拽功能
				var offset = Qt.point(tapHandler.point.position.x - click_pos.x,tapHandler.point.position.y - click_pos.y)
				window.x += offset.x
				window.y += offset.y
			}
		}

		onDoubleTapped: {
			if(window.visibility === Window.Maximized) {
				window.showNormal()
			} else {
				window.showMaximized()
			}
		}

	}
		RowLayout {
			width: parent.width - 20
			height: parent.height - 10
			anchors.centerIn: parent
			Row {
				width: 80
				height: parent.height
				spacing: 15
				Image {
					width: 30
					height: width
					anchors.verticalCenter: parent.verticalCenter
					source: "qrc:/Images/player.svg"
					ColorOverlay {
						anchors.fill: parent
						source: parent
						color: thisTheme.fontColor
					}
				}
				Text {
					font.pointSize: 12
					anchors.verticalCenter: parent.verticalCenter
					text: "Music Player Demo"
					// color: thisTheme.fontColor
					color: "#ffffff"

				}
				Component.onCompleted: {
					width = children[0].width + children[1].contentWidth + spacing
				}
			}
			Item {Layout.preferredWidth: 10; Layout.fillWidth: true}
			Row {
				width: 30 *3 + 5*3
				spacing: 5
				Rectangle {
					id: minWindowBtn
					property bool isHoverd: false
					width: 30
					height: width
					radius: 100
					// color: if(isHoverd) return "#1F572920"
					// 	   else return "#00000000"
					color: if(isHoverd) return "#1F572920"
						   else return "#ffffff"

					Rectangle {
						width: parent.width-10
						height: 3
						anchors.centerIn: parent
						color: thisTheme.fontColor
					}

					TapHandler {
						id: tapHandler1
						onPressedChanged: {
							window.showMinimized()
						}
					}

					HoverHandler {
						id: hoverHandler1

						onHoveredChanged: {
							parent.isHoverd = hoverHandler1.hovered
						}
					}

					// MouseArea {
					// 	anchors.fill: parent
					// 	hoverEnabled: true
					// 	onClicked: {
					// 		window.showMinimized()
					// 	}
					// 	onEntered: {
					// 		parent.isHoverd = true
					// 	}
					// 	onExited: {
					// 		parent.isHoverd = false
					// 	}
					// }
				}
				Rectangle {
					id: minMaxWindowBtn
					property bool isHoverd: false
					width: 30
					height: width
					radius: 100
					// color: if(isHoverd) return "#1F572920"
					// 	   else return "#00000000"
					color: if(isHoverd) return "#1F572920"
						   else return "#ffffff"

					Rectangle {
						width: parent.width-10
						height: width
						anchors.centerIn: parent
						radius: 100
						color: "#00000000"
						border.width: 2
						border.color: thisTheme.fontColor
					}

					TapHandler {
						id: tapHandler2
						onPressedChanged: {
							if(window.visibility === Window.Maximized) {
								window.showNormal()
							} else {
								window.showMaximized()
							}
						}
					}

					HoverHandler {
						id: hoverHandler2

						onHoveredChanged: {
							parent.isHoverd = hoverHandler2.hovered
						}
					}

					// MouseArea {
					// 	anchors.fill: parent
					// 	hoverEnabled: true
					// 	onClicked: {
					// 		if(window.visibility === Window.Maximized) {
					// 			window.showNormal()
					// 		} else {
					// 			window.showMaximized()
					// 		}
					// 	}
					// 	onEntered: {
					// 		parent.isHoverd = true
					// 	}
					// 	onExited: {
					// 		parent.isHoverd = false
					// 	}
					// }
				}
				Rectangle {
					id: quitWindowBtn
					property bool isHoverd: false
					width: 30
					height: width
					radius: 100
					// color: if(isHoverd) return "#1F572920"
					// 	   else return "#00000000"

					color: if(isHoverd) return "#1F572920"
						   else return "#ffffff"

					Rectangle {
						width: parent.width-10
						height: 3
						border.color: thisTheme.fontColor
						anchors.centerIn: parent
						rotation: 45
						color: thisTheme.fontColor
					}
					Rectangle {
						width: parent.width-10
						height: 3
						border.color: thisTheme.fontColor
						anchors.centerIn: parent
						rotation: -45
						color: thisTheme.fontColor
					}

					TapHandler {
						id: tapHandler3
						onPressedChanged: {
							Qt.quit()
						}
					}

					HoverHandler {
						id: hoverHandler3

						onHoveredChanged: {
							parent.isHoverd = hoverHandler3.hovered
						}
					}

					// MouseArea {
					// 	anchors.fill: parent
					// 	hoverEnabled: true
					// 	onClicked: {
					// 		Qt.quit()
					// 	}
					// 	onEntered: {
					// 		parent.isHoverd = true
					// 	}
					// 	onExited: {
					// 		parent.isHoverd = false
					// 	}
					// }
				}
			}
		}
}

