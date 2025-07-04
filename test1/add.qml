
import QtQuick.Dialogs 6.2
import QtQuick 2.15
import QtQuick.Layouts 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Page {
    id: page1
    signal contactAdded(string firstName, string lastName, string number)
    Column {
        spacing: 20
        anchors.horizontalCenter: parent.horizontalCenter
        rightPadding: 20
        topPadding: 10
        leftPadding: 20
        Text {
            id: t1
            text: qsTr("Create")
            font.pointSize: 20
        }
        TextField{
            id:tf1
            width:280
            height: 40
            placeholderText: " First Name *"
            verticalAlignment: Text.AlignVCenter
            placeholderTextColor: "black"
            font.pixelSize: 16

        }
        TextField{
            id:tf2
            width:280
            height: 40
            placeholderText: " Last Name *"
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 16
            placeholderTextColor: "black"
        }
        TextField{
            id:tf7
            width:280
            height: 40
            placeholderText: " Number *"
            verticalAlignment: Text.AlignVCenter
            placeholderTextColor: "black"
            font.pixelSize: 16
        }
        TextField{
            width:280
            height: 40
            id:tf3
            placeholderText: qsTr(" Email")
            //anchors.fill: horizontalCenter
            font.pointSize: 16
            placeholderTextColor:"black"
            validator: RegularExpressionValidator {
                                regularExpression: /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/
                            }
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        TextField{
            width:280
            height: 40
            id:tf4
            placeholderText: qsTr(" Address")
            //anchors.fill: horizontalCenter
            font.pointSize: 16
            placeholderTextColor:"black"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            /*background: Rectangle
            {
                color:tf4?"yellow":"yellow"
                border.color: "black"
            }*/
        }
        TextField{
            width:280
            height: 40
            id:tf5
            placeholderText: qsTr(" Birthday")
            //anchors.fill: horizontalCenter
            font.pointSize: 16
            placeholderTextColor:"black"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            /*background: Rectangle
            {
                color:tf5?"yellow":"yellow"
                border.color: "black"
            }*/
        }
        TextField{
            id:tf6
            height: 80; width:280
            placeholderText: "Note"
            font.pointSize: 16
            placeholderTextColor: "black"
        }
        RowLayout
        {
            spacing: 80
            Button
            {
                id:b1//save Button
                enabled: tf1.text !== "" && tf2.text !== "" && tf7.text!==""&& (tf3.text === "" || tf3.acceptableInput)
                onClicked: {
                    if(tf7.text.length===10 )
                    {
                        console.log("First Name:",tf1.text,"\nLast Name:",tf2.text,"\nNumber:",tf7.text);
                        db.addContact(tf1.text, tf2.text, tf7.text, tf3.text, tf4.text, tf5.text, tf6.text);
                        window.contacts = db.getContacts();
                        window.showSuccessMessage();
                        stackView.pop("add.qml");
                    }
                    else
                    {
                        console.log("Enter valid number");
                        elsedialog.open();
                    }
                }
                contentItem: Text {
                    text: "Save"
                    font.pointSize: 16
                    opacity: enabled ? 1.0 : 0.3
                    color: b1.down ? "black" : "black"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 40
                    opacity: enabled ? 1 : 0.3
                    color: "yellow"
                    border.color: b1.down ? "black" : "black"
                    border.width: 1
                    radius: 2
                }
            }
            Button{
                id:b2//back button

                contentItem: Text {
                    text: "Back"
                    font.pointSize: 16
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
                    color: "yellow"
                    border.color:"black"
                    border.width: 1
                    radius: 2
                }
                onClicked: {
                    stackView.pop("add.qml");
                    console.log("Back button clicked...")
                }
            }
        }
    }
    Dialog {
        id: elsedialog
        modal: true
        title: "Alert!"
        standardButtons: Dialog.Ok
        anchors.centerIn: parent
        width: 300  // ✅ Set a fixed or reasonable width to prevent binding loops
        contentItem: Column {
            spacing: 10
            width: parent.width  // ✅ Ensures no implicitWidth loop
            Text {
                text: "Invalid Input"
                font.bold: true
                font.pixelSize: 16
                color: "red"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }


}

