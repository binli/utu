import QtQuick 2.4
import Ubuntu.Components 1.1


/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "utu.binli"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false
    anchorToKeyboard: true

    width: units.gu(100)
    height: units.gu(200)

    Page {
        id:mainPage
        title: i18n.tr("utu")
        clip:true

        UtuListView {
            anchors.fill:parent
        }
    }
}

