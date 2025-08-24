#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H
#include <QSqlQuery>
#include<QSqlDatabase>
#include <QObject>
#include<QList>
struct ExportItem
{
    QString name;
    double price;
    int quantity;
    double total;
};
class DatabaseManager : public QObject
{
    Q_OBJECT
public:
    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager();
    void createDatabase();
    Q_INVOKABLE void addProduct(const QString &name, const QString &price,const QString &description);
    Q_INVOKABLE QVariantList getProducts();
    Q_INVOKABLE QVariantMap getProductDetails(const QString &name);
    Q_INVOKABLE bool deleteProduct(const QString &name);
    Q_INVOKABLE bool updateProduct(const QString &oldname, const QString &name,const QString &price, const QString &description);
    //  Original C++ function that saves to the database
    //login db
    void logindb();
    Q_INVOKABLE void debugPrintLogins();

    // Q_INVOKABLE QString checkLogin(const QString &username, const QString &password);
    // Q_INVOKABLE bool updateCredentials(const QString &username, const QString &oldPassword,
    //                                    const QString &newPassword, const QString &newNumber);
    //Q_INVOKABLE void logindb();
    Q_INVOKABLE QString checkLogin(const QString &username, const QString &password);
    Q_INVOKABLE QVariantList getLoginDataByRole(const QString &role = "", const QString &field = "");
    //Q_INVOKABLE bool updateCredentials(const QString &oldPassword, const QString &newUsername, const QString &newPassword, const QString &newNumber);
    Q_INVOKABLE bool updateCredentials(const QString &role, const QString &oldPassword,
                                       const QString &newUsername, const QString &newPassword, const QString &newNumber);


    // Q_INVOKABLE QString checkLogin(const QString &username, const QString &password);
    // // Q_INVOKABLE QString getNumberByRole(const QString &role);
    // Q_INVOKABLE bool updateCredentials(const QString &oldPassword, const QString &newUsername, const QString &newPassword, const QString &newNumber);
    // Q_INVOKABLE QVariantList getLoginDataByRole(const QString &role = "", const QString &field = "");


    void saveExportHistory(const QList<ExportItem> &items, int totalAmount);
    // New QML-compatible function (wrapper)
    Q_INVOKABLE void saveExportHistoryQML(const QVariantList &items, int totalAmount);
    Q_INVOKABLE QVariantList getExportHistory();
    Q_INVOKABLE QVariantList getExportItems(int exportId);

private:
    QSqlDatabase db;
};

#endif // DATABASEMANAGER_H
