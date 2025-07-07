// File: lib/widgets/error_message.dart

import 'package:flutter/material.dart';

/// A simple widget for displaying error messages in red text.
class ErrorMessage extends StatelessWidget {
  final String? message;

  const ErrorMessage({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    if (message == null || message!.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        message!,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}