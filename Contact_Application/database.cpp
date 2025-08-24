#include "database.h"
#include <QDebug>
Database::Database(QObject *parent): QObject(parent)
{
    db=QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("Communicate.db");
    if(!db.open())
    {
        qDebug()<<"Error:Unable to open database!(db.cpp)\n";
    }
    else{
        initializeDatabase();
    }
}
Database::~Database()
{
    db.close();
}
void Database::initializeDatabase()
{

    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS contacts ("
               "firstname TEXT, "
               "lastname TEXT, "
               "number TEXT PRIMARY KEY, "
               "email TEXT, "
               "address TEXT, "
               "birthday TEXT, "
               "note TEXT,"
               "is_favorite INTEGER DEFAULT 0, "
               "is_blocked INTEGER DEFAULT 0)");
}

bool Database::deleteUser(const QString &number)
{
    QSqlQuery query;
    query.prepare("DELETE FROM contacts WHERE number = ?");
    query.addBindValue(number);
    if(!query.exec())
    {
        qDebug()<<"\nDelete error(db.cpp):"<<query.lastError().text();
        return false;
    }
    else
    {
        qDebug() << "\nUser with Number(db.cpp)" << number << "deleted.(db.cpp)\n";
        //qDebug()<<;
        return true;
    }
}

void Database::addContact(const QString &firstname, const QString &lastname,
                                  const QString &number, const QString &email,
                                  const QString &address, const QString &birthday,
                                  const QString &note)
{
    QSqlQuery query;
    query.prepare("INSERT INTO contacts (firstname, lastname, number, email, address, birthday, note)""VALUES (?, ?, ?, ?, ?, ?, ?)");
    query.addBindValue(firstname);
    query.addBindValue(lastname);
    query.addBindValue(number);
    query.addBindValue(email.isEmpty() ? QVariant() : email);
    query.addBindValue(address.isEmpty() ? QVariant() : address);
    query.addBindValue(birthday.isEmpty() ? QVariant() : birthday);
    query.addBindValue(note.isEmpty() ? QVariant() : note);


    qDebug() << "\nAdding contact(db.cpp):" << firstname << lastname << number << email << address << birthday << note;
    qDebug() << "\nExecuting query(db.cpp): " << query.executedQuery();
    qDebug() << "\nBound values(db.cpp): " << firstname << lastname << number<< (email.isEmpty() ? "NULL" : email)
             << (address.isEmpty() ? "NULL" : address)<< (birthday.isEmpty() ? "NULL" : birthday)
             << (note.isEmpty() ? "NULL" : note);


    if (!query.exec()) {
        qWarning() << "\nFailed to insert contact:(db.cpp)" << query.lastError().text();
    } else {
        qDebug() << "\nContact added successfully(db.cpp)!";
    }
}
bool Database::updateContact(const QString &oldnumber, const QString &firstname, const QString &lastname,
                             const QString &number, const QString &email, const QString &address,
                             const QString &birthday, const QString &note) {
    qDebug() << "\nAttempting to delete contact with number(db.cpp): " << oldnumber;
    QSqlQuery query;
    query.prepare("UPDATE contacts SET firstname = ?, lastname = ?, number = ?, email = ?, address = ?, "
                  "birthday = ?, note = ? WHERE number = ?");

    query.addBindValue(firstname);
    query.addBindValue(lastname);
    query.addBindValue(number);
    query.addBindValue(email.isEmpty() ? QVariant() : email);
    query.addBindValue(address.isEmpty() ? QVariant() : address);
    query.addBindValue(birthday.isEmpty() ? QVariant() : birthday);
    query.addBindValue(note.isEmpty() ? QVariant() : note);
    query.addBindValue(oldnumber);  // Updating based on the old number

    if (!query.exec())
    {
        qDebug() << "\nUpdate error(db.cpp):" << query.lastError().text();
        return false;
    }
    qDebug() << "\nContact updated successfully!()db.cpp";
    return true;
}

bool Database::isModified(const QString &number,const bool &is_favorite, const bool &is_blocked)
{
    qDebug()<<"\nValues received(db.cpp):"<<number <<is_favorite<<is_blocked;
    QSqlQuery query;
    query.prepare("Update contacts SET is_favorite=?, is_blocked=? WHERE number=?");
    query.addBindValue(is_favorite ? 1 : 0);
    query.addBindValue(is_blocked ? 1 : 0);
    query.addBindValue(number);
    if(!query.exec())
    {
        qDebug()<<"\nModification Error(db.cpp)"<<query.lastError().text();
        return false;
    }
    else
    {
        qDebug()<<"\nModification Succssfull(db.cpp)";
        return true;
    }
}

QVariantList Database::getContacts()
{
    QVariantList contacts;
    QSqlQuery query("SELECT firstname, lastname, number FROM contacts");
    while (query.next())
    {
        QVariantMap contact;
        contact["firstname"] = query.value(0).toString();
        contact["lastname"] = query.value(1).toString();
        contact["number"] = query.value(2).toString();
        contacts.append(contact);
    }
    return contacts;
}
QVariantMap Database::getContactDetails(const QString &number)
{
    QVariantMap contactDetails;
    QSqlQuery query;
    query.prepare("SELECT * FROM contacts WHERE number = ?");
    query.addBindValue(number);
    if (!query.exec()) {
        qDebug() << "\nDatabase query failed(db.cpp): " << query.lastError().text();
        return contactDetails;
    }
    //query.exec();
    if (query.next()) {
        contactDetails["firstname"] = query.value(0).toString();
        contactDetails["lastname"] = query.value(1).toString();
        contactDetails["number"] = query.value(2).toString();
        contactDetails["email"] = query.value(3).toString();
        contactDetails["address"] = query.value(4).toString();
        contactDetails["birthday"] = query.value(5).toString();
        contactDetails["note"] = query.value(6).toString();
        contactDetails["is_favorite"]=query.value(7).toInt();
        contactDetails["is_blocked"]=query.value(7).toInt();


    }
    qDebug() << "\nFetching contact details for number(db.cpp):" << number;
    return contactDetails;

}
