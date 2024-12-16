import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isHidingProvider = StateProvider<bool>((ref) => true);

class HideMessageStep extends ConsumerStatefulWidget {
  const HideMessageStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  ConsumerState<HideMessageStep> createState() => _HideMessageStepState();
}

class _HideMessageStepState extends ConsumerState<HideMessageStep> {
  @override
  void initState() {
    super.initState();
    _startHidingProcess();
  }

  Future<void> _startHidingProcess() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      ref.read(isHidingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHiding = ref.watch(isHidingProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        if (isHiding) ...[
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
        ] else ...[
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
