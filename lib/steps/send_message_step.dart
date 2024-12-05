// lib/pages/steps/send_message_step.dart

import 'package:flutter/material.dart';

class SendMessageStep extends StatelessWidget {
  const SendMessageStep({
    super.key,
    required this.onComplete,
    required this.onPrevious,
  });

  final VoidCallback onComplete;
  final VoidCallback onPrevious;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '메시지 미리보기',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        // 여기에 메시지 미리보기 및 전송 확인 UI 구현
        const Center(
          child: Text('메시지 미리보기 및 전송 UI가 구현될 예정입니다'),
        ),
      ],
    );
  }
}
