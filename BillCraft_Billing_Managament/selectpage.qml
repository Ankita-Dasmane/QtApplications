import QtQuick 2.15
import QtQuick.Window
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.Controls.Material 2.15
import PdfGen 1.0    // 👈 Add this line


Page{
    id:select
    PdfGenerator {
        id: pdfGen
    }

// Page {
    //id:select
    property ListModel items: ListModel{}

    function calculateTotalAmount() {
        var totalAmount = 0;
        for (var i = 0; i < cartModel.count; i++) {
            totalAmount += parseInt(cartModel.get(i).total);
        }
        return totalAmount;        
    }
    function exportCartData()
    {
        var exportedData =[];
        for (var i = 0; i < cartModel.count; i++)
        {
            var item = cartModel.get(i);
            exportedData.push({
                                name: item.name,
                                price: parseFloat(item.price),
                                qty: parseInt(item.qty),
                                total: parseInt(item.total)
                              });
        }
        var totalAmount = calculateTotalAmount();
        console.log("Data:",exportedData);
        console.log("Exported Data:", JSON.stringify(exportedData));
        db.saveExportHistoryQML(exportedData, totalAmount);
        pdfGen.generatePdf(
            "Soham Electrical Services",
            "Ankita Dasmane",
            ":/image/p1.jpeg",
            exportedData,           // contains name, qty, price, total
            totalAmount,            // 💡 pass grand total too
            "I:/D drive/Ankita/QT FILES/Billing_Managament/images/Export.pdf"
        );
        //pdfDialog.open();  // ✅ Show the success popup
        root.showSuccessMessage();
        cartModel.clear();
    }

    ListModel{
        id:cartModel
    }
    Rectangle
    {
        y:10;height: 60;anchors.topMargin:5
        RowLayout
        {
            spacing: 200
            ToolButton {
                icon.source: "qrc:/images/line-angle-left-icon.svg"
                onClicked: {
                    stackview.pop("addproduct.qml");
                }
            }
            Button
            {
                id:b1
                onClicked: {
                    if(cartModel.count!==0)
                     exportCartData();//calling the export function
                    console.log("Clicked on Export button");
                }
                contentItem: Text {
                    text: "Export"
                    font.pointSize: 16
                    color: "black"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 40
                    border.color:"black"
                    border.width: 1
                    radius: 6
                }
            }
        }
    }
    Column
    {
        anchors.fill: parent
        spacing: 20
        anchors.horizontalCenter: parent.horizontalCenter
        rightPadding: 20
        topPadding: 60
        leftPadding: 20

        Text {
            id: text1
            text: "Select Product"
            font.pointSize: 25
            font.bold: true
        }
        Row
        {
            spacing: 10
            ComboBox
            {
                id:myComboBox
                width: 120
                textRole: "name"
                currentIndex: 0
                model: db.getProducts()
                onActivated:
                {
                    console.log("Selected Text : ", myComboBox.currentText)
                    console.log("Selected Index : ", myComboBox.currentIndex)
                }
            }

            TextField
            {
                id:quantity
                implicitWidth: 70
                placeholderText:"Qty"
                height: 50
                validator: IntValidator { bottom: 1 }
            }
            Button{
                id:select1
                text: "Select"
                enabled: quantity.text !== "" && myComboBox.currentIndex >= 0
                onClicked:
                {
                    var selectedProduct = db.getProductDetails(myComboBox.currentText);
                    var name = selectedProduct.name;
                    var price = selectedProduct.price;
                    var qtyValue = parseInt(quantity.text);
                    var total = price * qtyValue;
                    console.log("name:",name,"price:",price,"qty:",qtyValue,"total:",total);
                    console.log("Added to database:", name, qtyValue, total);
                    cartModel.append({ name: name, price: price, qty: qtyValue, total: total });
                    quantity.text = "";
                }

            }
        }
        Rectangle
        {

            width: parent.width - 40
            height:parent.height - 230
            radius: 5;color: "lightgray"
            Column
            {
                anchors.fill: parent
                anchors.margins: 5
                Row
                {
                    id:headerRow;width: parent.width;anchors.margins:10
                    spacing: 10; clip: true
                    Text { id: t1; width: 80; text: "Item";  font.pointSize:12; font.bold: true }
                    Text { id: t2; text: "Price"; font.pointSize:12; font.bold: true }
                    Text { id: t3; text: "Qty";   font.pointSize:12; font.bold: true }
                    Text { id: t4; text:"Total";  font.pointSize:12; font.bold: true}
                    Text { id: t5; text:"Remove"; font.pointSize:12; font.bold: true }
                }
                ListView
                {
                    width: parent.width; height: 160;
                    model: cartModel;clip: true;spacing: 5
                    delegate: Row
                    {
                        spacing: 10

                        Text { text: model.name ;width: 80;verticalAlignment:Text.AlignVCenter}
                        Text { text: model.price;width:30;horizontalAlignment: Text.AlignHCenter;verticalAlignment:Text.AlignVCenter }
                        Text { text: model.qty  ;width:30;horizontalAlignment: Text.AlignHCenter;verticalAlignment:Text.AlignVCenter}
                        Text { text: model.total;width:50;horizontalAlignment: Text.AlignHCenter;verticalAlignment:Text.AlignVCenter}
                        Button
                        {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 40; height: 40
                            icon.source: "qrc:/images/close-icon.svg";font.bold: true
                            onClicked:{
                                console.log("Removing Item:",index);
                                if (index >= 0 && index < cartModel.count)
                                {
                                    cartModel.remove(index);}
                                else
                                {
                                    console.warn("Invalid index:", index);
                                }
                            }

                        }

                    }

                }

            }

            Row{
                spacing: 10
                anchors.bottom: parent.bottom;
                width: parent.width;height: 50
                Text{id: br1; text: " Total Count:"; font.bold: true; font.pointSize: 14;width: 220}
                Text{id: br2; text: calculateTotalAmount()
                    font.bold: true; font.pointSize: 14}
            }
        }
    }
}

