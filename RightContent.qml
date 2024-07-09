import QtQuick

// 定义一个矩形区域，用于作为内容的容器
Rectangle {
    id: rightContent

    // 定义属性，thisTheme用于获取当前主题样式，loadItem用于访问加载项，thisQml用于指定要加载的QML文件
    property var thisTheme: p_theme.defaultTheme[p_theme.current]
    property alias loadItem: rightContentLoader.item
    property string thisQml: "PageFindMusic.qml"
    color: thisTheme.subColor
    Loader {
        id: rightContentLoader
        source: rightContent.thisQml
        onLoaded: {
            item.parent = parent
            console.log("加载完成: " + source)
        }
    }

}
