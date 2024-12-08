class ChristmasCard {
  String? sender;        // 보내는 사람
  String? content;       // 내용
  String? recipient;     // 받는 사람
  String? cardImageUrl;  // 크리스마스 카드 이미지
  Quiz? quiz;           // 퀴즈 정보
  
  ChristmasCard({
    this.sender,
    this.content,
    this.recipient,
    this.cardImageUrl,
    this.quiz,
  });
  
  // JSON 직렬화를 위한 메서드
  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'content': content,
      'recipient': recipient,
      'cardImageUrl': cardImageUrl,
      'quiz': quiz?.toJson(),
    };
  }
  
  // JSON에서 객체 생성을 위한 팩토리 생성자
  factory ChristmasCard.fromJson(Map<String, dynamic> json) {
    return ChristmasCard(
      sender: json['sender'],
      content: json['content'],
      recipient: json['recipient'],
      cardImageUrl: json['cardImageUrl'],
      quiz: json['quiz'] != null ? Quiz.fromJson(json['quiz']) : null,
    );
  }
}

class Quiz {
  String? question;    // 퀴즈 문제
  String? answer;      // 퀴즈 답
  String? hint1;       // 퀴즈 힌트1
  String? hint2;       // 퀴즈 힌트2
  
  Quiz({
    this.question,
    this.answer,
    this.hint1,
    this.hint2,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'hint1': hint1,
      'hint2': hint2,
    };
  }
  
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      question: json['question'],
      answer: json['answer'],
      hint1: json['hint1'],
      hint2: json['hint2'],
    );
  }
}
