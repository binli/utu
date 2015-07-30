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

    // Create the detection of swipe
    signal swipeRight;
    signal swipeLeft;
    signal swipeUp;
    signal swipeDown;

    MouseArea {
        anchors.fill: parent
        property int startX;
        property int startY;

        onPressed: {
            startX = mouse.x;
            startY = mouse.y;
        }

        onReleased: {
            var deltax = mouse.x - startX;
            var deltay = mouse.y - startY;

            if (Math.abs(deltax) > 50 || Math.abs(deltay) > 50) {
                if (deltax > 30 && Math.abs(deltay) < 30) {
                    // swipe right
                    swipeRight();
                } else if (deltax < -30 && Math.abs(deltay) < 30) {
                    // swipe left
                    swipeLeft();
                } else if (Math.abs(deltax) < 30 && deltay > 30) {
                    // swipe down
                    swipeDown();
                } else if (Math.abs(deltax) < 30 && deltay < 30) {
                    // swipe up
                    swipeUp();
                }
            }
        }
    }
}
