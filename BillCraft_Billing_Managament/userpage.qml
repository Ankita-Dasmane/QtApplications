import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.Controls.Material 2.15
Page
{
    id:user
    ColumnLayout {
        anchors.fill: parent
        Rectangle
        {
            Layout.fillWidth: true
            height: 50
            color: "#C4E538"
            RowLayout{
                anchors.fill: parent
                Layout.rightMargin: 10
                Label {
                    text: "  User"
                    font.pixelSize: 20
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
                            text: qsTr("Logout" )
                            onTriggered: stackview.pop()
                        }
                        Action{
                            text: qsTr("Help")
                            onTriggered: Qt.openUrlExternally("https://projectgurukul.org/java-supermarket-billing-system/")
                        }
                        Action{
                            text: qsTr("About")
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
                id: contactList
                anchors.fill: parent
                model: db.getProducts()
                spacing: 10
                clip: true
                delegate: Rectangle{
                    width: parent.width
                    height: 80
                    color: index % 2 === 0 ? "#dfe6e9" : "#b2bec3"
                    border.color: "black"
                    radius: 8
                    Column{
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
                }
            }
            RoundButton{
                id: selectitem
                width: 60
                height: 60
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: 20
                icon.source: "qrc:/images/check-mark-box-icon.svg"
                onClicked: {
                    stackview.push("selectpage.qml");
                }
            }
        }

    }
}
