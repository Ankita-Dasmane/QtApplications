import QtCore
import QtQuick 2.15
import QtQuick.Layouts  2.15
import QtQuick.Controls 2.15
//import QtQuick.Dialogs 2.15

ApplicationWindow {
    id:window
    visible: true
    width: 360
    height: 640
    title: "Contacts App"
    color: "white"
    property var contacts: db.getContacts()
    function help() {
        let url = "https://wiki.qt.io/Qt_for_Beginners";
        Qt.openUrlExternally(url)
    }

    Action {
        id: navigateBackAction
        onTriggered: {
            console.log("Search Button Clicked.....")
            stackView.push("search.qml");
        }
    }
    header: ToolBar
    {
        height: 50
        width: parent.width
        visible: stackView.depth===1
        background: Rectangle
        {
            color: "yellow"
            anchors.fill: parent
        }
        RowLayout
        {
            spacing: 20
            anchors.fill: parent
            ToolButton
            {
                text: "Menu"
                onClicked: optionsMenu.open()
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: 12
                    color: "black"
                }
                background: Rectangle {
                    color: "transparent"
                }
                Menu
                {
                    id: optionsMenu
                    transformOrigin: Menu.TopLeft
                    Action
                    {
                        text: qsTr("Settings" )
                        onTriggered: settingsDialog.open()
                    }
                    MenuItem {
                        text:qsTr("About")
                        onTriggered: aboutDialog.open()
                    }
                    Action{
                        text: qsTr("Help" )
                        onTriggered: window.help()
                    }
                }
            }
            Label
            {
                text: "Contacts"
                font.pixelSize: 20
                font.bold: true
                color: "black"
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }
            ToolButton
            {
                text: "Search"
                action:navigateBackAction
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: 12
                    color: "black"
                }
                background: Rectangle {
                    color: "transparent"
                }
            }
        }
    }
    StackView
    {
        id:stackView
        anchors.fill:parent
        initialItem: Pane
        {
            id:pane
            ScrollView
            {
                anchors.fill: parent
                anchors.margins: 10

                ListView {
                    id: contactList
                    anchors.fill: parent
                    model: window.contacts //contacts

                    Component.onCompleted: {
                            console.log("\nContacts Model:", JSON.stringify(window.contacts),"\n");//displays th complete db data
                        }

                    delegate: ItemDelegate
                    {
                        width: parent.width
                        height: 60

                        RowLayout {
                            anchors.fill: parent
                            spacing: 15
                            RoundButton {
                                id: contactButton
                                width: 40
                                height:40
                                text: "✓"
                                onClicked: {
                                    console.log("Button clicked for contact:", modelData.firstname, modelData.lastname);
                                    var viewPage = stackView.push("view.qml",{contactNumber:modelData.number});
                                    console.log("Sendig to view.qml-Number:",modelData.number);
                                }
                                background: Rectangle {
                                    color: "yellow"
                                    radius: width / 2
                                    border.color: "black"
                                    border.width: 1
                                }
                            }
                            Label {
                                text: modelData.firstname + " " + modelData.lastname + "\n" + modelData.number
                                font.pointSize: 14
                                Layout.fillWidth: true
                            }
                        }
                    }
                }
            }
                RoundButton {
                    id: addButton
                    width: 60
                    height: 60
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.margins: 20
                    contentItem: Text {
                        text:"+"
                        font.bold: true
                        font.pointSize:40
                        color: "black"
                        font.pixelSize: 24
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        color: "yellow"
                        radius: width / 2
                        border.color: "black"
                        border.width: 2
                    }
                    onClicked: {
                        stackView.push("add.qml");
                    }
                }
            }
        }
        Dialog
        {
            id:settingsDialog
            modal:true;
            font.bold: true
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            parent: Overlay.overlay
            standardButtons: Dialog.Ok
            title:"SETTING"
            Text {
                id: t1
                text: "The project is successfully running"
            }
        }
        Dialog {
            id: aboutDialog
            modal:true;
            //id: quitDialog
            font.bold: true
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            parent: Overlay.overlay
            title: "About"
            ColumnLayout
            {
                id:aboutColumn
                spacing: 20
                Label
                {
                    width: aboutDialog.availableWidth
                    text: qsTr("This is Contact Management System")
                    wrapMode: Label.Wrap
                    font.pointSize: 12
                }
                Label
                {
                    width: aboutDialog.availableWidth
                    text: qsTr("This is Contact MAnagement System")
                    wrapMode: Label.Wrap
                    font.pointSize: 12
                }
            }
        }
        Rectangle {
            id: messageBox1
            width: parent.width
            height: 40
            color: "yellow"
            radius: 5
            anchors.bottom: parent.bottom
            opacity: 0
            Text {
                anchors.centerIn: parent
                text: "Successfully saved!"
                color: "black"
            }
            Behavior on opacity {
                NumberAnimation { duration: 300 }
            }
        }
        function showSuccessMessage() {
            messageBox1.opacity = 1;
            messageBox1.visible = true;
            messageBoxTimer1.start();
        }

        Timer {
            id: messageBoxTimer1
            interval: 1000
            onTriggered: messageBox1.opacity = 0
        }
        Rectangle
        {
            id: messageBox2
            width: parent.width
            height: 40
            color: "yellow"
            radius: 5
            anchors.bottom: parent.bottom
            opacity: 0
            Text {
                anchors.centerIn: parent
                text: "Successfully Deleted!"
                color: "black"
            }
            Behavior on opacity {
                NumberAnimation { duration: 300 }
            }
        }
        function showDeleteMessage(){
            messageBox2.opacity=1;
            messageBox2.visible = true;
            messageBoxTimer2.start();
        }

        Timer
        {
            id:messageBoxTimer2
            interval: 1000
            onTriggered: messageBox2.opacity=0
        }

        Rectangle
        {
            id: messageBox3
            width: parent.width
            height: 40
            color: "yellow"
            radius: 5
            anchors.bottom: parent.bottom
            opacity: 0
            Text {
                anchors.centerIn: parent
                text: "Successfully Updated!"
                color: "black"
            }
            Behavior on opacity {
                NumberAnimation { duration: 300 }
            }
        }
        function showUpdateMessage(){
            messageBox3.opacity=1;
            messageBox3.visible = true;
            messageBoxTimer3.start();
        }

        Timer
        {
            id:messageBoxTimer3
            interval: 1000
            onTriggered: messageBox3.opacity=0
        }


    }
