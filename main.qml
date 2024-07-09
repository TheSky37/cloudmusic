import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts
import qc.window
import "./qmlPage"


FramelessWindow {
    id: window
	width: 1010
	height: 710
    minimumWidth: 1010
    minimumHeight: 710
	color: "#2F000000"
    visible: true
    title: qsTr("Hello World")

    QtObject {
        id: p_theme

        property int current: 0
        // 默认主题
        property var defaultTheme: [
			{name:"pink",backgroundColor:"#FAF2F1",subColor:"#FAF7F6",subBackgroundColor:"FF5966",fontColor:"#572920",type:"default"}
        ]

    }
    MusicResource {
        id: p_musicRes
    }
    QCMusicPlayer {
        id: p_musicPlayer
        source: p_musicRes.thisPlayMusicInfo.url
    }

    Column {
        id: mainPage
		anchors.fill: parent
        QCTitleBar {
            id: titleBar
            width: parent.width
			height: 80
        }

        Rectangle {
            id: content
            width: parent.width
            height: window.height - titleBar.height - bottomBar.height

            Row {
                width: parent.width
                height: parent.height
                QCLeftBar {
                    id: leftBar
                    width: 180
                    height: parent.height
                }
                QCRightContent {
                    id: rightContent
                    width: parent.width - leftBar.width
                    height: parent.height
                    thisQml: leftBar.thisQml

                    Binding on thisQml{
                        when: leftBar.thisBtnText !== ""
                        value: leftBar.thisQml
                    }
                }
            }
        }

        QCBottomBar {
            id: bottomBar
            width: parent.width
            height: 80
        }
    }

    Loader {
        id: musicLyricPage
        property bool isShow: false
//        visible: false
        width: parent.width
        height: parent.height
        active: false
        source: "./qmlPage/PageMusicLyricDetail.qml"
        onLoaded: {
            item.y = musicLyricPage.height
        }

        ParallelAnimation {
            id: showHideAni
            property double endY: 0
            property double endOpacity: 0
            NumberAnimation {
                target: musicLyricPage.item
                property: "y"
                to: showHideAni.endY
                duration: 300
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: musicLyricPage.item
                property: "opacity"
                to: showHideAni.endOpacity
                duration: 300
                easing.type: Easing.InOutQuad
            }
            onStopped: {
                if(musicLyricPage.item.y === musicLyricPage.height || musicLyricPage.item.opacity ===0) {
                    musicLyricPage.isShow = false
                    musicLyricPage.active = false

                } else if(musicLyricPage.item.y === 0 || musicLyricPage.item.opacity === 1) {
                    mainPage.visible = false
                    musicLyricPage.isShow = true
                    musicLyricPage.active = true
                }
            }
        }

        function hidePage() { // 隐藏页面
            mainPage.visible = true
            showHideAni.endY = musicLyricPage.height
            showHideAni.endOpacity = 0
            showHideAni.start()
        }
        function showPage() { // 显示页面
            musicLyricPage.active = true
            showHideAni.endY = 0
            showHideAni.endOpacity = 1
            showHideAni.start()
        }
    }

}
