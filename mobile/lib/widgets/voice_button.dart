// File: lib/widgets/voice_button.dart

import 'package:flutter/material.dart';

/// A floating mic button for voice commands. Changes color when listening.
class VoiceButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isListening;

  const VoiceButton({
    super.key,
    required this.onPressed,
    this.isListening = false,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: isListening ? Colors.red : Colors.blue,
      child: Icon(isListening ? Icons.mic : Icons.mic_none),
    );
  }
}