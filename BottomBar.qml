import QtQuick
import QtQuick.Controls

Rectangle {
    id: bottomBar

    property var thisTheme: p_theme.defaultTheme[p_theme.current]
    property double fontSize: 11
    width: parent.width
    height: 80
    color: thisTheme.backgroundColor


    Slider{
        id:bottomBarSlider
        width:parent.width
        height:5
        anchors.bottom: parent.top
        background: Rectangle{
            color:"#1F"+thisTheme.subBackgroundColor
            Rectangle{
                width:bottomBarSlider.visualPosition*parent.width
                height:parent.height
                color:"#FF"+thisTheme.subBackgroundColor
            }
        }
        handle: Rectangle{
            implicitHeight: 20
            implicitWidth: 20
            x:(bottomBarSlider.availableWidth-width)*bottomBarSlider.visualPosition
            y:-((height-bottomBarSlider.height)/2)
            radius:100
            border.width: 1.5
            border.color: "#1F"+thisTheme.subBackgroundColor
            color:bottomBarSlider.pressed?"#FF"+thisTheme.subBackgroundColor:"WHITE"
        }
    }


    Item{
     width: parent.width-15
     height:parent.height-20
     anchors.centerIn: parent
     Row{
         width: parent.width*.3
         height: parent.height
         anchors.left:parent.left
         spacing:10
         RoundImage{
             id:musicCoverImg
             width: parent.height
             height: width
             source:""
         }
         Column{
             width:parent.width-musicCoverImg.width-parent.spacing
             anchors.verticalCenter: parent.verticalCenter
             Text{
                 font.pointSize: bottomBar.fontSize
                 text:"歌名"
                 color:thisTheme.fontcolor
             }
             Text{
                 font.pointSize: bottomBar.fontSize
                 text:"歌手"
                 color:thisTheme.fontcolor
             }
         }

     }
     Row{
         width:parent.width*.3
         anchors.centerIn: parent
         spacing: 5
         ToolTipButton{
             width:35
             height: width
             source: ""
             hoverdColor: "#1F"+thisTheme.subBackgroundColor
             color: "#00000000"
             iconColor: "#FF"+thisTheme.subBackgroundColor
         }
         ToolTipButton{
             width:35
             height: width
             source: ""
             hoverdColor: "#1F"+thisTheme.subBackgroundColor
             color: "#00000000"
             iconColor: "WHITE"
             onEntered: {
                 scale = 1.1
             }
             onExited: {
                 scale = 1
             }
             Behavior on scale {
                 ScaleAnimator {
                     duration: 200
                     easing.type: Easing.InOutQuart
                 }
             }
         }
         ToolTipButton{
             width:35
             height: width
             source: ""
             transformOrigin: Item.Center//
             rotation:-180//
             hoverdColor: "#1F"+thisTheme.subBackgroundColor
             color: "#00000000"
             iconColor: "#FF"+thisTheme.subBackgroundColor
         }
         ToolTipButton{
             width:35
             height: width
             source: ""
             hoverdColor: "#1F"+thisTheme.subBackgroundColor
             color: "#00000000"
             iconColor: "#FF"+thisTheme.subBackgroundColor
         }

         Component.onCompleted: {
             var w = 0
             for(var i = 0; i < children.length;i++) {
                 w += children[i].width
             }
             w = w + children.length * spacing-spacing
             width = w
         }
     }

     Row{
         anchors.right: parent.right
         anchors.verticalCenter: parent.verticalCenter
         spacing:5
         Text{
             font.pointSize: bottomBar.fontSize
             font.weight: 1
             anchors.verticalCenter: parent.verticalCenter
             text:"00:00"
             color:thisTheme.fontcolor

         }
         Text{
             font.pointSize: bottomBar.fontSize
             anchors.verticalCenter: parent.verticalCenter
              font.weight: 1
             text:"/00:00"
             color:thisTheme.fontcolor
         }
         ToolTipButton{
             width:35
             height: width
             source: ""
             hoverdColor: "#1F"+thisTheme.subBackgroundColor
             color: "#00000000"
             iconColor: "#FF"+thisTheme.subBackgroundColor
         }
         ToolTipButton{
             width:35
             height: width
             source: ""
             hoverdColor: "#1F"+thisTheme.subBackgroundColor
             color: "#00000000"
             iconColor: "#FF"+thisTheme.subBackgroundColor
         }
         Component.onCompleted: {
             var w = 0
             for(var i = 0; i < children.length;i++) {
                 if(children[i] instanceof Text){
                     w += children[i].contentWidth
                 }else w += children[i].width


             }
             w = w + children.length * spacing-spacing
             width = w
         }
     }

    }

}
