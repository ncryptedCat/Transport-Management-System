import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingDialog {
  static void show(BuildContext context, {String message = "Loading...", int loaderType = 1}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      useRootNavigator: true, // ✅ Important
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50,
                  child: LoadingIndicator(
                    indicatorType: Indicator.values[loaderType - 1], // Convert index to enum
                    colors: [Colors.blue, Colors.green, Colors.red],
                  ),
                ),
                SizedBox(height: 15),
                Text(message, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  static void dismiss(BuildContext context) {
    Navigator.pop(context);
  }
}
