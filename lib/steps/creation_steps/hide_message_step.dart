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
  bool _isHiding = true;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _startHidingProcess();
  }

  Future<void> _startHidingProcess() async {
    // 실제 메시지 숨기기 로직이 들어갈 자리입니다.
    // 현재는 시뮬레이션을 위해 딜레이만 추가합니다.
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _isHiding = false;
        _isComplete = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        if (_isHiding) ...[
          const CircularProgressIndicator(
            color: Colors.red,
            strokeWidth: 5,
          ),
          const SizedBox(height: 24),
          const Text(
            '카드에 메시지 숨기는 중...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            '잠시만 기다려주세요',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ] else if (_isComplete) ...[
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.shade50,
            ),
            child: Icon(
              Icons.check_circle,
              size: 60,
              color: Colors.red.shade400,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '카드에 메시지 숨기기 완료!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            '다음 버튼을 눌러주세요.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
