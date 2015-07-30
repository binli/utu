#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QtQml>

#include <ImageProcessor.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<ImageProcessor>("UtuImageProcessor", 1, 0,"ImageProcessor");

    QQuickView view;
    view.setSource(QUrl(QStringLiteral("qrc:///Main.qml")));
    view.setResizeMode(QQuickView::SizeRootObjectToView);

    view.rootContext()->setContextProperty("imageProcessor", new ImageProcessor);

    view.show();
    return app.exec();
}

