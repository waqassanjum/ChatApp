import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUSer;
  const ChatBubble(
      {super.key, required this.message, required this.isCurrentUSer});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: isCurrentUSer ? Colors.green : Colors.grey.shade500,
          borderRadius: BorderRadius.circular(18)),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
