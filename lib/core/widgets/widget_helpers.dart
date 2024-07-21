import 'package:flutter/material.dart';

void showSnakeBar(
  BuildContext context,
  String message, [
  Color color = Colors.red,
]) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 30),
        content: Text(message),
        backgroundColor: color,
      ),
    );
}
