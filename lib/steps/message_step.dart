// lib/pages/steps/message_step.dart

import 'package:flutter/material.dart';

class MessageStep extends StatefulWidget {
  const MessageStep({
    super.key,
    required this.onNext,
    required this.messageController,
    required this.toController,
    required this.fromController,
  });

  final VoidCallback onNext;
  final TextEditingController messageController;
  final TextEditingController toController;
  final TextEditingController fromController;

  @override
  State<MessageStep> createState() => _MessageStepState();
}

class _MessageStepState extends State<MessageStep> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(
          child: Text('시크릿 메시지 작성',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: widget.toController,
          decoration: const InputDecoration(
            labelText: '보내는 사람',
            border: OutlineInputBorder(),
          ),
          maxLength: 10,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: widget.messageController,
          maxLines: 10,
          decoration: const InputDecoration(
            labelText: '크리스마스 메시지를 작성해주세요!',
            border: OutlineInputBorder(),
          ),
          maxLength: 200,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: widget.fromController,
          decoration: const InputDecoration(
            labelText: '받는 사람',
            border: OutlineInputBorder(),
          ),
          maxLength: 10,
        ),
      ],
    );
  }
}
