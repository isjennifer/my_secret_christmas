// lib/widgets/decode_message_modal.dart

import 'package:flutter/material.dart';
import 'package:my_secret_christmas/steps/open_steps/decode_message_step.dart';
import 'package:my_secret_christmas/models/christmas_card.dart';

class DecodeMessageModal extends StatelessWidget {
  const DecodeMessageModal({super.key});

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
                    '나에게 전송된 시크릿 메시지의\n링크를 클릭해주세요.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // 카카오톡 열기 로직
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFE812),
                            foregroundColor: Colors.black,
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
                              Image(
                                image: AssetImage('assets/kakao.png'),
                                width: 26,
                                height: 26,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '카카오톡 열기',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            // 인스타그램 열기 로직
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE4405F),
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
                              Image(
                                image: AssetImage('assets/instagram.png'),
                                width: 26,
                                height: 26,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '인스타그램 열기',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 테스트 버튼
                        const SizedBox(height: 12),
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
