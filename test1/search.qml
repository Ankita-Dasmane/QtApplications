import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

Page {
    id: page3
    property var contacts: db.getContacts()
    property var selectedContact: null

    ListModel {
        id: contactModel
    }
    Component.onCompleted: {
          // Assuming getContacts() returns an array of contacts
               for (var i = 0; i < contacts.length; i++) {
                   contactModel.append(contacts[i]);
               }
       }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 10
        spacing: 10

        //  Search Field
        RowLayout {
            Layout.fillWidth: true
            spacing: 5
            ToolButton{
                text:"Back"
                onClicked: stackView.pop("search.qml");
            }

            TextField {
                id: searchField
                placeholderText: "Search by Number"
                font.pixelSize: 20
                font.bold: true
                Layout.fillWidth: true

                onTextChanged: {
                    filterContacts(searchField.text)
                }

            }
            ToolButton {
                text: "Clear"
                //Layout.alignment: AlignLeft
                onClicked: searchField.text = ""
            }
    }

        // Contact List with Filtering
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            //border.color: "gray"
            Flickable
            {
                anchors.fill: parent
                contentHeight: contactListView.height
                //clip: true
                ListView
                {
                    id: contactListView
                    width: parent ? parent.width : 300
                    height: contentHeight
                    model: filteredModel
                    delegate: Item
                    {
                        width: contactListView.width
                        height: 50

                        RowLayout
                        {
                            anchors.fill: parent
                            spacing: 10
                            anchors.leftMargin: 5

                            Rectangle {
                                width: 30
                                height: 30
                                color: "yellow"
                                border.color: "black"
                                radius: 6
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked:
                                    {
                                        selectedContact=model
                                        //console.log("\nCurrent Index",filteredModel.get(contactListView.currentIndex));
                                        contactDialog.open()
                                    }
                                }
                            }
                            Text {
                                text: model.firstname + " " + model.lastname + "\n" + model.number + ""
                                font.pixelSize: 16
                                Layout.fillWidth: true
                            }
                        }
                    }
                }
            }
        }
    }
    // 🔹 Filtered Model
    ListModel {
        id: filteredModel
    }

    // 🔹 Function to Filter Contacts
    function filterContacts(query)
    {
        filteredModel.clear()
        for (var i = 0; i < contactModel.count; i++)
        {
            var contact = contactModel.get(i)
            if (contact.number.includes(query))
            {
                filteredModel.append(contact)
            }
        }
    }
    Dialog {
           id: contactDialog
           title: "Contact Details"
           modal: true
           anchors.centerIn: parent
           standardButtons: Dialog.Ok

           Column {
               spacing: 10
               padding: 20
               Text {
                   text: "First Name: "+(selectedContact ? selectedContact.firstname : "")
                   font.pixelSize: 16
               }
               Text {
                   text: "Last Name: "+(selectedContact ? selectedContact.lastname : "")
                   font.pixelSize: 16
               }
               Text {
                   text: "Number: " +(selectedContact ? selectedContact.number : "")
                   font.pixelSize: 16
               }
           }
       }

}
