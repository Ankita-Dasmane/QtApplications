#include <QQmlContext>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include "database.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    //QIcon::setThemeName("icons");

    // qputenv("QT_QUICK_CONTROLS_STYLE", "Mat`erial");
    Database db;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("db",&db);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if(engine.rootObjects().isEmpty())
        return -1;
    return app.exec();
}
