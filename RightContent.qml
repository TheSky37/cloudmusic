import QtQuick
import qc.window 1.0
import QtQuick.Controls
import QtQuick.Layouts


//右内容栏
Rectangle {
    id: rightcontent
    width: parent.width - leftBar.width
    height: parent.height
    color: "#fafafa"
}
