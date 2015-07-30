TEMPLATE = app
TARGET = utu

load(ubuntu-click)

QT += qml quick

SOURCES += main.cpp \
    ImageProcessor.cpp

RESOURCES += utu.qrc

QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true)

CONF_FILES +=  utu.apparmor \
               utu.desktop \
               utu.png

AP_TEST_FILES += tests/autopilot/run \
                 $$files(tests/*.py,true)

#show all the files in QtCreator
OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               $${AP_TEST_FILES} \
    DetailedImage.qml \
    SingleImage.qml \
    UtuListView.qml \
    images/list.png

#specify where the config files are installed to
config_files.path = /utu
config_files.files += $${CONF_FILES}
INSTALLS+=config_files

# Default rules for deployment.
target.path = $${UBUNTU_CLICK_BINARY_PATH}
INSTALLS+=target

HEADERS += \
    ImageProcessor.h

