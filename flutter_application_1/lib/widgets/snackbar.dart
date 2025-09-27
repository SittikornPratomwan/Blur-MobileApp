import 'package:flutter/material.dart';

void CustomSnackBar(BuildContext context, Widget content) {
  final snackBar = SnackBar(
    content: content,
    backgroundColor: Colors.black54,
    duration: const Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    margin: const EdgeInsets.all(16.0),
  );
  
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}