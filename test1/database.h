#ifndef DATABASE_H
#define DATABASE_H
#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QVariantList>

class Database : public QObject
{
    Q_OBJECT
public:
    explicit Database(QObject *parent = nullptr);
    ~Database();
    Q_INVOKABLE void addContact(const QString &firstname, const QString &lastname, const QString &number,
                                const QString &email, const QString &address, const QString &birthday,
                                const QString &note);
    Q_INVOKABLE QVariantList getContacts();
    Q_INVOKABLE QVariantMap getContactDetails(const QString &number);
    void initializeDatabase();
    Q_INVOKABLE bool deleteUser(const QString &number);
    Q_INVOKABLE bool updateContact(const QString &oldnumber, const QString &firstname, const QString &lastname,
                       const QString &number, const QString &email, const QString &address,
                       const QString &birthday, const QString &note);
    Q_INVOKABLE bool isModified(const QString &number,const bool &is_favorite, const bool &is_blocked);


private:
    QSqlDatabase db;
};

#endif // DATABASE_H
