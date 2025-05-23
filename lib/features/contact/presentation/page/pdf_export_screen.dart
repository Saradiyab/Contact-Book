import 'dart:typed_data';
import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/core/constants/colors.dart';
import 'package:contact_app1/features/contact/domain/entities/contact.dart';
import 'package:contact_app1/features/contact/presentation/page/pdf_document_design.dart';
import 'package:contact_app1/core/widgets/custom_appbar.dart';
import 'package:contact_app1/core/widgets/custom_drawer.dart';
import 'package:contact_app1/core/widgets/footer_widget.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:easy_localization/easy_localization.dart';

class PdfExportScreen extends StatefulWidget {
  final List<Contact> contacts;

  const PdfExportScreen({super.key, required this.contacts});

  @override
  State<PdfExportScreen> createState() => _PdfExportScreenState();
}

class _PdfExportScreenState extends State<PdfExportScreen> {
  Uint8List? _logo;

  Future<Uint8List> _generatePdf(Uint8List logo) async {
    final pdf = pw.Document();
    pdf.addPage(pdfDocumentDesign(logo, widget.contacts));
    return pdf.save();
  }

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  Future<void> _loadAssets() async {
    final logoBytes = await rootBundle
        .load('assets/images/logo_blue.png')
        .then((d) => d.buffer.asUint8List());
    setState(() {
      _logo = logoBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      drawer: const CustomDrawer(token: ''),
      body: _logo == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: PdfPreview(
                    build: (_) => _generatePdf(_logo!),
                    canChangePageFormat: false,
                    canChangeOrientation: false,
                    canDebug: false,
                    useActions: false,
                    scrollViewDecoration:
                        const BoxDecoration(color: Colors.white),
                    pdfPreviewPageDecoration:
                        const BoxDecoration(color: Colors.white),
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
                  child: SizedBox(
                    width: 356,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        final pdfData = await _generatePdf(_logo!);
                        await Printing.sharePdf(
                          bytes: pdfData,
                          filename: AppStrings.contactsPdf.tr(), // ✅ .tr()
                        );
                      },
                      child: Text(
                        AppStrings.exportAsPdf.tr(), // ✅ .tr()
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                const FooterWidget(),
              ],
            ),
    );
  }
}
