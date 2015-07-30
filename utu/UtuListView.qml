import QtQuick 2.4
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0
import QtQuick.XmlListModel 2.0
import UtuImageProcessor 1.0
import Ubuntu.DownloadManager 0.1

Item {
    id: mainScreen

    XmlListModel {
        id: feedModel

        //     source: "http://api.flickr.com/services/feeds/photos_public.gne?format=rss2"
        source: "http://api.flickr.com/services/feeds/photos_public.gne?format=rss2&tags=" + escape(input.text)
        query: "/rss/channel/item"  // flickr
        namespaceDeclarations:  "declare namespace media=\"http://search.yahoo.com/mrss/\";"

        // Flickr
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "imagePath"; query: "media:thumbnail/@url/string()" }
        XmlRole { name: "photoAuthor"; query: "author/string()" }
        XmlRole { name: "photoCredit"; query: "media:credit/string()" }
        XmlRole { name: "photoDate"; query: "pubDate/string()" }

        XmlRole { name: "url"; query: "media:content/@url/string()" }
        XmlRole { name: "description"; query: "description/string()" }
        XmlRole { name: "tags"; query: "media:category/string()" }
        XmlRole { name: "photoWidth"; query: "media:content/@width/string()" }
        XmlRole { name: "photoHeight"; query: "media:content/@height/string()" }
        XmlRole { name: "photoType"; query: "media:content/@type/string()" }
    }

    SingleDownload {
        id: single

        onFinished: {
            viewscreen.image_path = path
            console.log ("path" + viewscreen.image_path)
        }
    }

    Component {
        id: listDelegate
        BorderImage {
            source: "images/list.png"
            border { top:4; left:4; right:100; bottom: 4 }
            anchors.right: parent.right
            // width: mainScreen.width
            width: ListView.view.width
            height: 160

            property int fontSize: 25

            Rectangle {
                id: imageId
                x: 6; y: 4; width: parent.height - 10; height:width; color: "white"; smooth: true
                anchors.verticalCenter: parent.verticalCenter

                SingleImage {
                    source: imagePath; x: 0; y: 0
                    height:parent.height
                    width:parent.width
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Text {
                x: imageId.width + 20
                y: 15
                width: mainScreen.width - x - 40
                text: title; color: "red"
                font { pixelSize: fontSize; bold: true }
                elide: Text.ElideRight; style: Text.Raised; styleColor: "yellow"
            }

            Text {
                x: imageId.width + 20
                y: 45
                width: mainScreen.width - x - 40
                text: photoCredit; color: "purple"
                font { pixelSize: fontSize; bold: true }
                elide: Text.ElideLeft; style: Text.Raised; styleColor: "yellow"
            }



            MouseArea {
                anchors.fill: parent
                onClicked: {
                    //viewcontainer.x -= mainScreen.width
                    //viewscreen.source = imagePath.replace("_s", "_b")
                    // the url is the bigger size image.
                    viewscreen.source = url
                    mainScreen.state = "view"
                    //single.download(url);
                }
            }
        }
    }

    states: [
        State {
            name: "view"
            PropertyChanges {
                target: viewcontainer
                x:-mainScreen.width
            }
            PropertyChanges {
                target: backbutton
                opacity:1
            }
            PropertyChanges {
                target: rm_color_button
                opacity:1
            }
            PropertyChanges {
                target: ng_color_button
                opacity:1
            }
            PropertyChanges {
                target: bg_color_button
                opacity:1
            }
            PropertyChanges {
                target: em_color_button
                opacity:1
            }
            PropertyChanges {
                target: d_button
                opacity:1
            }
            PropertyChanges {
                target: inputcontainer
                opacity:0
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation { target: viewcontainer; property: "x"; duration: 500
                easing.type:Easing.OutSine}
            NumberAnimation { target: inputcontainer; property: "opacity"; duration: 200}
            NumberAnimation { target: backbutton; property: "opacity"; duration: 200}
            NumberAnimation { target: rm_color_button; property: "opacity"; duration: 200}
            NumberAnimation { target: ng_color_button; property: "opacity"; duration: 200}
            NumberAnimation { target: bg_color_button; property: "opacity"; duration: 200}
            NumberAnimation { target: em_color_button; property: "opacity"; duration: 200}
            NumberAnimation { target: d_button; property: "opacity"; duration: 200}
        }
    ]

    Row {
        id:viewcontainer

        UbuntuListView {
            id: listView
            width: mainScreen.width
            height:mainScreen.height - toolbar.height

            model: feedModel
            delegate: listDelegate

            // let refresh control know when the refresh gets completed
            PullToRefresh {
                refreshing: listView.model.status === XmlListModel.Loading
                onRefresh: listView.model.reload()
            }

            Scrollbar {
                flickableItem: listView
            }
        }

        DetailedImage {
            id:viewscreen
            clip:true
            width:mainScreen.width
            height:mainScreen.height - toolbar.height
            smooth:true
            fillMode:Image.PreserveAspectFit
            property var image_path: ""
            property var new_image_path: ""

            onSwipeRight: {
                onClicked: mainScreen.state=""
            }
        }
    }

    BorderImage {
        id:toolbar

        anchors.bottom:parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        width: parent.width
        height: units.gu(6)

        source: "images/toolbar.png"
        border.left: 4; border.top: 4
        border.right: 4; border.bottom: 4

        ImageProcessor {
            id: processor;
            onFinished: {
                viewscreen.new_image_path = "file:"+ newFile
                viewscreen.source = viewscreen.new_image_path
                console.log ("prepare to process new_image_path:" + viewscreen.new_image_path)
            }
        }

        Row {
            id:inputcontainer
            anchors.centerIn:toolbar
            anchors.verticalCenterOffset:6
            spacing:12
            Text {
                id:label
                font.pixelSize:30
                anchors.verticalCenter:parent.verticalCenter;
                text: i18n.tr("Search:")
                font.bold:true
                style:Text.Raised
                styleColor:"#fff"
                color:"#444"
            }

            TextField {
                id:input
                placeholderText: "Please input a text to search:"
                width:220
                text:"gnome.asia"
            }
        }

        Image {
            id: backbutton
            opacity:0
            source: "images/back.png"
            height: 50
            width: 50
            anchors.verticalCenter:parent.verticalCenter
            anchors.verticalCenterOffset:0
            anchors.left:parent.left
            anchors.leftMargin:8

            MouseArea{
                anchors.fill:parent
                onClicked: mainScreen.state=""
                scale:1
            }
        }

        Image {
            id: rm_color_button
            opacity:0
            source: "images/rm-color.png"
            height: 50
            width: 50
            anchors.verticalCenter:parent.verticalCenter
            anchors.verticalCenterOffset:0
            anchors.left:parent.left
            anchors.leftMargin:100

            MouseArea{
                anchors.fill:parent
                onClicked:{
                    //mainScreen.state=""
                    //processor.process(viewscreen.source, ImageProcessor.Gray);
                    processor.process("a.jpg", ImageProcessor.Gray);
                    console.log ("prepare to process Gray")
                }
                scale:1
            }
        }

        Image {
            id: ng_color_button
            opacity:0
            source: "images/face-crying.png"
            height: 50
            width: 50
            anchors.verticalCenter:parent.verticalCenter
            anchors.verticalCenterOffset:0
            anchors.left:parent.left
            anchors.leftMargin:190

            MouseArea{
                anchors.fill:parent
                onClicked:{
                    processor.process("a.jpg", ImageProcessor.Negative);
                    console.log ("prepare to process Negative")
                }
                scale:1
            }
        }

        Image {
            id: bg_color_button
            opacity:0
            source: "images/face-crying.png"
            height: 50
            width: 50
            anchors.verticalCenter:parent.verticalCenter
            anchors.verticalCenterOffset:0
            anchors.left:parent.left
            anchors.leftMargin:280

            MouseArea{
                anchors.fill:parent
                onClicked:{
                    processor.process("a.jpg", ImageProcessor.Binarize);
                    console.log ("prepare to process Negative")
                }
                scale:1
            }
        }

        Image {
            id: em_color_button
            opacity:0
            source: "images/face-crying.png"
            height: 50
            width: 50
            anchors.verticalCenter:parent.verticalCenter
            anchors.verticalCenterOffset:0
            anchors.left:parent.left
            anchors.leftMargin:370

            MouseArea{
                anchors.fill:parent
                onClicked:{
                    processor.process("a.jpg", ImageProcessor.Soften);
                    console.log ("prepare to process Negative")
                }
                scale:1
            }
        }

        Image {
            id: d_button
            opacity:0
            source: "images/rm-color.png"
            height: 50
            width: 50
            anchors.verticalCenter:parent.verticalCenter
            anchors.verticalCenterOffset:0
            anchors.left:parent.left
            anchors.leftMargin:460

            MouseArea{
                anchors.fill:parent
                onClicked:{
                    var a = viewscreen.grabToImage(function(result) {
                        result.saveToFile("a.jpg");
                    }, Qt.size(viewscreen.width, viewscreen.height) );
                }
                scale:1
            }
        }
    }

}
