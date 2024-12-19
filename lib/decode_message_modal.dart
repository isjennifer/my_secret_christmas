// lib/widgets/decode_message_modal.dart

import 'package:flutter/material.dart';
import 'package:my_secret_christmas/sevices/card_encryption_service.dart';
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

  void _handleSubmit([String? value]) {
    final textValue = value ?? _controller.text;
    if (textValue.isEmpty) return;

    try {
      // 복호화된 카드 데이터 받기
      ChristmasCard decryptedCard =
          CardEncryptionService.decryptToCard(textValue);

      // 카드 데이터 출력
      print('복호화된 카드 정보:');
      print('보낸사람: ${decryptedCard.sender}');
      print('받는사람: ${decryptedCard.recipient}');
      print('내용: ${decryptedCard.content}');
      print('카드 이미지: ${decryptedCard.cardImageUrl}');

      // 퀴즈가 있다면 퀴즈 정보도 출력
      if (decryptedCard.quiz != null) {
        print('퀴즈 질문: ${decryptedCard.quiz!.question}');
        print('퀴즈 답변: ${decryptedCard.quiz!.answer}');
        print('힌트1: ${decryptedCard.quiz!.hint1}');
        print('힌트2: ${decryptedCard.quiz!.hint2}');
      }
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DecodeMessagePage(cardData: decryptedCard)),
      );

      // 입력 필드 초기화
      _controller.clear();
    } catch (e) {
      print('오류 발생: $e');
      // 여기에 사용자에게 오류를 알리는 로직을 추가할 수 있습니다.
      // 예: ScaffoldMessenger를 사용한 스낵바 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('메시지 풀기에 실패했어요! 올바른 코드인지 확인해주세요.'),
        ),
      );
    }
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
                  const SizedBox(height: 10),
                  const Text(
                    '카카오톡을 열고,\n내가 받은 시크릿 메시지에서\n\'메시지 풀기\' 버튼을 눌러주세요!',
                    style: TextStyle(fontSize: 18),
                    // textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
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
                        //테스트 버튼
                        // ElevatedButton(
                        //   onPressed: () {
                        //     // 퀴즈 객체 생성
                        //     Quiz mockQuiz = Quiz(
                        //       question: '산타의 썰매를 끄는 루돌프의 코 색깔은?',
                        //       answer: '빨간색',
                        //       hint1: '어두운 밤길을 환하게 밝혀주는 색이에요',
                        //       hint2: '신호등에서 멈춤을 의미하는 색이에요',
                        //     );

                        //     // 크리스마스 카드 객체 생성
                        //     ChristmasCard mockChristmasCard = ChristmasCard(
                        //       sender: '산타',
                        //       content:
                        //           '올해도 수고 많았어요! 내년에도 행복한 일만 가득하길 바랄게요. 메리 크리스마스!\n올해도 수고 많았어요! 내년에도 행복한 일만 가득하길 바랄게요. 메리 크리스마스!\n올해도 수고 많았어요! 내년에도 행복한 일만 가득하길 바랄게요. 메리 크리스마스!\n올해도 수고 많았어요! 내년에도 행복한 일만 가득하길 바랄게요. 메리 크리스마스!\n올해도 수고 많았어요! 내년에도ㅗ오ㅗ오ㅗ오ㅘ하ㅏ라ㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏ\n',
                        //       recipient: '루돌프',
                        //       cardImageUrl: 'assets/cards/card1.jpg',
                        //       quiz: mockQuiz,
                        //     );
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => DecodeMessagePage(
                        //               cardData: mockChristmasCard)),
                        //     );
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Colors.green,
                        //     foregroundColor: Colors.white,
                        //     padding: const EdgeInsets.symmetric(
                        //       vertical: 16,
                        //       horizontal: 24,
                        //     ),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(8),
                        //     ),
                        //   ),
                        //   child: const Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       SizedBox(width: 8),
                        //       Text(
                        //         '테스트 버튼',
                        //         style: TextStyle(
                        //           fontSize: 16,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
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
