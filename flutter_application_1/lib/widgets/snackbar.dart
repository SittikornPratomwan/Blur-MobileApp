import 'package:flutter/material.dart';

void CustomSnackBar(BuildContext context, Widget content) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: content,
      action: SnackBarAction(
        label: 'CLOSE',
        onPressed: scaffold.hideCurrentSnackBar,
      ),
    ),
  );
}