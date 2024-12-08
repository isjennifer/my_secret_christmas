// lib/pages/steps/quiz_step.dart

import 'package:flutter/material.dart';

class QuizStep extends StatefulWidget {
  const QuizStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  State<QuizStep> createState() => _QuizStepState();
}

class _QuizStepState extends State<QuizStep> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(
          child: Text(
            '나만의 퀴즈 내기',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 5),
        const Center(
          child: Text('받는 사람은 퀴즈를 맞히면 숨겨진 메시지를 볼 수 있어요!'),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _questionController,
          decoration: const InputDecoration(
            labelText: '문제를 작성해주세요.',
            border: OutlineInputBorder(),
          ),
          maxLength: 20,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _answerController,
          decoration: const InputDecoration(
            labelText: '답을 작성해주세요.',
            border: OutlineInputBorder(),
          ),
          maxLength: 10,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _answerController,
          decoration: const InputDecoration(
            labelText: '첫번째 힌트를 작성해주세요.',
            border: OutlineInputBorder(),
          ),
          maxLength: 20,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _answerController,
          decoration: const InputDecoration(
            labelText: '두번째 힌트를 작성해주세요.',
            border: OutlineInputBorder(),
          ),
          maxLength: 20,
        ),
      ],
    );
  }
}
