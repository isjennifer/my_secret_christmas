import 'package:my_secret_christmas/models/christmas_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final christmasCardProvider = StateNotifierProvider<ChristmasCardNotifier, ChristmasCard>(
  (ref) => ChristmasCardNotifier(),
);

class ChristmasCardNotifier extends StateNotifier<ChristmasCard> {
  ChristmasCardNotifier() : super(ChristmasCard());
  
  // 보내는 사람 업데이트
  void updateSender(String sender) {
    state = ChristmasCard(
      sender: sender,
      content: state.content,
      recipient: state.recipient,
      cardImageUrl: state.cardImageUrl,
      quiz: state.quiz,
    );
  }
  
  // 내용 업데이트
  void updateContent(String content) {
    state = ChristmasCard(
      sender: state.sender,
      content: content,
      recipient: state.recipient,
      cardImageUrl: state.cardImageUrl,
      quiz: state.quiz,
    );
  }
  
  // 받는 사람 업데이트
  void updateRecipient(String recipient) {
    state = ChristmasCard(
      sender: state.sender,
      content: state.content,
      recipient: recipient,
      cardImageUrl: state.cardImageUrl,
      quiz: state.quiz,
    );
  }
  
  // 이미지 URL 업데이트
  void updateCardImage(String imageUrl) {
    state = ChristmasCard(
      sender: state.sender,
      content: state.content,
      recipient: state.recipient,
      cardImageUrl: imageUrl,
      quiz: state.quiz,
    );
  }
  
  // 퀴즈 정보 업데이트
  void updateQuiz(Quiz quiz) {
    state = ChristmasCard(
      sender: state.sender,
      content: state.content,
      recipient: state.recipient,
      cardImageUrl: state.cardImageUrl,
      quiz: quiz,
    );
  }
}