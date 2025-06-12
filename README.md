# 🧾 POS Printer Kit Khmer

A Flutter plugin to print Khmer invoices on ESC/POS network thermal printers. This package allows:

✅ Khmer Unicode Text  
✅ Receipt as Image  
✅ Custom Layout Screenshot Printing  
✅ Full-width support for 80mm paper  

---

## 🚀 Features

- Print Khmer text using a custom font
- Render invoice layout as image
- Print from screenshot
- Easily connect to printer via IP and port

---

## 🛠 Installation

Add to your `pubspec.yaml`:
```yaml
pos_printer_kit_khmer: ^1.0.0

```

## 📦 Usage

### Import and Connect

```dart
import 'package:pos_printer_kit_khmer/pos_printer_kit_khmer.dart';

final printerService = PosPrinterService();

// Connect to your printer (IP and port must be correct)
await printerService.connect(ip: 'your printer ip for eg. 168.10.10.0', port: 9100);

```
### ✅ Khmer Unicode Text 

```dart

await printerService.printKhmerRawText([
  'វិក្កយបត្រ INV-001',
  'អតិថិជន: លោក ចាន់ដារ៉ា',
  'សរុប: \$10.00',
  'សូមអរគុណ!',
]);

```
### ✅ Receipt as Image 

```dart

await printerService.printKhmerTextAsImage('វិក្កយបត្រ: INV-0001');

```
### ✅ Full-width support for 80mm paper  

```dart

await printerService.printInvoiceImage(
  title: 'COMPANY NAME CO., LTD.',
  customer: 'លោក ចាន់ដារ៉ា',
  invoiceNo: 'INV-001',
  dateTime: DateTime.now(),
  items: [
    InvoiceItem(name: 'កាហ្វេក្រហម', qty: 1, price: 2.0),
    InvoiceItem(name: 'នំខេក', qty: 2, price: 4.0),
    InvoiceItem(name: 'ទឹកផ្លែឈើ', qty: 1, price: 1.5),
  ],
  discount: 0.5,
  paymentMethod: 'សាច់ប្រាក់',
);

```
### ✅ Custom Layout Screenshot Printing

```dart
final GlobalKey captureKey = GlobalKey();

RepaintBoundary(
  key: captureKey,
  child: YourInvoiceWidget(),
);

await printerService.printFromScreenshot(captureKey);

```