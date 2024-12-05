// lib/pages/steps/hide_message_step.dart

import 'package:flutter/material.dart';

class HideMessageStep extends StatefulWidget {
  const HideMessageStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  State<HideMessageStep> createState() => _HideMessageStepState();
}

class _HideMessageStepState extends State<HideMessageStep> {
  String? selectedHideMethod;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '메시지를 숨기는 방법을 선택해주세요',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        // 여기에 메시지 숨기기 방법 선택 UI 구현
        const Center(
          child: Text('메시지 숨기기 UI가 구현될 예정입니다'),
        ),
      ],
    );
  }
}
