import QtQuick


Rectangle {
    id: rightContent
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
