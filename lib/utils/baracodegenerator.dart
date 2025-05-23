import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';

class MyBarcodeWidget extends StatelessWidget {
  final String data;
  final double width;
  final double height;
  final Barcode? barcodeType;

  const MyBarcodeWidget({
    Key? key,
    required this.data,
    this.width = 200,
    this.height = 80,
    this.barcodeType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarcodeWidget(
      barcode: barcodeType ?? Barcode.code128(),
      data: data,
      width: width,
      height: height,
      drawText: true,
      errorBuilder: (context, error) =>
          Text('❌ Invalid data: $error'),
    );
  }
}
