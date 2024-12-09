// lib/pages/steps/card_selection_step.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_secret_christmas/providers/christmas_card_provider.dart';

class CardSelectionStep extends ConsumerStatefulWidget  {
  const CardSelectionStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  ConsumerState<CardSelectionStep> createState() => _CardSelectionStepState();
}

class _CardSelectionStepState extends ConsumerState<CardSelectionStep> {
  int? selectedCardIndex;

  // 카드 이미지 리스트
  final List<String> cardImages = [
    'assets/cards/card1.jpg',
    'assets/cards/card2.jpg',
    'assets/cards/card3.jpg',
    'assets/cards/card4.jpg',
    'assets/cards/card5.jpg',
    'assets/cards/card6.jpg',
  ];
  @override
  void initState() {
    super.initState();
    // 초기 상태 설정: 이미 선택된 카드가 있는 경우 해당 인덱스 설정
    final cardImageUrl = ref.read(christmasCardProvider).cardImageUrl;
    if (cardImageUrl != null) {
      final index = cardImages.indexOf(cardImageUrl);
      if (index != -1) {
        setState(() {
          selectedCardIndex = index;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(
          child: Text(
            '크리스마스 카드 선택',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 5),
        const Center(
          child: Text('메시지를 숨길 크리스마스 카드를 선택해주세요!'),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75, // 카드의 세로가 가로보다 길게
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedCardIndex = index;
                });
                // Riverpod provider를 통해 선택된 카드 이미지 업데이트
                ref.read(christmasCardProvider.notifier)
                   .updateCardImage(cardImages[index]);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedCardIndex == index
                        ? Colors.red
                        : Colors.transparent,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Stack(
                    children: [
                      Image.asset(
                        cardImages[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      if (selectedCardIndex == index)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
