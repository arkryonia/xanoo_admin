import 'package:flutter/material.dart';

void showSnakeBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 30),
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
}
