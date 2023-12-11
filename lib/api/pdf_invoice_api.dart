import 'dart:io';
import 'dart:typed_data';
// import 'package:allcanfarmapp/api/pd

import 'package:dhurmaati/api/pdf_api.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import '../Constants/utils.dart';
import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();
    final font = await rootBundle.load("assets/fonts/Poppins-Regular.ttf");
    final ByteData bytes = await rootBundle.load('assets/images/maatilogo.png');
    final Uint8List byteList = bytes.buffer.asUint8List();
    final ttf_font = Font.ttf(font);
    pdf.addPage(
      MultiPage(
        build: (context) => [
          buildHeader(invoice, ttf_font,byteList),
          SizedBox(height: 3 * PdfPageFormat.cm),
          buildTitle(invoice, ttf_font),
          buildInvoice(invoice, ttf_font),
          Divider(),
          buildTotal(invoice, ttf_font, invoice.customer),
        ],
        footer: (context) => buildFooter(invoice, ttf_font),
      ),
    );

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice, ttf_font,byteList) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(invoice.supplier, ttf_font),
               pw.Image(pw.MemoryImage(byteList), fit: pw.BoxFit.fitHeight, height: 100, width: 100),
          SizedBox(height: 1 * PdfPageFormat.cm),
             
              // Container(
              //   height: 50,
              //   width: 50,
              //   child: BarcodeWidget(
              //     barcode: Barcode.qrCode(),
              //     data: invoice.info.number,
              //   ),
              // ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.customer),
               buildInvoiceInfo(invoice.info, ttf_font)
              // buildInvoiceInfo(invoice.info),
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(Customer customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("To :", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(customer.address),
          Text(customer.address2),
          Text(customer.City),
          Text(customer.state),
          Text(customer.Pin.toString()),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceInfo info, Font ttf_font) {
    // final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
    ];
    final data = <String>[
      info.number,
      info.date,
      // paymentTerms,
      // Utils.formatDate(info.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(
            title: title,
            value: value,
            width: 200,
            titleStyle: pw.TextStyle(font: ttf_font));
      }),
    );
  }

  static Widget buildSupplierAddress(Supplier supplier, Font ttf_font) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("From :",
              style: TextStyle(fontWeight: FontWeight.bold, font: ttf_font)),
          Text(supplier.name,
              style: TextStyle(fontWeight: FontWeight.bold, font: ttf_font)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.address, style: TextStyle(font: ttf_font)),
        ],
      );

  static Widget buildTitle(Invoice invoice, Font ttf_font) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, font: ttf_font),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(invoice.info.description, style: TextStyle(font: ttf_font)),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice, Font ttf_font) {
    final headers = [
      
      'Description',
      'Date',
      'Quantity',
      'Unit Price',
      // 'Con',
      'Total'
    ];
    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity;

      return [
        item.description,
        item.date,
        '${item.quantity}',
        '${item.unitPrice}',
        // '${item.vat} %',
        '${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold, font: ttf_font),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice, Font ttf_font, Customer customer) {
    final netTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    final vatPercent = invoice.items.first.gst;
    final vat = netTotal * vatPercent;
    final total = netTotal + vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                    title: 'Net total',
                    value: '₹ ${Utils.formatPrice(netTotal)}',
                    unite: true,
                    titleStyle: TextStyle(font: ttf_font)),
                buildText(
                    title: 'GST ${vatPercent * 100} %',
                    value: '₹ ${Utils.formatPrice(vat)}',
                    unite: true,
                    titleStyle: TextStyle(font: ttf_font)),
                buildText(
                    title: 'Convinence Fee  ',
                    value: '₹ ${Utils.formatPrice(vat)}',
                    unite: true,
                    titleStyle: TextStyle(font: ttf_font)),
                buildText(
                    title: 'Payment Mode :',
                    value: '${customer.payment_method}',
                    unite: true,
                    titleStyle: TextStyle(font: ttf_font)),
                buildText(
                    title: 'Delivery :',
                    value: '${customer.status}',
                    unite: true,
                    titleStyle: TextStyle(font: ttf_font)),
                Divider(),
                buildText(
                    title: 'Payment Status  ',
                    value: '${customer.payment_status}',
                    unite: true,
                    titleStyle: TextStyle(font: ttf_font)),
                buildText(
                  title: customer.payment_status == "To be Paid" ? 'Amount to Pay': 'Total amount paid',
                  titleStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      font: ttf_font),
                  value: '₹ ${Utils.formatPrice(total)}',
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice, Font ttf_font) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'Address:',
              value: invoice.supplier.address,
              ttf_font: ttf_font),
          SizedBox(height: 1 * PdfPageFormat.mm),
          // buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
        ],
      );

  static buildSimpleText(
      {required String title, required String value, required Font ttf_font}) {
    final style = TextStyle(fontWeight: FontWeight.bold, font: ttf_font);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value, style: TextStyle(font: ttf_font)),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
