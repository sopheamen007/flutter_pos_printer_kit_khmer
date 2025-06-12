import 'package:flutter/material.dart';
import '../services/printer_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final printerService = PrinterService();

  @override
  void initState() {
    super.initState();
    printerService.setConnection(ip: '10.20.60.100', port: 9100); // Dynamic IP/port
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Khmer ESC/POS Printer')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => printerService.printKhmerRawText("សួស្តី! អបអរសាទរ"),
              child: const Text('🖨 Print Raw Khmer Text'),
            ),
            ElevatedButton(
              onPressed: () => printerService.printKhmerTextAsImage("វិក្កយបត្រ: INV-0001"),
              child: const Text('🖨 Print Khmer Text as Image'),
            ),
            ElevatedButton(
              onPressed: () => printerService.printInvoiceImage(),
              child: const Text('🖨 Print Full Invoice Image'),
            ),
          ],
        ),
      ),
    );
  }
}
