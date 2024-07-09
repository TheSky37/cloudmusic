import QtQuick

// MouseArea {

// 	property string color: ""
// 	property string iconColor: ""
// 	property string hoverdColor: ""
// 	property string source: ""
// 	property bool isHoverd: false
// 	width: 30
// 	height: width
// 	hoverEnabled: true
// 	Rectangle {
// 		anchors.fill: parent
// 		radius: 100
// 		color: if(parent.isHoverd) return hoverdColor
// 		else return parent.color
// 	}
// 	QCImage {
// 		width: parent.width * .5
// 		height: width
// 		anchors.centerIn: parent
// 		source: parent.source
// 		sourceSize: Qt.size(32,32)
// 		color: parent.iconColor
// 	}
// 	onEntered: {
// 		isHoverd = true
// 	}
// 	onExited: {
// 		isHoverd = false
// 	}
// }

Item {
	property string color: ""
	property string iconColor: ""
	property string hoverdColor: ""
	property string source: ""
	property bool isHoverd: false
	width: 30
	height: width

	Rectangle {
		anchors.fill: parent
		radius: 100
		color: if(parent.isHoverd) return hoverdColor
		else return parent.color
	}
	QCImage {
		width: parent.width * .5
		height: width
		anchors.centerIn: parent
		source: parent.source
		sourceSize: Qt.size(32,32)
		color: parent.iconColor
	}

	HoverHandler {
		id: hoverHandler
		cursorShape: Qt.PointingHandCursor
		onHoveredChanged: {
			isHoverd = hoverHandler.hovered
		}
	}
}



