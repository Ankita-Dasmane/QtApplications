// import QtQuick 2.15
// import QtQuick.Layouts 2.15
// import QtQuick.Window 2.15
// import QtQuick.Controls 2.15
// import QtQuick.Controls.Material
// Page {
//     id:settings
//     ToolButton {  //back
//         icon.source: "qrc:/images/angle-left-icon.svg"
//         onClicked: {
//             stackview.pop("addproduct.qml");
//         }
//     }
//     Column
//         {
//             spacing: 20
//             topPadding: 50
//             padding: 20
//             Label{
//                 text: "Settings"
//                 font.pointSize: 25
//                 font.bold: true
//             }

//             Button {
//                 id: name
//                 //anchors.centerIn: parent
//                 width: 300
//                 height: 50
//                 contentItem: Text {
//                     text: "Modify Admin Credential"
//                     font.pointSize: 12
//                     color: "black"
//                     horizontalAlignment: Text.AlignHCenter
//                     verticalAlignment: Text.AlignVCenter
//                     elide: Text.ElideRight
//                 }
//                 background: Rectangle {
//                     implicitWidth: 100
//                     implicitHeight: 40
//                     border.color:"black"
//                     border.width: 1
//                     radius: 6
//                 }
//                 onClicked: {
//                     console.log("Modify admin credentials")
//                     number.open();
//                 }
//             }
//             Button{
//                 width: 300
//                 height: 50
//                 contentItem: Text {
//                     text: "Modify User Credential"
//                     font.pointSize: 12
//                     color: "black"
//                     horizontalAlignment: Text.AlignHCenter
//                     verticalAlignment: Text.AlignVCenter
//                     elide: Text.ElideRight
//                 }
//                 background: Rectangle {
//                     implicitWidth: 100
//                     implicitHeight: 40
//                     border.color:"black"
//                     border.width: 1
//                     radius: 6
//                 }
//                 onClicked: {
//                     console.log("User credential");
//                     number.open();
//                 }
//             }
//         }
//         Dialog
//         {
//             id: number
//             font.bold: true
//             x: (parent.width - width) / 2
//             y: (parent.height - height) / 2
//             parent: Overlay.overlay
//             focus: true
//             modal: true
//             title: "Modification"
//             standardButtons: Dialog.Ok | Dialog.Cancel
//             ColumnLayout
//             {
//                 spacing: 20
//                 anchors.fill: parent
//                 TextField {
//                     focus: true
//                     id:tf11
//                     placeholderText: "Old Password"
//                     Layout.fillWidth: true
//                 }

//                 Text {
//                     text: qsTr("Note: Enter the your password")
//                     font.pointSize: 12
//                 }
//             }
//             onAccepted:{
//                 console.log("Old Password:", tf11.text);
//                 var oldpass=tf11.text==="admin"? "admin":"user";
//                 var adminPasswords=db.getLoginDataByRole(oldpass,"password");
//                 //var adminPasswords = db.getLoginDataByRole("admin", "password");
//                 console.log("Admin Passwords:", adminPasswords);
//                 if (adminPasswords.includes(tf11.text)) {
//                     credentials.open();
//                 } else {
//                     console.log("Entered password is incorrect.");
//                 }

//                 // var success = db.updateCredentials(oldPassword.text, newUsername.text, newPassword.text, newNumber.text)
//                 //       if (success) {
//                 //           console.log("############Updated successfully")
//                 //       } else {
//                 //           console.log("###########Update failed. Check old password.")
//                 //       }
//             }
//             onRejected: console.log("Rejected the modification");
//         }

//         Dialog{
//             id: credentials
//             font.bold: true
//             x: (parent.width - width) / 2
//             y: (parent.height - height) / 2
//             parent: Overlay.overlay
//             focus: true
//             modal: true
//             title: "Enter New Credentials"
//             standardButtons: Dialog.Ok | Dialog.Cancel
//             ColumnLayout
//             {
//                 spacing: 20
//                 anchors.fill: parent
//                 TextField {
//                     focus: true
//                     id:tf21
//                     placeholderText: "New Username*"
//                     Layout.fillWidth: true
//                 }
//                 TextField{
//                     id:tf22
//                     placeholderText: "New password*"
//                     Layout.fillWidth: true
//                 }
//                 TextField{
//                     id:tf23
//                     placeholderText: "New Number*"
//                     Layout.fillWidth: true;
//                 }

//                 Text {
//                     id:tf24
//                     text: "Note: Enter all the fileds"
//                     font.pointSize: 12
//                 }
//             }
//             onAccepted: {
//                 if (tf21.text !== "" && tf22.text !== "" && tf23.text !== "") {
//                     updateUserCredentials(tf11.text, tf21.text, tf22.text, tf23.text)
//                 } else {
//                     console.log("Please fill all the fields.");
//                     tf24.text = "All fields are required!";
//                     credentials.open(); // Reopen the dialog
//                 }
//             }
//             // onAccepted:  {
//             //     updateUserCredentials(tf11.text, tf21.text, tf22.text, tf23.text) // Or get number from another input field
//             // }
//         }
//         function updateUserCredentials(oldPassword, newUsername, newPassword, newNumber)
//         {
//             console.log("Old Password:", oldPassword)
//             console.log("New Username:", newUsername)
//             console.log("New Password:", newPassword)
//             console.log("New Number:", newNumber)

//             var success = db.updateCredentials(oldPassword, newUsername, newPassword, newNumber)

//             if (success) {
//                 console.log("Updated successfully")
//             } else {
//                 console.log("Update failed. Check old password.")
//             }
//         }

// }
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.Controls.Material

Page {
    id: settings
    property string currentRole: ""

    ToolButton {
        icon.source: "qrc:/images/angle-left-icon.svg"
        onClicked: stackview.pop("addproduct.qml")
    }

    Column {
        spacing: 20
        topPadding: 50
        padding: 20

        Label {
            text: "Settings"
            font.pointSize: 25
            font.bold: true
        }

        Button {
            width: 300
            height: 50
            contentItem: Text {
                text: "Modify Admin Credential"
                font.pointSize: 12
                color: "black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                border.color: "black"
                border.width: 1
                radius: 6
            }
            onClicked: number.open()
        }

        Button {
            width: 300
            height: 50
            contentItem: Text {
                text: "Modify User Credential"
                font.pointSize: 12
                color: "black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                border.color: "black"
                border.width: 1
                radius: 6
            }
            onClicked: number.open()
        }
    }

    // 🔒 Old Password Input Dialog
    Dialog {
        id: number
        title: "Enter Old Password"
        modal: true
        parent: Overlay.overlay
        font.bold: true
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        ColumnLayout {
            spacing: 20
            anchors.fill: parent

            TextField {
                id: tf11
                placeholderText: "Old Password"
                Layout.fillWidth: true
                focus: true
            }

            Text {
                text: qsTr("Enter your current password")
                font.pointSize: 12
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 10

                Button {
                    text: "Cancel"
                    onClicked: number.reject()
                }

                Button {
                    text: "Next"
                    onClicked: {
                        validatePasswordAndRole(tf11.text)
                        number.accept()
                    }
                }
            }
        }
    }

    // 🔧 Credential Update Dialog
    Dialog {
        id: credentials
        title: "Enter New Credentials"
        modal: true
        parent: Overlay.overlay
        font.bold: true
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        ColumnLayout {
            spacing: 20
            anchors.fill: parent

            TextField {
                id: tf21
                placeholderText: "New Username*"
                Layout.fillWidth: true
                onTextChanged: validateInputs()
            }

            TextField {
                id: tf22
                placeholderText: "New Password*"
                Layout.fillWidth: true
                onTextChanged: validateInputs()
            }

            TextField {
                id: tf23
                placeholderText: "New Number*"
                Layout.fillWidth: true
                onTextChanged: validateInputs()
            }

            Text {
                id: tf24
                text: "All fields are required"
                font.pointSize: 12
                color: "red"
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 10

                Button {
                    text: "Cancel"
                    onClicked: credentials.reject()
                }

                Button {
                    id: okButton
                    text: "OK"
                    enabled: false
                    onClicked: {
                        updateUserCredentials(currentRole, tf11.text, tf21.text, tf22.text, tf23.text)
                        credentials.accept()
                    }
                }
            }
        }
    }

    // 🔄 Helper: Validate fields
    function validateInputs() {
        okButton.enabled = tf21.text !== "" && tf22.text !== "" && tf23.text !== "";
    }

    // 🔐 Helper: Check password matches for either admin or user
    function validatePasswordAndRole(passwordInput) {
        let roles = ["admin", "user"];
        for (let i = 0; i < roles.length; i++) {
            let role = roles[i];
            let passwords = db.getLoginDataByRole(role, "password");
            if (passwords.includes(passwordInput)) {
                currentRole = role;
                console.log("✔ Password matched for role:", currentRole);
                credentials.open();
                return;
            }
        }
        console.log("❌ Password incorrect.");
    }

    // ✅ Call C++ method with correct role + old password
    function updateUserCredentials(role, oldPassword, newUsername, newPassword, newNumber) {
        console.log("Updating for role:", role);
        let success = db.updateCredentials(role, oldPassword, newUsername, newPassword, newNumber);
        if (success) {
            console.log("✅ Credentials updated");
        } else {
            console.log("❌ Update failed. Check old password or role.");
        }
    }
}
