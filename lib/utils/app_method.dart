import 'package:flutter/material.dart';

class AppMethod {
  static Future<bool> deleteConfirmatinDialog(
    context,
    String title,
    String content,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text("Delete"),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
