import 'dart:typed_data';
import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/features/contact/domain/entities/contact.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:easy_localization/easy_localization.dart';

Page pdfDocumentDesign(Uint8List logoBytes, List<Contact> contacts) {
  return Page(
    pageFormat: PdfPageFormat.a4,
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    build: (context) => Container(
      decoration: BoxDecoration(
        border: Border.all(color: PdfColors.grey, width: 0.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildHeader(logoBytes),
          SizedBox(height: 20),
          _buildTable(contacts, logoBytes),
          SizedBox(height: 15),
          Spacer(),
        ],
      ),
    ),
  );
}

Widget _buildHeader(Uint8List logo) => Image(
      MemoryImage(logo),
      width: 280,
    );

Widget _buildTable(List<Contact> contacts, Uint8List fallbackAvatar) {
  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    columnWidths: const {
      0: FlexColumnWidth(1.2),
      1: FlexColumnWidth(1.2),
      2: FlexColumnWidth(2),
      3: FlexColumnWidth(2),
      4: FlexColumnWidth(4),
      5: FlexColumnWidth(3),
    },
    children: [
      TableRow(
        decoration: const BoxDecoration(color: PdfColors.black),
        children: [
          _cell(AppStrings.id.tr(), isHeader: true),
          _cell(AppStrings.image.tr(), isHeader: true),
          _cell(AppStrings.firstName.tr(), isHeader: true),
          _cell(AppStrings.lastName.tr(), isHeader: true),
          _cell(AppStrings.email.tr(), isHeader: true),
          _cell(AppStrings.phone.tr(), isHeader: true),
        ],
      ),
      ...List.generate(contacts.length, (i) {
        final c = contacts[i];
        final avatarProvider = MemoryImage(fallbackAvatar);
        return TableRow(
          decoration: const BoxDecoration(color: PdfColors.white),
          children: [
            _cell(c.id?.toString() ?? ''),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Center(
                child: ClipOval(
                  child: Image(avatarProvider, width: 18, height: 18),
                ),
              ),
            ),
            _cell(c.firstName),
            _cell(c.lastName),
            _cell(c.email),
            _cell(c.phoneNumber),
          ],
        );
      }),
    ],
  );
}

Widget _cell(String text, {bool isHeader = false}) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isHeader ? 14 : 12,
          color: isHeader ? PdfColors.white : PdfColors.black,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
