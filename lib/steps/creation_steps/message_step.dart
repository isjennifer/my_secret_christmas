import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_secret_christmas/providers/christmas_card_provider.dart';

class MessageStep extends ConsumerStatefulWidget {
  const MessageStep({
    super.key,
    required this.onNext,
  });

  final VoidCallback onNext;

  @override
  ConsumerState<MessageStep> createState() => _MessageStepState();
}

class _MessageStepState extends ConsumerState<MessageStep> {
  late TextEditingController senderController;
  late TextEditingController contentController;
  late TextEditingController recipientController;

  @override
  void initState() {
    super.initState();
    final card = ref.read(christmasCardProvider);
    senderController = TextEditingController(text: card.sender);
    contentController = TextEditingController(text: card.content);
    recipientController = TextEditingController(text: card.recipient);
  }

  @override
  void dispose() {
    senderController.dispose();
    contentController.dispose();
    recipientController.dispose();
    super.dispose();
  }

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
          controller: senderController,
          decoration: const InputDecoration(
            labelText: '보내는 사람',
            border: OutlineInputBorder(),
          ),
          maxLength: 10,
          onChanged: (value) {
            ref.read(christmasCardProvider.notifier).updateSender(value);
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: contentController,
          maxLines: 10,
          decoration: const InputDecoration(
            labelText: '크리스마스 메시지를 작성해주세요!',
            border: OutlineInputBorder(),
          ),
          maxLength: 200,
          onChanged: (value) {
            ref.read(christmasCardProvider.notifier).updateContent(value);
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: recipientController,
          decoration: const InputDecoration(
            labelText: '받는 사람',
            border: OutlineInputBorder(),
          ),
          maxLength: 10,
          onChanged: (value) {
            ref.read(christmasCardProvider.notifier).updateRecipient(value);
          },
        ),
      ],
    );
  }
}