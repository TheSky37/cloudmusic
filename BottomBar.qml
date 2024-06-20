import QtQuick


Rectangle {
    id: bottomBar

    property var thisTheme: p_theme.defaultTheme[p_theme.current]
    property double fontSize: 11
    width: parent.width
    height: 80
    color: "red"

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
             source:"/Images/QingQueQ.png"
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

     }

    }

}
