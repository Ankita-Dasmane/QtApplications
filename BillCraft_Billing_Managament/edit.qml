import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 2.15
Page {
    id:editpage
    property string productName: ""
    property string productPrice: ""
    signal productUpdated(string newName, string newPrice)

    Rectangle{
        y:10
        height: 60
        color:"#C4E538"
        Component.onCompleted: {
            console.log("\n(edit.qml)Received product name :",productName);
            var details=db.getProductDetails(productName);
            pname.text=details.name;
            pprice.text=details.price;
            description.text=details.description;
        }

        RowLayout
        {
            spacing: 200
            ToolButton {
                icon.source: "qrc:/images/line-angle-left-icon.svg"
                onClicked: {
                    stackview.pop();
                }
            }
            Button  //save
            {
                id:b1
                enabled: pname.text !== "" && pprice.text !== ""
                onClicked: {
                    console.log("Name:",pname.text,"Price:",pprice.text);
                    console.log("Item saved successfully");
                    db.updateProduct(productName,pname.text,pprice.text,description.text);//********upadeteproduct
                    stackview.pop();
                    stackview.pop();
                    stackview.push("adminpage.qml");
                }
                contentItem: Text {
                    text: "Save"
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
                    color:  b1.enabled ? "#C4E538" : "transparent"
                    border.color:"black"
                    border.width: 1
                    radius: 6
                }
            }
        }
    }
    Column    {
        spacing: 20
        anchors.horizontalCenter: parent.horizontalCenter
        rightPadding: 20
        topPadding: 60
        leftPadding: 20
        Label {
            id: t1
            text: qsTr("Edit Product")
            font.pointSize: 30
            font.bold: true
        }

        TextField{
            id:pname
            width: 280
            height: 40
            placeholderText: "Product Name*"
            verticalAlignment: Text.AlignVCenter
            placeholderTextColor: "black"
            font.pointSize: 16
        }
        TextField{
            id:pprice
            width: 280
            height: 40
            placeholderText: "Product Price*"
            verticalAlignment: Text.AlignVCenter
            placeholderTextColor: "black"
            font.pointSize: 16
        }
        TextField{
            id:description
            width: 280
            height: 80
            placeholderText: "Description"
            verticalAlignment: Text.AlignVCenter
            placeholderTextColor: "black"
            font.pointSize: 16
        }
        Text {
            text: qsTr("Note: Enter all star field")
            font.pointSize: 12
        }
        Button{
            height: 80;width: 80

            icon.source:"qrc:/images/trash-solid.svg"
            onClicked:{
                console.log("Delete icon clicked");
                delDialog.open();
            }
        }
    }
    Dialog{
        id:delDialog
        modal: true
        title: "Alert!"
        standardButtons: Dialog.No | Dialog.Yes
        anchors.centerIn: parent
        width: 300
        height: 200
        contentItem: Column {
            spacing: 10
            width: parent.width
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
            if (db.deleteProduct(productName))
            {
                stackview.pop();
                console.log("\nDeleting contact(view.qml [delete dialog]):", contactNumber);
            } else {
                console.log("\nFailed to delete contact!(view.qml)");
            }
        }
    }

}
