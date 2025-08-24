import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.Controls.Material 2.15
//import QtQuick.Dialogs 2.15  // Required for MessageDialog


ApplicationWindow
{
    id:root
    width:360
    height: 640
    visible: true
    title: qsTr("Billing Project")
     function help(){
        Qt.openUrlExternally("https://projectgurukul.org/java-supermarket-billing-system/")
    }
    header: ToolBar
    {
        height: 50
        width: parent.width
        visible: stackview.depth===1
        background: Rectangle
        {
            color: "#C4E538"
            anchors.fill: parent
        }
        RowLayout
        {
            spacing: 20
            anchors.fill: parent
            ToolButton
            {   //text: "Menu"
                onClicked: optionsMenu.open()
                icon.source: "qrc:/images/bars-solid.svg"
                Menu
                {
                    id: optionsMenu
                    transformOrigin: Menu.TopLeft
                    Action
                    {
                        //icon.source: "qrc:/images/bars-solid.svg"
                        text: qsTr("Settings" )
                        onTriggered: settingDialog.open()
                    }
                    MenuItem {
                        text:qsTr("About")
                        onTriggered: aboutDialog.open()
                    }
                    Action{
                        text: qsTr("Help" )
                        onTriggered: root.help()
                    }
                }
            }
            Label
            {
                text: "Welcome"
                font.pixelSize: 20
                font.bold: true
                color: "black"
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
    Component
    {
        id:mainpage
        Column
    {
        width: parent.width
        spacing: 10
        rightPadding: 10
        leftPadding: 10
        Image {
            id: img1
            //source: "file:///I:/D drive/Ankita/QT FILES/Project1/p1.jpeg"
            source: "file:///I:/D drive/Ankita/QT FILES/Billing_Managament/images/p1.jpeg"

            width:100;height: 200
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Label{
            horizontalAlignment: "AlignHCenter"
            width: parent.width
            Layout.fillWidth: true
            text: "Welcome to the Billing System of Soham Electric Services"
            font.bold: true
            font.pointSize: 16
            wrapMode: Label.Wrap
            color: "#C4E538"
        }
        Text {
            id: t1
            text: qsTr("Login Credential")
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 20
            font.bold: true
        }

        TextField{
            id:username
            width:280
            height: 40
            placeholderText: " User Name "
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 14
            focus: true
            placeholderTextColor: "black"
        }
        TextField{
            id:password
            width:280
            height: 40
            echoMode: TextInput.Password
            anchors.horizontalCenter: parent.horizontalCenter
            placeholderText: " Password"
            font.pixelSize: 14
            placeholderTextColor: "black"
        }

        RowLayout
        {
            spacing: 80
            anchors.horizontalCenter: parent.horizontalCenter
            Button
            {
                id:b1
                enabled: username.text !== "" && password.text !== ""
                contentItem: Text {
                    text: "Login"
                    font.pointSize: 12
                    opacity: enabled ? 1.0 : 0.3
                    color:"black"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 35
                    opacity: enabled ? 1 : 0.3
                    color: "#C4E538"
                    border.color:"black"
                    border.width: 1
                    radius: 8
                }
                onClicked:
                {
                    const uname = username.text.trim();
                       const pwd = password.text.trim();
                       let role = db.checkLogin(uname, pwd);
                       console.log("Login result:", role);
                    // let role = db.checkLogin(username.text, password.text)
                    // console.log("Login result:", role);

                    let result = db.checkLogin(username.text, password.text)
                           console.log("Login result:", result)

                           if (result === "admin") {
                               stackview.push("adminpage.qml")
                           } else if (result === "user") {
                               stackview.push("userpage.qml")
                           } else {
                               wrongbox.open()
                           }
                     password.clear();
                }
            }

            Button{
                id:b2
                contentItem: Text {
                    text: "Forgot ?"
                    font.pointSize: 12
                    opacity: enabled ? 1.0 : 0.3
                    color: "black"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 40
                    opacity: enabled ? 1 : 0.3
                    color: "#C4E538"
                    border.color:"black"
                    border.width: 1
                    radius: 8
                }
                onClicked: {
                    var adminNumbers = db.getLoginDataByRole("admin", "number");
                    console.log(adminNumbers);
                    if (adminNumbers.length > 0) {
                        var phone = adminNumbers[0]
                        console.log("Admin Contact:", phone)
                        forgetbox.phoneNumber = phone
                        forgetbox.open()
                    }

                    forgetbox.open();
                    console.log("Forget button clicked...")
                }
            }

        }
    }
    }
    StackView{
        id:stackview
        anchors.fill: parent
        initialItem: mainpage
    }
    footer:Text {
        id: my1
        visible: stackview.depth===1
        height: 50
        text: qsTr("NextGen")
    }
    Dialog{
        id:settingDialog
        modal: true
        title: "Settings"
        standardButtons: Dialog.Ok
        anchors.centerIn: parent
        width: 300
        contentItem: Column {
            spacing: 10
            width: parent.width
            Text {
                text: "This is settings Dialog"
                font.bold: true
                font.pixelSize: 16
                color: "#C4E538"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

    }
    Dialog{
        id:aboutDialog
        modal: true
        title: "ALERT!"
        standardButtons: Dialog.Ok
        anchors.centerIn: parent
        width: 300
        contentItem: Column {
            spacing: 10
            width: parent.width
            Text {
                text: "This is about dialogue"
                font.bold: true
                font.pixelSize: 16
                color: "orange"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
    Dialog{
        id:forgetbox
        modal: true
        title: "ALERT!"
        standardButtons: Dialog.Ok
        anchors.centerIn: parent
        width: 300
        property string phoneNumber: ""
        contentItem: Column {
            spacing: 10
            width: parent.width
            Text {
                text: "Contact Admin\nPhone Number:9326668635"//+db.logingdb.number()
                font.bold: true
                font.pixelSize: 16
                color: "#C4E538"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Dialog{
        id:wrongbox
        modal: true
        title: "Alert!"
        standardButtons: Dialog.Ok
        anchors.centerIn: parent
        width: 300
        contentItem: Column {
            spacing: 10
            width: parent.width
            Text {
                text: "Wrong Credentials"
                font.bold: true
                font.pixelSize: 16
                color: "red"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Rectangle {
        id: messageBox
        width: parent.width
        height: 40
        color: "#C4E538"
        radius: 5
        anchors.bottom: parent.bottom
        opacity: 0 // Initially hidden
        Text {
            anchors.centerIn: parent
            text: "Successfully Pdf is downloaded."
            color: "black"
        }
        Behavior on opacity {
            NumberAnimation { duration: 300 }
        }
    }
    function showSuccessMessage() {
        messageBox.opacity = 1;
        messageBox.visible = true;
        // Hide after 3 seconds
        messageBoxTimer.start();
    }
    Timer {
        id: messageBoxTimer
        interval: 1000 // 1 seconds
        onTriggered: messageBox.opacity = 0
    }

}
