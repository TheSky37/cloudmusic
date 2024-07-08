#pragma once

#include <QQuickWindow>

class FramelessWindow : public QQuickWindow
{
    Q_OBJECT
    Q_PROPERTY(
        MousePosition mouse_pos READ getMouse_pos WRITE setMouse_pos NOTIFY mouse_posChanged FINAL)

public:
    //枚举类型定义鼠标距离边框的位置
    enum MousePosition {
        TOPLEFT = 1,
        TOP,
        TOPRIGHT,
        LEFT,
        RIGHT,
        BOTTOMLEFT,
        BOTTOM,
        BOTTOMRIGHT,
        NORMAL
    };
    Q_ENUM(MousePosition);
    FramelessWindow(QWindow* parent = nullptr);

    MousePosition getMouse_pos() const;
    void setMouse_pos(MousePosition newMouse_pos);

signals:
    void mouse_posChanged();

protected:
    //重写鼠标事件
    void mousePressEvent(QMouseEvent* event);
    void mouseReleaseEvent(QMouseEvent* event);
    void mouseMoveEvent(QMouseEvent* event);

private:
    //缩放边距
    int step = 10;

    //鼠标位置及鼠标变化
    void setCursorIcon();
    MousePosition getMousePos(const QPointF& pos);
    MousePosition mouse_pos = NORMAL;

    //鼠标起始位置
    QPointF start_pos;
    //窗口原来位置
    QPointF old_pos;
    //窗口原大小
    QSize old_size;

    //大小变化
    void setWindowGeometry(const QPointF& pos);
};
