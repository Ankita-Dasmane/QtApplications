#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include<QQmlContext>
#include "databasemanager.h"
#include "pdfgenerator.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    // Register PdfGenerator under "PdfGen" module, version 1.0
    qmlRegisterType<Pdfgenerator>("PdfGen", 1, 0, "PdfGenerator");
    //database
    DatabaseManager db;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("db",&db);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if(engine.rootObjects().isEmpty())
        return -1;
    return app.exec();
}
