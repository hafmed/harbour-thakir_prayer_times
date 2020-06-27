// HAF 19-11-2015

#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>

#include <QGuiApplication>
//#include <qdeclarative.h>
//#include <QDeclarativeView>
#include <QQmlEngine>
#include <QQuickView>
#include <QQmlContext>
#include <QLocale>
#include <QTimer>
#include <QTranslator>
#include <QDebug>

#include "display.h"
#include "calcul.h"
#include "uiconnection.h"
#include "Settings.hpp"

#include <QtQml>  // pour  qmlRegisterType<calcul>(.....

#include "positionsource.h"



int main(int argc, char *argv[])
{
    // SailfishApp::main() will display "qml/template.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //
    // To display the view, call "show()" (will show fullscreen on device).

    //return SailfishApp::main(argc, argv);

    //QGuiApplication* app = SailfishApp::application(argc, argv);
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    app->setApplicationVersion(QString(APP_VERSION));

    Display *display = new Display();

    QQuickView* view = SailfishApp::createView();
    qDebug() << "Import path" << SailfishApp::pathTo("lib/").toLocalFile();
    view->engine()->addImportPath(SailfishApp::pathTo("lib/").toLocalFile());
    // view->engine()->addImportPath(SailfishApp::pathTo("qml/components/").toLocalFile());
    view->engine()->addImportPath(SailfishApp::pathTo("qml/pages/").toLocalFile());

//    QTranslator *translator = new QTranslator;

    QString locale = QLocale::system().name();

//    qDebug() << "Translations:" << SailfishApp::pathTo("translations").toLocalFile() + "/" + locale + ".qm";

//    if(!translator->load(SailfishApp::pathTo("translations").toLocalFile() + "/" + locale + ".qm")) {
//        qDebug() << "Couldn't load translation";
//    }
//    app->installTranslator(translator);


    QTranslator *translator = new QTranslator();
    //QTranslator *coreTranslator = new QTranslator();

    translator->load(SailfishApp::pathTo("translations").toLocalFile() + "/" + locale + ".qm");
    //coreTranslator->load(QString(":translation/reversi-core_%1").arg(QLocale::system().name()));

    app->installTranslator(translator);
    //app->installTranslator(coreTranslator);

    UIConnection connection(translator);

    view->rootContext()->setContextProperty("display", display);
    view->rootContext()->setContextProperty("uiconnection", &connection);

    qmlRegisterType<calcul>("harbour.thakir_prayer_times.calculcpp", 1, 0, "Calculcpp");
    qmlRegisterType<QTimer>("harbour.thakir_prayer_times.qtimer", 1, 0, "QTimer");
    qmlRegisterType<Settings>("harbour.thakir_prayer_times.settings", 1, 0, "Settings");

    qmlRegisterType<PositionSource>("harbour.thakir_prayer_times.hafgps", 1, 0, "PositionSource");

    //qmlRegisterType<UIConnection>("harbour.thakir_prayer_times.uiconnection", 1, 0, "UIConnection");


    view->setSource(SailfishApp::pathTo("qml/harbour-thakir_prayer_times.qml"));
    view->showFullScreen();
    return app->exec();
}

