import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_secret_christmas/models/christmas_card.dart';
import 'package:my_secret_christmas/providers/christmas_card_provider.dart';

class QuizStep extends ConsumerStatefulWidget {
  const QuizStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  ConsumerState<QuizStep> createState() => _QuizStepState();
}

class _QuizStepState extends ConsumerState<QuizStep> {
  late TextEditingController questionController;
  late TextEditingController answerController;
  late TextEditingController hint1Controller;
  late TextEditingController hint2Controller;

  @override
  void initState() {
    super.initState();
    final quiz = ref.read(christmasCardProvider).quiz;
    questionController = TextEditingController(text: quiz?.question);
    answerController = TextEditingController(text: quiz?.answer);
    hint1Controller = TextEditingController(text: quiz?.hint1);
    hint2Controller = TextEditingController(text: quiz?.hint2);
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    hint1Controller.dispose();
    hint2Controller.dispose();
    super.dispose();
  }

  void _updateQuiz() {
    final quiz = Quiz(
      question: questionController.text,
      answer: answerController.text,
      hint1: hint1Controller.text,
      hint2: hint2Controller.text,
    );
    ref.read(christmasCardProvider.notifier).updateQuiz(quiz);
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
          controller: questionController,
          decoration: const InputDecoration(
            labelText: '문제를 작성해주세요.',
            border: OutlineInputBorder(),
          ),
          maxLength: 20,
          onChanged: (_) => _updateQuiz(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: answerController,
          decoration: const InputDecoration(
            labelText: '답을 작성해주세요.',
            border: OutlineInputBorder(),
          ),
          maxLength: 10,
          onChanged: (_) => _updateQuiz(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: hint1Controller,
          decoration: const InputDecoration(
            labelText: '첫번째 힌트를 작성해주세요.',
            border: OutlineInputBorder(),
          ),
          maxLength: 10,
          onChanged: (_) => _updateQuiz(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: hint2Controller,
          decoration: const InputDecoration(
            labelText: '두번째 힌트를 작성해주세요.',
            border: OutlineInputBorder(),
          ),
          maxLength: 10,
          onChanged: (_) => _updateQuiz(),
        ),
      ],
    );
  }
}
