TEMPLATE = app

TARGET = harbour-thakir_prayer_times

# App version
#DEFINES += APP_VERSION=\"\\\"$${VERSION}\\\"\"

CONFIG += sailfishapp
#PKGCONFIG += keepalive
QT += multimedia dbus xml
#QT += dbus
#declarative

SOURCES += $${TARGET}.cpp \
    display.cpp \
    calcul.cpp \
    Settings.cpp \
    astro.c \
    prayer.c \
    positionsource.cpp \
    track.cpp \
    hijri.c  \
    uiconnection.cpp \
    DownloadManager.cpp


HEADERS += display.h \
    DownloadManager.hpp \
    astro.h \
    calcul.h \
    prayer.h \
    Settings.hpp \
    positionsource.h \
    track.h \
    hijri.h \
    uiconnection.h

CONFIG(release, debug|release) {
    DEFINES += QT_NO_DEBUG_OUTPUT
}
