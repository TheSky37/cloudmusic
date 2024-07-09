cmake_minimum_required(VERSION 3.16)

project(music_player_demo VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)

set(CMAKE_AUTORCC ON)
qt_add_executable(appmusic_player_demo
    main.cpp
)

qt_add_qml_module(appmusic_player_demo
    URI music_player_demo
    VERSION 1.0
    QML_FILES main.qml
    SOURCES framelesswindow.h framelesswindow.cpp
    RESOURCES ImageResource.qrc
    QML_FILES QCBottomBar.qml
    QML_FILES QCTitleBar.qml
    QML_FILES QCLeftBar.qml
    QML_FILES QCRightContent.qml
    QML_FILES MusicResource.qml
    QML_FILES QCMusicPlayer.qml
    QML_FILES qcQmlComponent/QCVolumeBtn.qml
    QML_FILES qcQmlComponent/QCThisPlayerListLabel.qml
    QML_FILES qmlPage/PageFindMusic.qml qmlPage/PageMusicPlayListDetail.qml
    QML_FILES qmlPage/pageFindMusicContent/FindMusicNewMusicContent.qml qmlPage/pageFindMusicContent/FindMusicPlayListContent.qml
    QML_FILES qcQmlComponent/QCImage.qml qcQmlComponent/QCToolTipButton.qml qcQmlComponent/RoundImage.qml
    QML_FILES qcQmlComponent/QCPlayListLable.qml
    QML_FILES qmlPage/PageMusicLyricDetail.qml
    QML_FILES qcQmlComponent/QCLyricListView.qml
    SOURCES favoritemanager.h favoritemanager.cpp

)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appmusic_player_demo PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appmusic_player_demo
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appmusic_player_demo
    PRIVATE Qt6::Quick)

include(GNUInstallDirs)
install(TARGETS appmusic_player_demo
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
