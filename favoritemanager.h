#pragma once

#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>
#include <QObject>


class FavoriteManager : public QObject
{
    Q_OBJECT
public:
    FavoriteManager(QObject *parent = nullptr);
};
