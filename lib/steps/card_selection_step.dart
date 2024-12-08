// lib/pages/steps/card_selection_step.dart

import 'package:flutter/material.dart';

class CardSelectionStep extends StatefulWidget {
  const CardSelectionStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  State<CardSelectionStep> createState() => _CardSelectionStepState();
}

class _CardSelectionStepState extends State<CardSelectionStep> {
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
