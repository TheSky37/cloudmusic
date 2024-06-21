import QtQuick

Item {
    id:newMusicContent
    property  var thisTheme: p_theme.defaultTheme[p_theme.current]
    property type headerData: [{name:"全部",type:"0"},
    {name:"华语",type:"7"},
    {name:"欧美",type:"96"},
    {name:"日本",type:"8"},
    {name:"韩国",type:"16"},]
    property double fontSize:11
    property int headerCurrent:0
    width: parent.width
    height: header.height

    Row{
        id:header
        spacing: 10
        width: parent.width * .9
        height: 20
        anchors.horizontalCenter: parent.horizontalCenter
        Repeater{
            model: ListModel{}
            delegate: headerDelegate
            Component.onCompleted: {
                model.append(newMusicContent.headerData)
            }
        }
        Component{
            id:headerDalegate
            Text {
                property bool isHoverd:false
                font.bold: isHoverd || newMusicContent.headerCurrent
                font.pointSize: newMusicContent.fontSize
                text:name
                color:"#C3C3C3"
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        newMusicContent.headerCurrent = index
                    }
                    onEntered: {
                        parent.isHoverd = true
                    }
                    onExited:{
                        parent.isHoverd = false
                    }

                }
            }
        }
    }

    Rectangle{
        id:condent
        width: parent.width * .9
        height: 0
        anchors.horizontalCenter: parent.horizontalCenter
        radius:10
        color: "WHITE"
        Column{
            Repeater{
                model: ListModel{
                    id:contentModel

                }

            }
        }
        Component{
            id:contentDelegate
            Rectangle{
                property bool isHoverd:false
                Row{
                    spacing: 10
                    Text{
                        font.weight: 2
                        font.pointSize: newMusicContent.fontSize
                        text: index+1
                        color:thisTheme.fontColor

                    }
                    RoundImage{
                        width:parent.height
                        height:width
                        source:""
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {

                    }
                    onEntered: {
                        parent.isHoverd = true
                    }
                    onExited:{
                        parent.isHoverd = false
                    }

                }

            }
        }
    }
}
