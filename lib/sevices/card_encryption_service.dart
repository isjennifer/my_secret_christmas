import 'dart:convert';
import 'package:my_secret_christmas/models/christmas_card.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class CardEncryptionService {
  // 암호화 관련 상수
  static const String _secretKey = 'secretchristmas';

  // 앱 스토어 다운로드 링크
  static const String androidPlayStoreUrl =
      'https://play.google.com/store/apps/details?id=com.example.myapp';
  // static const String iOSAppStoreUrl = 'https://apps.apple.com';
  static const String iOSAppStoreUrl =
      'https://apps.apple.com/app/instagram/id389801252';
  //app/id123456789

  // IV를 고정된 값으로 설정
  static final _iv = encrypt.IV.fromUtf8('ChristmasCardIV1'); // 16바이트 IV
  // 리소스 해제를 위한 dispose 메서드 추가
  void dispose() {}

  static encrypt.Encrypter _createEncrypter() {
    final key = encrypt.Key.fromUtf8(_secretKey.padRight(32, '0'));
    return encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
  }

  static String encryptCard({required ChristmasCard card}) {
    try {
      final encrypter = _createEncrypter();

      assert(card.sender != null, 'sender는 null일 수 없습니다');

      final Map<String, dynamic> jsonMap = card.toJson();
      jsonMap.removeWhere((key, value) => value == null);
      final String cardJson = jsonEncode(jsonMap);

      print('암호화할 JSON: $cardJson');

      final encrypted = encrypter.encrypt(cardJson, iv: _iv);

      // base64Url로 직접 인코딩
      return base64Url.encode(encrypted.bytes);
    } catch (e) {
      print('카드 데이터 암호화 실패: $e');
      throw Exception('카드 데이터 암호화에 실패했습니다');
    }
  }

  static ChristmasCard decryptToCard(String encryptedData) {
    try {
      final encrypter = _createEncrypter();

      // base64Url로 디코딩한 bytes를 직접 Encrypted로 변환
      final encrypted = encrypt.Encrypted(base64Url.decode(encryptedData));
      final decrypted = encrypter.decrypt(encrypted, iv: _iv);

      print('복호화된 JSON: $decrypted');

      final Map<String, dynamic> cardJson = jsonDecode(decrypted);

      if (!cardJson.containsKey('sender')) {
        throw FormatException('sender 필드가 누락되었습니다');
      }

      return ChristmasCard.fromJson(cardJson);
    } catch (e) {
      print('카드 데이터 복호화 실패: $e');
      throw Exception('카드 데이터 복호화에 실패했습니다');
    }
  }

  /// 디버깅용 메서드
  static void debugEncryption(ChristmasCard card) {
    try {
      final jsonMap = card.toJson();
      final cardJson = jsonEncode(jsonMap);
      print('원본 JSON: $cardJson');

      final encrypted = encryptCard(card: card);
      print('암호화된 데이터: $encrypted');

      final decrypted = decryptToCard(encrypted);
      print('복호화된 카드 정보:');
      print('sender: ${decrypted.sender}');
      print('content: ${decrypted.content}');
      print('recipient: ${decrypted.recipient}');
    } catch (e) {
      print('디버깅 중 에러: $e');
    }
  }
}
