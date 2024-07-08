import QtQuick
import qc.window 1.0
import QtQuick.Controls
import QtQuick.Layouts


//右内容栏
Rectangle {
    id: rightcontent
    property string thisQml: "PageFindMusic.qml"
    width: parent.width - leftBar.width
    height: parent.height
    color: "#fafafa"

    Loader{
        source: RightContent.thisQml
        onStatusChanged: {
            if(status === Loader.Ready) {
                console.log("加载完成" + sourse)
            }
        }

    }
}
