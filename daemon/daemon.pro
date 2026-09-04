TEMPLATE = app
TARGET = harbour-thakir_prayer_times-daemon

QT += core dbus
CONFIG += console c++11
SOURCES += main.cpp

# Install the daemon binary to /usr/bin
bin.files = $$TARGET
bin.path = /usr/bin
INSTALLS += bin
