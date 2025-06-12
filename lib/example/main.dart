import 'package:flutter/material.dart';
import 'package:pos_printer_kit_khmer/services/printer_service.dart';

void main() {
  runApp(const MyPrinterApp());
}

class MyPrinterApp extends StatelessWidget {
  const MyPrinterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS Printer Khmer Demo',
      debugShowCheckedModeBanner: false,
      home: const PrinterExamplePage(),
    );
  }
}

class PrinterExamplePage extends StatefulWidget {
  const PrinterExamplePage({super.key});

  @override
  State<PrinterExamplePage> createState() => _PrinterExamplePageState();
}

class _PrinterExamplePageState extends State<PrinterExamplePage> {
  final PrinterService printerService = PrinterService();
  final GlobalKey captureKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _connectToPrinter();
  }

  Future<void> _connectToPrinter() async {
    
    const String ip = '192.168.0.100'; // your printer ip for eg. 168.10.10.0
    const int port = 9100;
    printerService.setConnection(ip: ip, port: port); // Replace with your actual IP
  }

  Future<void> _printRawText() async {
    await printerService.printKhmerRawText(
      'វិក្កយបត្រ INV-001\nអតិថិជន: លោក ចាន់ដារ៉ា\nសរុប: \$10.00\nសូមអរគុណ!',
    );
  }

  Future<void> _printTextAsImage() async {
    await printerService.printKhmerTextAsImage('វិក្កយបត្រ: INV-0001');
  }

  Future<void> _printInvoiceImage() async {
    await printerService.printInvoiceImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('POS Printer Khmer Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _printRawText,
              child: const Text('1. Print Khmer Raw Text'),
            ),
            ElevatedButton(
              onPressed: _printTextAsImage,
              child: const Text('2. Print Khmer Text as Image'),
            ),
            ElevatedButton(
              onPressed: _printInvoiceImage,
              child: const Text('3. Print Invoice as Image'),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text('Sample Invoice Preview:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            RepaintBoundary(
              key: captureKey,
              child: Card(
                color: Colors.grey.shade100,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: const [
                      Text('វិក្កយបត្រ INV-001', style: TextStyle(fontSize: 16)),
                      Text('អតិថិជន: លោក ចាន់ដារ៉ា'),
                      Text('សរុប: \$10.00'),
                      Text('សូមអរគុណ!', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
