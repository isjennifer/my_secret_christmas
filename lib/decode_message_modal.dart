// lib/widgets/decode_message_modal.dart

import 'package:flutter/material.dart';
import 'package:my_secret_christmas/steps/open_steps/decode_message_step.dart';
import 'package:my_secret_christmas/models/christmas_card.dart';

class DecodeMessageModal extends StatefulWidget {
  const DecodeMessageModal({super.key});

  @override
  State<DecodeMessageModal> createState() => _DecodeMessageModalState();
}

class _DecodeMessageModalState extends State<DecodeMessageModal> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_controller.text.isEmpty) return;

    // 여기에 제출 로직 구현
    print('제출된 메시지: ${_controller.text}');

    // 입력 필드 초기화
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.lock_open,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '시크릿 메시지 풀기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    '나에게 전송된 시크릿 메시지의\n고유코드를 입력해주세요.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                decoration: InputDecoration(
                                  hintText: '코드를 입력하세요',
                                  contentPadding: const EdgeInsets.all(16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                onSubmitted: (_) => _handleSubmit(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _handleSubmit,
                              child: const Text('제출'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // 테스트 버튼
                        ElevatedButton(
                          onPressed: () {
                            // 퀴즈 객체 생성
                            Quiz mockQuiz = Quiz(
                              question: '산타의 썰매를 끄는 루돌프의 코 색깔은?',
                              answer: '빨간색',
                              hint1: '어두운 밤길을 환하게 밝혀주는 색이에요',
                              hint2: '신호등에서 멈춤을 의미하는 색이에요',
                            );

                            // 크리스마스 카드 객체 생성
                            ChristmasCard mockChristmasCard = ChristmasCard(
                              sender: '산타',
                              content:
                                  '올해도 수고 많았어요! 내년에도 행복한 일만 가득하길 바랄게요. 메리 크리스마스!',
                              recipient: '루돌프',
                              cardImageUrl: 'assets/christmas_card.png',
                              quiz: mockQuiz,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DecodeMessagePage(
                                      cardData: mockChristmasCard)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 8),
                              Text(
                                '테스트 버튼',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
