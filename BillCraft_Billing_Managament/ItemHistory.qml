import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.Controls.Material 2.15

Page {
    id: itempage
    property int itemID
    property int itemTotal
    property date itemDate
    property var listItem: ListModel {}

    Component.onCompleted: {
        var itemData = db.getExportItems(itemID);
        listItem.clear();  // clear old items if any
        for (var i = 0; i < itemData.length; i++) {
            listItem.append(itemData[i]);
        }
        console.log("📦 Loaded Items for ID", itemID, ":", JSON.stringify(itemData));
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10
        RowLayout {
            spacing: 10
            ToolButton {
                icon.source: "qrc:/images/line-angle-left-icon.svg"
                onClicked: stackview.pop()
            }
            Label {
                text: "Details"
                font.pointSize: 20
                font.bold: true
                color: "black"
            }
        }
        ColumnLayout {
            spacing: 5
            Label {
                text: " Date: "+ Qt.formatDate(itemDate, "yyyy-MM-dd")//itemDate
                font.pointSize: 16
                font.bold: true
            }
            Label {
                text: " Total: "+itemTotal
                font.pointSize: 16
                font.bold: true
            }
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 8
            color: "#f0f0f0"
            border.color: "#ccc"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10
                RowLayout {
                    spacing: 10
                    Layout.fillWidth: true

                    Label { text: "Item"; Layout.preferredWidth: 100; font.bold: true;font.pointSize: 16}
                    Label { text: "Price"; Layout.preferredWidth: 60; font.bold: true;font.pointSize: 16 }
                    Label { text: "Qty"; Layout.preferredWidth: 40; font.bold: true ;font.pointSize: 16}
                    Label { text: "Total"; Layout.preferredWidth: 60; font.bold: true;font.pointSize: 16}
                }
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: 5
                    model: listItem

                    delegate: RowLayout {
                        spacing: 10
                        Layout.fillWidth: true
                        Label { text: model.name; font.pointSize: 14;Layout.preferredWidth: 100 }
                        Label { text: model.price; font.pointSize: 14;Layout.preferredWidth: 60}
                        Label { text: model.quantity; font.pointSize: 14;Layout.preferredWidth: 40}
                        Label { text: model.total; font.pointSize: 14;Layout.preferredWidth: 60}

                    }
                }
            }
        }
    }
}
