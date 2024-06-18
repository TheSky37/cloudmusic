#include "framelesswindow.h"

FramelessWindow::FramelessWindow(QWindow *parent)
    : QQuickWindow(parent)
{
    this->setFlags(
        (Qt::Window | Qt::FramelessWindowHint | Qt::WindowMinMaxButtonsHint)); //设置窗口无边框样式
}

//重写鼠标点击事件
void FramelessWindow::mousePressEvent(QMouseEvent *event)
{
    this->start_pos = event->globalPosition();
    this->old_pos = this->position();
    this->old_size = this->size();
    event->ignore();

    QQuickWindow::mousePressEvent(event);
}

//重写鼠标弹起事件
void FramelessWindow::mouseReleaseEvent(QMouseEvent *event)
{
    this->old_pos = this->position();
    QQuickWindow::mouseReleaseEvent(event);
}

//重写鼠标移动事件
void FramelessWindow::mouseMoveEvent(QMouseEvent *event)
{
    QPointF pos = event->position();
    if (event->buttons() & Qt::LeftButton) { //判定鼠标左键是否按下，若按下则返回1,其余为0
        //改变窗口大小
        this->setWindowGeometry(event->globalPosition());

    } else {
        this->mouse_pos = this->getMousePos(pos);
        this->setCursorIcon();
    }
    QQuickWindow::mouseMoveEvent(event);
}

//设置鼠标样式
void FramelessWindow::setCursorIcon()
{
    static bool isSet = false;
    switch (this->mouse_pos) {
    case TOPLEFT:
    case BOTTOMRIGHT:
        this->setCursor(
            Qt::SizeFDiagCursor); //斜对角线方向箭头，表示用户可以沿对角线方向调整窗口大小
        isSet = true;
        break;
    case TOP:
    case BOTTOM:
        this->setCursor(Qt::SizeVerCursor); //垂直方向箭头，表示用户可以垂直调整窗口大小
        isSet = true;
        break;
    case TOPRIGHT:
    case BOTTOMLEFT:
        this->setCursor(
            Qt::SizeBDiagCursor); //斜对角线方向箭头，表示用户可以沿另一个对角线方向调整窗口大小
        isSet = true;
        break;
    case LEFT:
    case RIGHT:
        this->setCursor(Qt::SizeHorCursor); //水平方向的箭头，表示用户可以水平调整窗口大小
        isSet = true;
        break;
    default:
        if (isSet) {
            isSet = false;
            this->unsetCursor(); //恢复默认光标
            //maybe可以改成：this->ArrowCursor();
        }
        break;
    }
}

//确定窗口区域
FramelessWindow::MousePosition FramelessWindow::getMousePos(const QPointF &pos)
{
    int x = pos.x();
    int y = pos.y();
    int w = this->width();
    int h = this->height();

    MousePosition mouse_pos = NORMAL;

    if (x >= 0 && x <= this->step && y >= 0 && y <= this->step) {
        mouse_pos = TOPLEFT;
    } else if (x >= this->step && x < (w - this->step) && y >= 0 && y <= this->step) {
        mouse_pos = TOP;
    } else if (x >= (w - this->step) && x <= w && y >= 0 && y <= this->step) {
        mouse_pos = TOPRIGHT;
    } else if (x >= 0 && x <= step && y > step && y < (h - step)) {
        mouse_pos = LEFT;
    } else if (x >= (w - this->step) && x <= w && y > this->step && y < (h - this->step)) {
        mouse_pos = RIGHT;
    } else if (x >= 0 && x <= this->step && y > (h - this->step) && y < h) {
        mouse_pos = BOTTOMLEFT;
    } else if (x >= this->step && x < (w - this->step) && y >= (h - this->step) && y <= h) {
        mouse_pos = BOTTOM;
    } else if (x >= (w - this->step) && x <= w && y >= (h - this->step) && y <= h) {
        mouse_pos = BOTTOMRIGHT;
    }
    return mouse_pos;
}

FramelessWindow::MousePosition FramelessWindow::getMouse_pos() const
{
    return mouse_pos;
}

void FramelessWindow::setMouse_pos(MousePosition newMouse_pos)
{
    if (mouse_pos == newMouse_pos)
        return;
    mouse_pos = newMouse_pos;
    emit mouse_posChanged();
}

//更改窗口大小
void FramelessWindow::setWindowGeometry(const QPointF &pos)
{
    QPointF offset = start_pos - pos;
    if (offset.x() == 0 && offset.y() == 0) {
        return;
    }
    static auto set_geometry_func = [this](const QSize &size, const QPointF &pos) {
        QPointF t_pos = old_pos;
        QSize t_size = minimumSize();
        if (size.width() > minimumWidth()) {
            t_pos.setX(pos.x());
            t_size.setWidth(size.width());
        } else if (mouse_pos == LEFT) {
            t_pos.setX(old_pos.x() + old_size.width() - minimumWidth());
        }
        if (size.height() > minimumHeight()) {
            t_pos.setY(pos.y());
            t_size.setHeight(size.height());
        } else if (mouse_pos == LEFT) {
            t_pos.setY(old_pos.y() + old_size.height() - minimumHeight());
        }
        setGeometry(t_pos.x(), t_pos.y(), t_size.width(), t_size.height());
        update();
    };

    switch (mouse_pos) {
    case TOPLEFT:
        set_geometry_func(old_size + QSize(offset.x(), offset.y()), old_pos - offset);
        break;
    case TOP:
        set_geometry_func(old_size + QSize(0, offset.y()), old_pos - QPointF(0, offset.y()));
        break;
    case TOPRIGHT:
        set_geometry_func(old_size - QSize(offset.x(), -offset.y()),
                          old_pos - QPointF(0, offset.y()));
        break;
    case LEFT:
        set_geometry_func(old_size + QSize(offset.x(), 0), old_pos - QPointF(offset.x(), 0));
        break;
    case RIGHT:
        set_geometry_func(old_size - QSize(offset.x(), 0), position());
        break;
    case BOTTOMLEFT:
        set_geometry_func(old_size + QSize(offset.x(), -offset.y()),
                          old_pos - QPointF(offset.x(), 0));
        break;
    case BOTTOM:
        set_geometry_func(old_size + QSize(0, -offset.y()), position());
        break;
    case BOTTOMRIGHT:
        set_geometry_func(old_size - QSize(offset.x(), offset.y()), position());
        break;
    default:
        break;
    }
}
