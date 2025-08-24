import QtQuick.Dialogs 6.2
import QtQuick 2.15
import QtQuick.Layouts 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
Page
{
    id:page2
    property string contactNumber: "" // This should be set when navigating to this page
    property int fav:0
    property int blc:0
    Component.onCompleted: {
        console.log("\nReceived contact number in view.qml:", contactNumber);
        var contactDetails = db.getContactDetails(contactNumber);
        tf1.text = contactDetails.firstname;
        tf2.text = contactDetails.lastname;
        tf7.text = contactDetails.number;
        tf3.text = contactDetails.email;
        tf4.text = contactDetails.address;
        tf5.text = contactDetails.birthday;
        tf6.text = contactDetails.note;
        fav=contactDetails.is_favorite;
        blc=contactDetails.is_blocked;
    }
    Column
    {
        spacing: 15
        anchors.horizontalCenter: parent.horizontalCenter
        padding: 10
        topPadding: 10
        bottomPadding: 10
        RowLayout{
        spacing:50
        Text {
            id: t1
            text: qsTr("Information")
            font.pointSize: 18
        }
        Button{
            id:b2//back button
            contentItem: Text
            {
                text: "Back"
                font.pointSize: 14
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
                stackView.pop();
                console.log("\nBack button clicked...")
            }
        }
}
        TextField{
            id:tf1
            width:280
            height: 40
            placeholderText: " First Name *"
            verticalAlignment: Text.AlignVCenter
            placeholderTextColor: "black"
            font.pixelSize: 14
            readOnly: true
        }
        TextField{
            id:tf2
            width:280
            height: 40
            placeholderText: " Last Name *"
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 14
            placeholderTextColor: "black"
            readOnly: true
        }
        TextField{
            id:tf7
            width:280
            height: 40
            placeholderText: " Number *"
            verticalAlignment: Text.AlignVCenter
            placeholderTextColor: "black"
            font.pixelSize: 14
            readOnly: true
        }

        TextField{
            width:280
            height: 40
            id:tf3
            placeholderText: qsTr(" Email")
            //anchors.fill: horizontalCenter
            font.pointSize: 14
            placeholderTextColor:"black"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            readOnly: true
        }
        TextField{
            width:280
            height: 40
            id:tf4
            placeholderText: qsTr(" Address")
            //anchors.fill: horizontalCenter
            font.pointSize: 14
            placeholderTextColor:"black"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            readOnly: true
        }
        TextField{
            width:280
            height: 40
            id:tf5
            placeholderText: qsTr(" Birthday")
            //anchors.fill: horizontalCenter
            font.pointSize: 14
            placeholderTextColor:"black"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            readOnly: true
        }
        TextField {
            id:tf6
            height: 80; width:280
            placeholderText: "Note"
            text: "Note"
            font.pointSize: 14
            color: "black"
            placeholderTextColor: "black"
            readOnly: true
        }
        ColumnLayout{
            spacing: 5
            RowLayout
            {
                spacing: 20
                Button{
                    id:b3//Edit button
                    contentItem: Text {
                        text: "✏️ Edit"
                        font.pointSize:12
                        opacity: enabled ? 1.0 : 0.3
                        color: "black"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                    onClicked: {
                        stackView.push("edit.qml", { contactNum: contactNumber });
                        console.log("\nEdit button clicked...")
                    }
                }
                Button{
                    id:b4//star Button
                    contentItem: Text {
                        text: "⭐ Favorites"
                        font.pointSize: 12
                        opacity: enabled ? 1.0 : 0.3
                        color: "black"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                    onClicked: {
                        if(fav===0)
                        {    fav=1;
                            console.log("\nAdded to favorites",fav);
                            successPopup1.open();
                            popupTimer1.start()
                        }
                        else{
                            console.log("\nRemoved from favorites",fav);
                            successPopup2.open();
                            popupTimer2.start();
                        }
                        db.isModified(contactNumber,fav,blc);
                    }
                }
            }
            RowLayout
            {
                spacing: 20
                Button{
                    id:b7//delete button
                    //width:
                    contentItem: Text {
                        text: "Delete"
                        font.pointSize: 12
                        opacity: enabled ? 1.0 : 0.3
                        color: "black"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                    onClicked: {
                        num_del.open();//handle this
                    }
                }

                Button
                {
                    id:b5 //block button
                    contentItem: Text {
                        text: "🚫 Block Number"
                        font.pointSize: 12
                        opacity: enabled ? 1.0 : 0.3
                        color: "black"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                    onClicked: {
                        //stackView.pop("add.qml");
                        block.open();
                        console.log("\nBlock button clicked...");

                    }
                }
            }
        }


    }
    Dialog {
        id: block
        modal: true
        title: "Confirm Block"
        standardButtons: Dialog.No | Dialog.Yes
        anchors.centerIn: parent
        width: 300  // ✅ Limits the Dialog width
        height: 200  // ✅ Set a reasonable height if needed

        contentItem: Column {
            spacing: 10
            width: parent.width  // ✅ Prevents implicitWidth loop

            Text {
                text: "Do you really want to block this number?\nBlocking this number will prevent all future communications."
                font.bold: true
                font.pixelSize: 14
                color: "red"
                wrapMode: Text.WordWrap  // ✅ Ensures text stays inside Dialog
                width: parent.width - 20  // ✅ Adjust width slightly smaller than Dialog
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        onAccepted :{
            if(blc===0)
            {
              blc=1;
              console.log("\nBlock (1/0)",blc);
            }
            else
            {
                console.log("\nBlock (1/0)",blc);
            }

            db.isModified(contactNumber,fav,blc);
        }

    }

    Dialog{
        //delete
        id:num_del
        modal: true
        title: "Alert!"
        standardButtons: Dialog.No | Dialog.Yes
        anchors.centerIn: parent
        width: 300// ✅ Set a fixed or reasonable width to prevent binding loops
        height: 200
        contentItem: Column {
            spacing: 10
            width: parent.width  // ✅ Ensures no implicitWidth loop
            Text {
                text: "Are you sure you want to delete this contact? This action cannot be undone."
                font.bold: true
                font.pixelSize: 16
                color: "red"
                wrapMode: Text.WordWrap
                width: parent.width-20
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        onAccepted: {
            console.log("\nDelete message");
            if (db.deleteUser(contactNumber))
            {
                window.showDeleteMessage();
                stackView.pop("view.qml");
                window.contacts = db.getContacts(); // Navigate back after deletion
                console.log("\nDeleting contact(view.qml [delete dialog]):", contactNumber);
            } else {
                console.log("\nFailed to delete contact!(view.qml)");
            }
        }
    }

    Popup
    {   // for star Button
        id: successPopup1
        width: parent.width
        height: 50
        modal: false
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside// Position at the bottom using y instead of anchors.bottom
        y: parent.height - height - 10  // 10px margin from bottom
        background: Rectangle {
            color: "yellow"
            radius: 5
        }
        Text {
            anchors.centerIn: parent
            text: "Added to favorite!"
            color: "black"
            font.pointSize: 12
            font.bold: true
        }
        Timer {
            id: popupTimer1
            interval: 1000
            onTriggered: successPopup1.close()
        }
    }
    Popup{
        // for star Button
               id: successPopup2
               width: parent.width
               height: 50
               modal: false
               closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside// Position at the bottom using y instead of anchors.bottom
               y: parent.height - height - 10  // 10px margin from bottom
               background: Rectangle {
                   color: "yellow"
                   radius: 5
               }
               Text {
                   anchors.centerIn: parent
                   text: "Removed to favorite!"
                   color: "black"
                   font.pointSize: 12
                   font.bold: true
               }
               Timer {
                   id: popupTimer2
                   interval: 1000
                   onTriggered: successPopup2.close()
               }
    }
}

