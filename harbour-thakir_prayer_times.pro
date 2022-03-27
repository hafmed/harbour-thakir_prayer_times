# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-thakir_prayer_times

QT += multimedia dbus xml

PKGCONFIG += keepalive

DEPLOYMENT_PATH = /usr/share/$${TARGET}
qml.files = qml
qml.path = $${DEPLOYMENT_PATH}

desktop.files = $${TARGET}.desktop
desktop.path = /usr/share/applications

appicons.path = /usr/share/icons/hicolor
appicons.files = appicons/*

sounds.files = sounds
sounds.path = $${DEPLOYMENT_PATH}

files.files = files
files.path = $${DEPLOYMENT_PATH}

lupdate_only{
SOURCES = \
    ../qml/harbour-thakir_prayer_times.qml \
    ../qml/pages/Adjust.qml \
    ../qml/pages/About.qml \
    ../qml/pages/City.qml \
    ../qml/pages/Coord.qml \
    ../qml/pages/Pays.qml \
    ../qml/pages/Regions.qml \
    ../qml/pages/State.qml \
    ../qml/pages/PrayerTimes.qml \
    ../qml/pages/SettingsLocation.qml \
    ../qml/pages/AlertSettings.qml \
    ../qml/pages/ActiveSilent.qml \
    ../qml/pages/Athkar.qml \
    ../qml/pages/AdhanSelectDialog.qml \
    ../qml/pages/Quibla.qml \
    ../qml/pages/Favorites.qml \
    ../qml/cover/CoverPage.qml \
    ../qml/pages/components/ProgressBar.qml \
    ../qml/pages/Souwar.qml \
    ../qml/pages/Ayat.qml \
    ../qml/pages/DownloadSura.qml \
    ../qml/pages/Settings-Quran.qml
}

CONFIG += sailfishapp_i18n C++99
TRANSLATIONS = translations/en_GB.ts \
    translations/fr.ts \
    translations/tr.ts \
    translations/ar.ts

translations.files = translations
translations.path = $${DEPLOYMENT_PATH}

OTHER_FILES += qml/pages/*.qml \
    qml/cover/*.qml \
    qml/pages/*.js \
    qml/pages/*.xml \
    qml/pages/xml/*.xml \
    qml/pages/fonts/*.ttf \
    qml/pages/fonts/*.otf \
    rpm/harbour-thakir_prayer_times.spec \
    rpm/harbour-thakir_prayer_times.yaml \
    rpm/harbour-thakir_prayer_times.changes

INSTALLS += desktop appicons qml sounds translations files

TEMPLATE = subdirs
SUBDIRS = src

DISTFILES += \
    qml/pages/SettingsLocation.qml \
    qml/pages/AdhanSelectDialog.qml \
    rpm/harbour-thakir_prayer_times.changes \
    qml/pages/Quibla.qml \
    qml/pages/AlertSettings.qml

