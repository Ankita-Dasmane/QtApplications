import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.Controls.Material 2.15

Page {
    id:historypage
    RowLayout
    {
        spacing: 20
        ToolButton {
            icon.source: "qrc:/images/line-angle-left-icon.svg"
            onClicked: {
                stackview.pop();
            }
        }
        Label{
            text: " History"
            font.pointSize: 20
            font.bold: true
            color: "black"
        }
    }
    Rectangle
    {
        anchors.centerIn: parent
        width: 350;height: 500
        color: "white"
        border.color: "gray";border.width: 2
        ListView
        {
            id: historyView
            anchors.fill: parent
            model: db.getExportHistory()
            spacing: 5
            clip: true

            delegate: Rectangle {
                width: historyView.width
                height: 80
                color: index % 2 === 0 ? "#dfe6e9" : "#b2bec3"
                border.color: "black"
                radius: 8
                Component.onCompleted: {
                        console.log("🎯 Delegate Created: ",modelData.id," | " ,modelData.export_date, " | ", modelData.total_amount);
                    }

                Column
                {
                    anchors.centerIn: parent
                    spacing: 5

                    Text
                    {
                        text: "Date: "+modelData.export_date
                        font.bold: true
                        font.pixelSize: 16
                    }

                    Text
                    {
                        text: "Total: $" + modelData.total_amount  // ✅ Use correct field names
                        font.pixelSize: 12
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        console.log("Clicked On :",modelData.id)
                        stackview.push("ItemHistory.qml",{itemID:modelData.id,itemDate:modelData.export_date,itemTotal:modelData.total_amount})
                    }
                }
            }
        }
    }

}
