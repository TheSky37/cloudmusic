import QtQuick 2.15
import qc.window 1.0
import QtQuick.Controls
import QtQuick.Layouts

//左侧边栏
Rectangle {
    id: leftBar
    property var name: [{headerText:"",btnDate:[
                {btnText:"" , btnIcon:"" , qml:"" , isActive:true},
                {btnText:"" , btnIcon:"" , qml:"" , isActive:true},
                {btnText:"" , btnIcon:"" , qml:"" , isActive:true}
            ]}, {headerText:"我的音乐" , btnData:[
                {btnText:"" , btnIcon:"" , qml:"" , isActive:true},
                {btnText:"" , btnIcon:"" , qml:"" , isActive:true},
                {btnText:"" , btnIcon:"" , qml:"" , isActive:true}
            ]}
    ]
    width: 200
    height: parent.height
    color: "#f5f5f7"
}
