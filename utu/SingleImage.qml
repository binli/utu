import QtQuick 2.4

Image {
    id:image

    property bool loading:status != Image.Ready

    Image {
        id: container
        property bool on: false
        source: "images/spinner.png";
        visible: loading
        anchors.centerIn:parent
        NumberAnimation on rotation {
            running: loading ; from: 0; to: 360;
            loops: Animation.Infinite; duration: 2000
        }
    }
}
