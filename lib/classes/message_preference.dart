import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Message {
  final String sender;
  final String content;
  final String recipient;
  //final String? timestamp; // 선택적으로 시간도 저장

  Message({
    required this.sender,
    required this.content,
    required this.recipient,
    //this.timestamp,
  });

  // Message 객체를 Map으로 변환
  Map<String, dynamic> toJson() => {
        'sender': sender,
        'content': content,
        'recipient': recipient,
        //'timestamp': timestamp ?? DateTime.now().toIso8601String(),
      };

  // Map에서 Message 객체로 변환
  factory Message.fromJson(Map<String, dynamic> json) => Message(
        sender: json['sender'],
        content: json['content'],
        recipient: json['recipient'],
        //timestamp: json['timestamp'],
      );
}

class MessagePreferences {
  static const String MESSAGES_KEY = 'messages';

  // 새 메시지 추가
  static Future<void> addMessage({
    required String sender,
    required String content,
    required String recipient,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final messages = await loadMessages();

    messages.add(Message(
      sender: sender,
      content: content,
      recipient: recipient,
      //timestamp: DateTime.now().toIso8601String(),
    ));

    final messagesJson = messages.map((m) => m.toJson()).toList();
    await prefs.setString(MESSAGES_KEY, jsonEncode(messagesJson));
  }

  // 모든 메시지 불러오기
  static Future<List<Message>> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesString = prefs.getString(MESSAGES_KEY);

    if (messagesString == null) return [];

    final messagesList = jsonDecode(messagesString) as List;
    return messagesList.map((msgJson) => Message.fromJson(msgJson)).toList();
  }

  // 특정 받는 사람의 메시지만 불러오기
  static Future<List<Message>> loadMessagesByRecipient(String recipient) async {
    final messages = await loadMessages();
    return messages.where((msg) => msg.recipient == recipient).toList();
  }

  // 특정 보낸 사람의 메시지만 불러오기
  static Future<List<Message>> loadMessagesBySender(String sender) async {
    final messages = await loadMessages();
    return messages.where((msg) => msg.sender == sender).toList();
  }

  // 메시지 삭제
  static Future<void> deleteMessage(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final messages = await loadMessages();

    if (index >= 0 && index < messages.length) {
      messages.removeAt(index);
      final messagesJson = messages.map((m) => m.toJson()).toList();
      await prefs.setString(MESSAGES_KEY, jsonEncode(messagesJson));
    }
  }

  // 모든 메시지 삭제
  static Future<void> clearAllMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(MESSAGES_KEY);
  }
}
