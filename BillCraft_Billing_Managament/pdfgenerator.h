#ifndef PDFGENERATOR_H
#define PDFGENERATOR_H

#include <QObject>
#include <QStringList>
#include <QList>
#include <QVariant>

class Pdfgenerator : public QObject
{
    Q_OBJECT
public:
    explicit Pdfgenerator(QObject *parent = nullptr);
    Q_INVOKABLE void generatePdf(const QString &companyName, const QString &ownerName,
                                 const QString &logoPath, const QList<QVariantMap> &items,
                                 int grandTotal, const QString &outputPath);

signals:
};

#endif // PDFGENERATOR_H
