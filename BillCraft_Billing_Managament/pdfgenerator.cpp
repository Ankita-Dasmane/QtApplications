#include "pdfgenerator.h"

Pdfgenerator::Pdfgenerator(QObject *parent)
    : QObject{parent}
{}

//#include "pdfgenerator.h"
#include <QPdfWriter>
#include <QPainter>
#include <QDate>
#include <QVariantMap>
#include <QImage>

//PdfGenerator::PdfGenerator(QObject *parent) : QObject(parent) {}

void Pdfgenerator::generatePdf(const QString &companyName, const QString &ownerName,
                               const QString &logoPath, const QList<QVariantMap> &items,
                               int grandTotal, const QString &outputPath)

{
    QPdfWriter writer(outputPath);
    writer.setPageSize(QPageSize(QPageSize::A4));
    writer.setResolution(300);
    QPainter painter(&writer);
    QFont font("Arial", 12);
    painter.setFont(font);

    const int margin = 30;
    const int pageWidth = writer.width();
    int y = margin;
    // ----- Header Section -----
    QImage logo(logoPath);
    // Enlarge logo size
    int logoWidth = 250;
    int logoHeight = 250;
    // Draw logo on left
    QRect logoRect(margin, y, logoWidth, logoHeight);
    painter.drawImage(logoRect, logo);
    // Company name beside logo
    QFont headerFont("Arial", 18, QFont::Bold);
    painter.setFont(headerFont);

    // Calculate starting X for company name (after logo with some gap)
    int nameX = margin + logoWidth + 20;  // 20px gap after logo
    int nameWidth = pageWidth - nameX - 200;  // leave 200px for date on right
    int nameHeight = logoHeight;

    painter.drawText(QRect(nameX, y, nameWidth, nameHeight), Qt::AlignVCenter | Qt::AlignLeft, companyName);
    // Date on right (same as before)
    QFont dateFont("Arial", 12);
    painter.setFont(dateFont);
    QString currentDate = QDate::currentDate().toString("dd-MM-yyyy");

    // Draw date in top-right corner
    //painter.drawText(QRect(margin, footerY, 300, 80), Qt::AlignLeft, "Owner: " + ownerName);

    painter.drawText(QRect(pageWidth - 500, y, 400, 100), Qt::AlignRight | Qt::AlignVCenter, " Date: "+currentDate);

    // Update Y for next section
    y += logoHeight + 50;

    // ----- Table Headers -----
    QFont tableFont("Arial", 12, QFont::Bold);
    painter.setFont(tableFont);

    int tableX = margin;
    int tableWidth = pageWidth - 2 * margin;
    int rowHeight = 80;

    // Suggested column width ratios (can adjust)
    int colSrWidth = tableWidth * 0.08;    // 8%
    int colItemWidth = tableWidth * 0.42;  // 42%
    int colQtyWidth = tableWidth * 0.15;   // 15%
    int colPriceWidth = tableWidth * 0.15; // 15%
    int colTotalWidth = tableWidth * 0.20; // 20%

    // Column X positions
    int colSr = tableX;
    int colItem = colSr + colSrWidth;
    int colQty = colItem + colItemWidth;
    int colPrice = colQty + colQtyWidth;
    int colTotal = colPrice + colPriceWidth;

    // Draw header rectangles and text
    painter.drawRect(colSr, y, colSrWidth, rowHeight);
    painter.drawText(colSr, y, colSrWidth, rowHeight, Qt::AlignCenter, "Sr");

    painter.drawRect(colItem, y, colItemWidth, rowHeight);
    painter.drawText(colItem, y, colItemWidth, rowHeight, Qt::AlignCenter, "Product Name");

    painter.drawRect(colQty, y, colQtyWidth, rowHeight);
    painter.drawText(colQty, y, colQtyWidth, rowHeight, Qt::AlignCenter, "Qty");

    painter.drawRect(colPrice, y, colPriceWidth, rowHeight);
    painter.drawText(colPrice, y, colPriceWidth, rowHeight, Qt::AlignCenter, "Price");

    painter.drawRect(colTotal, y, colTotalWidth, rowHeight);
    painter.drawText(colTotal, y, colTotalWidth, rowHeight, Qt::AlignCenter, "Total");


    // ➕ Add padding below header
    y += rowHeight ;// 10;

    // ----- Table Content -----
    painter.setFont(QFont("Arial", 11));
    int sr = 1;
    //int grandTotal = 0;

    for (const auto &item : items)
    {
        QString name = item["name"].toString();
        int qty = item["qty"].toInt();  // or item["quantity"]
        int price = item["price"].toInt();
        int total = item["total"].toInt();
        // QString name = item["name"].toString();
        // // int qty = item["qty"].toInt();
        // int qty = item["quantity"].toInt();  // ✅ match QML key: quantity
        // int price = item["price"].toInt();
        // int total = qty * price;
        // grandTotal += total;

        // Match data row column widths with header widths
        painter.drawRect(colSr, y, colSrWidth, rowHeight);
        painter.drawText(QRect(colSr, y, colSrWidth, rowHeight), Qt::AlignCenter, QString::number(sr++));

        painter.drawRect(colItem, y, colItemWidth, rowHeight);
        painter.drawText(QRect(colItem + 5, y, colItemWidth - 10, rowHeight), Qt::AlignCenter, name);
        //painter.drawText(QRect(colItem + 5, y, colItemWidth - 10, rowHeight), Qt::AlignLeft | Qt::AlignVCenter, name);

        painter.drawRect(colQty, y, colQtyWidth, rowHeight);
        painter.drawText(QRect(colQty, y, colQtyWidth, rowHeight), Qt::AlignCenter, QString::number(qty));

        painter.drawRect(colPrice, y, colPriceWidth, rowHeight);
        painter.drawText(QRect(colPrice, y, colPriceWidth, rowHeight), Qt::AlignCenter, QString::number(price));

        painter.drawRect(colTotal, y, colTotalWidth, rowHeight);
        painter.drawText(QRect(colTotal, y, colTotalWidth, rowHeight), Qt::AlignCenter, QString::number(total));
        //painter.drawText(QRect(colTotal, y, colTotalWidth, rowHeight), Qt::AlignCenter, QString::number(total));

        y += rowHeight;
    }

    // ➕ Add spacing before Grand Total
    y += 20;

    // ----- Grand Total -----
    QFont totalFont("Arial", 12, QFont::Bold);
    painter.setFont(totalFont);

    // Total label and value area (aligned with last column)
    QString totalText = "Total: ₹" + QString::number(grandTotal);
    //QString totalText = "Total: ₹" + QString::number(grandTotal);


    // Use only last two columns to draw it
    int totalLabelX = colPrice;
    int totalLabelWidth = colPriceWidth + colTotalWidth;
    int totalBoxHeight = 40;

    //painter.drawRect(totalLabelX, y, totalLabelWidth, totalBoxHeight);

    painter.drawText(QRect(totalLabelX, y, totalLabelWidth, totalBoxHeight), Qt::AlignCenter, totalText);

    // y += rowHeight;
    // // ----- Grand Total -----
    // painter.setFont(QFont("Arial", 12, QFont::Bold));
    // painter.drawText(colTotal - 80, y + 10, 200, 30, Qt::AlignLeft, "Grand Total:");
    // painter.drawText(colTotal, y + 10, 80, 30, Qt::AlignCenter, QString::number(grandTotal));

    // ----- Footer Section -----
    int footerY = writer.height() - 200;
    painter.setFont(QFont("Arial", 11));

    // Left: Owner
    painter.drawText(QRect(margin, footerY, 300, 80), Qt::AlignLeft, "Owner: " + ownerName);

    // Center: Architect / Engineer
    painter.drawText(QRect(pageWidth / 2 - 100, footerY, 400, 80), Qt::AlignCenter, "Architect / Engineer");

    // Right: Signature (Fix here)
    painter.drawText(QRect(pageWidth - 250, footerY, 200, 80), Qt::AlignRight, "Signature");

    // // ----- Footer Section -----
    // int footerY = writer.height() - 100;
    // painter.setFont(QFont("Arial", 11));
    // painter.drawText(margin, footerY, "Owner: " + ownerName);
    // painter.drawText(pageWidth / 2 - 50, footerY, "Architect / Engineer");
    // painter.drawText(pageWidth - 100, footerY, "Signature");

    painter.end();
}
