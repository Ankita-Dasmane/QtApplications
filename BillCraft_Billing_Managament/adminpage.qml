import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.Controls.Material 2.15
Page
{
    id:admin
    ColumnLayout
    {
        anchors.fill: parent
        Rectangle {
            Layout.fillWidth: true
            height: 50
            color: "#C4E538"
            RowLayout{
                anchors.fill: parent
                Label {
                    text: "  Admin"
                    font.pointSize: 20
                    font.bold: true
                    color: "black"
                }
                ToolButton {
                    icon.source: "qrc:/images/user-solid.svg"
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    onClicked: optionsMenu.open()
                    Menu
                    {
                        id: optionsMenu
                        transformOrigin: Menu.TopLeft
                        Action
                        {
                            text: qsTr("Logout")
                            onTriggered: stackview.pop()
                        }
                        MenuItem {
                            text:qsTr("About")
                            //onTriggered: aboutDialog.open()
                        }
                        Action{
                            text: qsTr("Help" )
                            onTriggered: root.help()
                        }
                    }
                }
            }

        }
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "white"
            ListView {
                id: productListView
                anchors.fill: parent
                model: db.getProducts() //--------------------database---------------//
                spacing: 10
                clip: true

                delegate: Rectangle {
                    width: parent.width
                    height: 80
                    color: index % 2 === 0 ? "#dfe6e9" : "#b2bec3"
                    border.color: "black"
                    radius: 8

                    Column {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 5

                        Text {
                            text: "Name: "+modelData.name
                            font.bold: true
                            font.pixelSize: 16
                        }

                        Text {
                            text: "Price: " + modelData.price
                            font.pixelSize: 12
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            console.log("model data:",modelData.name);
                            stackview.push("edit.qml", { productName: modelData.name} );//*******************

                        }
                    }
                }
            }
        }
        Rectangle {
            Layout.fillWidth: true
            height: 60
            color: "#C4E538"
            RowLayout
            {
                spacing: 100
                RoundButton
                {
                    id: addbutton
                    width: 60
                    height: 60
                    icon.source:"qrc:/images/text-document-add-icon.svg"
                    onClicked:
                    {
                        console.log("\nAdd button clicked....");
                        var addpage=stackview.push("addproduct.qml");
                    }
                }
                RoundButton
                {
                    id: pastbutton
                    width: 60
                    height: 60
                    icon.source: "qrc:/images/project-icon.svg"
                    onClicked:
                    {
                        console.log("Clicked on History button\n")
                        stackview.push("history.qml");
                    }
                }
                RoundButton
                {
                    id: settings
                    width: 60
                    height: 60
                    icon.source:"qrc:/images/setting-icon.svg"
                    onClicked:
                    {
                        console.log("\nClicked on settings button");
                        stackview.push("settingspage.qml");
                    }
                }
            }
        }
    }
}
