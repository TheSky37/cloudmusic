#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "framelesswindow.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/music_player_demo/main.qml"_qs);

    qmlRegisterType<FramelessWindow>("qc.window",1,0,"FramelessWindow");

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
