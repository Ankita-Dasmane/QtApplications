#include "databasemanager.h"
#include <QDebug>
#include<QSqlError>
DatabaseManager::DatabaseManager(QObject *parent): QObject(parent)
{
    db=QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("billingDB.db");
    if(!db.open())
    {
        qDebug()<<"Error:Unable to open database!(db.cpp)\n";
    }
    else{
       createDatabase();
        logindb();
    }
}
DatabaseManager::~DatabaseManager()
{
    db.close();
}
void DatabaseManager::createDatabase()
{
    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS products("
               "name TEXT, "
               "price TEXT,"
               "description TEXT,"
               "export_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
    query.exec("CREATE TABLE IF NOT EXISTS export_history (id INTEGER PRIMARY KEY AUTOINCREMENT,"
               " export_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
               "total_amount REAL NOT NULL)");
    query.exec("CREATE TABLE IF NOT EXIST login(username TEXT, password TEXT,number INTEGER)");
    query.exec("CREATE TABLE IF NOT EXISTS export_items ("
               "export_id INTEGER NOT NULL, item_name TEXT NOT NULL,"
               " price TEXT NOT NULL, quantity INTEGER NOT NULL, total INTEGER NOT NULL,"
               " FOREIGN KEY (export_id) REFERENCES export_history(id) ON DELETE CASCADE)");
}

void DatabaseManager::addProduct(const QString &name, const QString &price, const QString &description)
{
    QSqlQuery query;
    query.prepare("INSERT INTO products (name,price,description)"
                  "VALUES(?,?,?)");
    query.addBindValue(name);
    query.addBindValue(price);
    query.addBindValue(description.isEmpty()?QVariant():description);
    //query.addBindValue(export_date);
    if(!query.exec())
    {
        qDebug()<<"\n(cpp)Failed To insert products"<<query.lastError().text();
    }
    else {
        qDebug()<<"\n(cpp)Product added";
    }
}

QVariantList DatabaseManager::getProducts()
{
    QVariantList items;
    QSqlQuery query("SELECT name, price FROM products");

    if (!query.exec()) {
        qDebug() << "Database query failed: " << query.lastError().text();
        return items;  // Return empty list if query fails
    }

    while (query.next()) {
        QVariantMap item;
        item["name"] = query.value(0).toString();
        item["price"] = query.value(1).toString();
        items.append(item);
    }

    //qDebug() << "(grtproducts)Fetched Products: " << items;  // Debugging output
    return items;
}

QVariantMap DatabaseManager::getProductDetails(const QString &name)
{
    QVariantMap productDetails;
    QSqlQuery query;
    query.prepare("SELECT * FROM products WHERE name = ?");
    query.addBindValue(name);
    if (!query.exec()) {
        qDebug() << "\nDatabase query failed(db.cpp): " << query.lastError().text();
        return productDetails;
    }
    if (query.next()) {
        productDetails["name"] = query.value(0).toString();
        productDetails["price"] = query.value(1).toString();
        productDetails["description"] = query.value(2).toString();
        qDebug() << "(From getProductDetails 90)Fetched product details: Name:" << productDetails["name"].toString()
                 << ", Price:" << productDetails["price"].toString();
    }
    else{
        qDebug()<<"Product not found:"<<query.lastError().text();
    }
    qDebug() << "\nFetching contact details for name(db.cpp):" << name;
    return productDetails;

}

bool DatabaseManager::deleteProduct(const QString &name)
{
    QSqlQuery query;
    query.prepare("DELETE FROM products WHERE name = ?");
    query.addBindValue(name);
    if(!query.exec())
    {
        qDebug()<<"\nDelete error(db.cpp):"<<query.lastError().text();
        return false;
    }
    else
    {
        qDebug() << "\nUser with Number(db.cpp)" << name << "deleted.(db.cpp)\n";
        return true;
    }
}
//Q_INVOKABLE bool updateProduct(const QString &oldname, const QString &name,const QString &price, const QString &description);

bool DatabaseManager::updateProduct(const QString &oldname, const QString &name, const QString &price, const QString &description)
{
    qDebug() << "\nAttempting to delete contact with number(db.cpp): " << oldname;
    QSqlQuery query;
    query.prepare("UPDATE products SET name = ?, price = ?, description = ? WHERE name = ?");

    query.addBindValue(name);
    query.addBindValue(price);
    query.addBindValue(description.isEmpty() ? QVariant() : description);
    query.addBindValue(oldname);  // Updating based on the old number

    if (!query.exec())
    {
        qDebug() << "\nUpdate error(db.cpp):" << query.lastError().text();
        return false;
    }
    qDebug() << "\nContact updated successfully!()db.cpp";
    return true;
}


void DatabaseManager::logindb()
{
    // QSqlQuery query;
    // // Create table with role field if not exists
    // query.exec("CREATE TABLE IF NOT EXISTS login (username TEXT PRIMARY KEY, password TEXT, number TEXT, role TEXT)");

    // query.prepare("INSERT OR IGNORE INTO login (username, password, number, role) VALUES "
    //               "('admin', '2025', '9326668635', 'admin'),"
    //               "('user', '0404', '1234567890', 'user')");
    // if (!query.exec()) {
    //     qDebug() << "Failed to insert login data: " << query.lastError().text();
    // } else {
    //     qDebug() << "Default login users inserted.";
    // }
    QSqlQuery query;

    query.exec("CREATE TABLE IF NOT EXISTS login (username TEXT PRIMARY KEY, password TEXT, number TEXT, role TEXT)");

    query.prepare("INSERT OR IGNORE INTO login (username, password, number, role) VALUES "
                  "('admin', '2025', '9326668635', 'admin'),"
                  "('user', '0404', '1234567890', 'user')");

    if (!query.exec()) {
        qDebug() << "Failed to insert login data:" << query.lastError().text();
    } else {
        qDebug() << "Default login users inserted.";
    }

    debugPrintLogins();  // Confirm insert worked
}

void DatabaseManager::debugPrintLogins() {
    QSqlQuery query("SELECT username, password, number, role FROM login");
    while (query.next()) {
        qDebug() << "Username:" << query.value(0).toString()
        << "Password:" << query.value(1).toString()
        << "Number:"   << query.value(2).toString()
        << "Role:"     << query.value(3).toString();
    }
}

QString DatabaseManager::checkLogin(const QString &username, const QString &password)
{
    QSqlQuery query;
    query.prepare("SELECT role FROM login WHERE username = :username AND password = :password");
    query.bindValue(":username", username);
    query.bindValue(":password", password);

    if (query.exec() && query.next()) {
        return query.value("role").toString(); // "admin" or "user"
    } else {
        return "invalid";
    }
}

QVariantList DatabaseManager:: getLoginDataByRole(const QString &role, const QString &field)
{
    QVariantList list;
    QString queryStr = "SELECT username, password, number, role FROM login";

    if (!role.isEmpty()) {
        queryStr += " WHERE role = :role";
    }

    QSqlQuery query;
    query.prepare(queryStr);

    if (!role.isEmpty()) {
        query.bindValue(":role", role);
    }

    if (query.exec()) {
        while (query.next()) {
            if (!field.isEmpty()) {
                // Return only specific field
                if      (field == "username") list.append(query.value(0).toString());
                else if (field == "password") list.append(query.value(1).toString());
                else if (field == "number")   list.append(query.value(2).toString());
                else if (field == "role")     list.append(query.value(3).toString());
            } else {
                // Return all fields
                QVariantMap user;
                user["username"] = query.value(0).toString();
                user["password"] = query.value(1).toString();
                user["number"]   = query.value(2).toString();
                user["role"]     = query.value(3).toString();
                list.append(user);
            }
        }
    } else {
        qDebug() << "Query failed:" << query.lastError().text();
    }

    return list;
}

//update credentials
bool DatabaseManager::updateCredentials(const QString &role, const QString &oldPassword,
                                        const QString &newUsername, const QString &newPassword, const QString &newNumber)
{
    // Check if the role exists and matches the old password
    QSqlQuery checkQuery;
    checkQuery.prepare("SELECT username FROM login WHERE role = :role AND password = :oldPassword");
    checkQuery.bindValue(":role", role);
    checkQuery.bindValue(":oldPassword", oldPassword);

    if (!checkQuery.exec() || !checkQuery.next()) {
        qDebug() << "No user found with provided role and old password.";
        return false;
    }

    // Perform update using role and old password as criteria
    QSqlQuery updateQuery;
    updateQuery.prepare("UPDATE login SET username = :newUsername, password = :newPassword, number = :newNumber "
                        "WHERE role = :role AND password = :oldPassword");

    updateQuery.bindValue(":newUsername", newUsername);
    updateQuery.bindValue(":newPassword", newPassword);
    updateQuery.bindValue(":newNumber", newNumber);
    updateQuery.bindValue(":role", role);
    updateQuery.bindValue(":oldPassword", oldPassword);

    if (!updateQuery.exec()) {
        qDebug() << "Update failed:" << updateQuery.lastError().text();
        return false;
    }

    return updateQuery.numRowsAffected() > 0;
}

// bool DatabaseManager::updateCredentials(const QString &oldPassword, const QString &newUsername, const QString &newPassword, const QString &newNumber)
// {
//     QSqlQuery query;
//     query.prepare("UPDATE login SET username = :newUsername, password = :newPassword, number = :newNumber "
//                   "WHERE password = :oldPassword");

//     query.bindValue(":newUsername", newUsername);
//     query.bindValue(":newPassword", newPassword);
//     query.bindValue(":newNumber", newNumber);
//     query.bindValue(":oldPassword", oldPassword);

//     if (!query.exec()) {
//         qDebug() << "Update failed:" << query.lastError().text();
//         return false;
//     }

//     return query.numRowsAffected() > 0;
// }
// ✅ QML-compatible function (converts QVariantList to QList<ExportItem>)
void DatabaseManager::saveExportHistoryQML(const QVariantList &items, int totalAmount) {
    QList<ExportItem> itemList;

    for (const QVariant &var : items) {
        QVariantMap itemMap = var.toMap();
        ExportItem item;
        item.name = itemMap["name"].toString();
        item.price = itemMap["price"].toDouble();
        item.quantity = itemMap["quantity"].toInt();
        item.total = itemMap["total"].toDouble();
        itemList.append(item);
    }

    // Call the original function that actually saves to the database
    saveExportHistory(itemList, totalAmount);
}

// ✅ Original function (Saves Export Data to Database)
void DatabaseManager::saveExportHistory(const QList<ExportItem> &items, int totalAmount) {
    QSqlQuery query;
    query.prepare("INSERT INTO export_history (total_amount) VALUES (:total_amount)");
    query.bindValue(":total_amount", totalAmount);

    if (query.exec()) {
        int exportId = query.lastInsertId().toInt();

        for (const ExportItem &item : items) {
            QSqlQuery itemQuery;
            itemQuery.prepare("INSERT INTO export_items (export_id, item_name, price, quantity, total) "
                              "VALUES (:export_id, :item_name, :price, :quantity, :total)");
            itemQuery.bindValue(":export_id", exportId);
            itemQuery.bindValue(":item_name", item.name);
            itemQuery.bindValue(":price", item.price);
            itemQuery.bindValue(":quantity", item.quantity);
            itemQuery.bindValue(":total", item.total);
            itemQuery.exec();
        }

        qDebug() << "Export history saved successfully!";
    } else {
        qDebug() << "Error saving history:" << query.lastError().text();
    }
}
QVariantList DatabaseManager::getExportHistory()
{
    QVariantList historyList;
    QSqlQuery query;
    query.prepare("SELECT * FROM export_history ORDER BY export_date DESC");
    if (!query.exec()) {  // ✅ Always check `exec()` before `next()`
        qDebug() << "Failed to fetch export history:" << query.lastError().text();
        return historyList;  // Return empty list if query fails
    }
    while (query.next()) {
        QVariantMap history;
        history["id"] = query.value(0).toInt();
        history["export_date"] = query.value(1).toString();
        history["total_amount"] = query.value(2).toDouble();
        historyList.append(history);
    }
    //qDebug() << "Export History Fetched: " << historyList;  // ✅ Debugging Output
    return historyList;
}
QVariantList DatabaseManager::getExportItems(int exportId)
{
    QVariantList itemList;
    QSqlQuery query;
    query.prepare("SELECT * FROM export_items WHERE export_id = :export_id");
    query.bindValue(":export_id", exportId);

    if (query.exec()) {
        while (query.next()) {
            QVariantMap item;
            item["name"] = query.value("item_name").toString();
            item["price"] = query.value("price").toString();
            item["quantity"] = query.value("quantity").toInt();
            item["total"] = query.value("total").toInt();
            itemList.append(item);
        }
    }
    return itemList;
}
