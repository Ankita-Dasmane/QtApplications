import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 2.15
Page{
    id:additem
    width: parent ? parent.width : 640  // Default width if no parent
    height: parent ? parent.height : 480
    signal productAdded(string name,string price)
    Rectangle {
        y:10
        height: 60
        color:"#C4E538"
        RowLayout
        {
            spacing: 200
            ToolButton {  //back
                icon.source: "qrc:/images/line-angle-left-icon.svg"
                onClicked: {
                    stackview.pop("addproduct.qml");
                }
            }
            Button
            {
                id:b1
                enabled: pname.text !== "" && pprice.text !== ""
                onClicked: {
                    console.log("Name:",pname.text,"Price:",pprice.text);
                    console.log("Item saved successfully");
                    db.addProduct(pname.text,pprice.text,description.text);
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
    Column
    {
        spacing: 20
        anchors.horizontalCenter: parent.horizontalCenter
        rightPadding: 20
        topPadding: 60
        leftPadding: 20
        Label {
            id: t1
            text: qsTr("Add Product")
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
            text: qsTr("Note: Enter all field that marked star")
            font.pointSize: 12
        }
    }
}
