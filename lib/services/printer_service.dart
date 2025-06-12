import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class PrinterService {
  late final NetworkPrinter _printer;
  late final CapabilityProfile _profile;
  String _ip = '';
  int _port = 9100;

  void setConnection({required String ip, required int port}) async {
    _ip = ip;
    _port = port;
    _profile = await CapabilityProfile.load();
    _printer = NetworkPrinter(PaperSize.mm80, _profile);
  }

  Future<void> _connectAndExecute(Function(NetworkPrinter) job) async {
    final res = await _printer.connect(_ip, port: _port);
    if (res != PosPrintResult.success) {
      print('❌ Failed to connect: $res');
      return;
    }
    try {
      await job(_printer);
      _printer.feed(2);
      _printer.cut();
    } catch (e) {
      print('❌ Error during print: $e');
    } finally {
      _printer.disconnect();
    }
  }

  Future<void> printKhmerRawText(String text) async {
    await _connectAndExecute((printer) async {
      printer.text(text, styles: PosStyles(codeTable: 'CP1252'));
    });
  }

  Future<void> printKhmerTextAsImage(String khmerText) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final style = TextStyle(
      fontSize: 28,
      fontFamily: 'NotoSansKhmer',
      color: Colors.black,
    );

    final span = TextSpan(text: khmerText, style: style);
    final painter = TextPainter(text: span, textDirection: TextDirection.ltr);
    painter.layout(maxWidth: 576);
    painter.paint(canvas, const Offset(10, 10));

    final picture = recorder.endRecording();
    final image = await picture.toImage(576, 80);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final decoded = img.decodeImage(byteData!.buffer.asUint8List());

    if (decoded != null) {
      await _connectAndExecute((printer) async {
        printer.image(decoded);
      });
    }
  }

  Future<void> printInvoiceImage() async {
    final invoiceImage = await _generateInvoiceImage();
    await _connectAndExecute((printer) async {
      printer.image(invoiceImage);
    });
  }

  Future<img.Image> _generateInvoiceImage() async {
    const double width = 576;
    const double fontSize = 20;
    const double sidePadding = 24;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    double offsetY = 0;

    // Draw Logo
    final logoData = await rootBundle.load('assets/logo.jpg');
    final logoBytes = logoData.buffer.asUint8List();
    final logo = img.decodeImage(logoBytes);
    if (logo != null) {
      final codec = await ui.instantiateImageCodec(Uint8List.fromList(img.encodePng(logo)), targetWidth: 180);
      final frame = await codec.getNextFrame();
      canvas.drawImage(frame.image, Offset((width - 180) / 2, offsetY), Paint());
      offsetY += frame.image.height + 16;
    }

    final textStyle = TextStyle(fontSize: fontSize, fontFamily: 'NotoSansKhmer', color: Colors.black);
    final content = [
      'ក្រុមហ៊ុនសុភមង្គល ឯ.ក',
      '',
      'វិក្កយបត្រ: INV-20250612',
      'ថ្ងៃខែ: 12/06/2025   ម៉ោង: 10:45 AM',
      'អតិថិជន: លោក ដារ៉ា',
      '------------------------------------------',
      'ផលិតផល       បរិមាណ      តម្លៃ',
      'កាហ្វេក្រហម         1       \$2.00',
      'នំខេក               2       \$4.00',
      'ទឹកផ្លែឈើ           1       \$1.50',
      '------------------------------------------',
      'សរុប                 \$7.50',
      'បញ្ចុះតម្លៃ            \$0.50',
      'សរុបចុងក្រោយ         \$7.00',
      '',
      'បង់ដោយ: សាច់ប្រាក់',
      '',
      'សូមអរគុណ!',
    ];

    for (final line in content) {
      final span = TextSpan(text: line, style: textStyle);
      final painter = TextPainter(text: span, textDirection: TextDirection.ltr);
      painter.layout(maxWidth: width - sidePadding * 2);
      painter.paint(canvas, Offset(sidePadding, offsetY));
      offsetY += painter.height + 6;
    }

    final picture = recorder.endRecording();
    final imgData = await picture.toImage(width.toInt(), offsetY.toInt());
    final byteData = await imgData.toByteData(format: ui.ImageByteFormat.png);
    return img.decodeImage(byteData!.buffer.asUint8List())!;
  }
}
