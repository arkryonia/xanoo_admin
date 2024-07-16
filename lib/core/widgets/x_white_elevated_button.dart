import 'package:flutter/material.dart';

class XWhiteElevatedButton extends StatelessWidget {
  const XWhiteElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
