import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:my_secret_christmas/models/christmas_card.dart';
import 'package:my_secret_christmas/collection_page.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> shareToKakao({required ChristmasCard card}) async {
    try {
      final encryptedData = encryptCard(card: card);
      print('암호화된 카드 DATA: $encryptedData');

      final template = TextTemplate(
        text: '앱을 열고 메시지 풀기 버튼을 눌러 아래 코드를 복사해 붙여넣기 해주세요! $encryptedData',
        link: Link(
          webUrl: Uri.parse(iOSAppStoreUrl),
          mobileWebUrl: Uri.parse(iOSAppStoreUrl),
        ),
        buttons: [
          Button(
            title: '앱 열기',
            link: Link(
              iosExecutionParams: {'cardData': encryptedData},
            ),
          ),
          Button(
            title: '앱 다운로드',
            link: Link(
              webUrl: Uri.parse(iOSAppStoreUrl),
              mobileWebUrl: Uri.parse(iOSAppStoreUrl),
            ),
          ),
        ],
      );

      bool isKakaoTalkSharingAvailable =
          await ShareClient.instance.isKakaoTalkSharingAvailable();

      if (isKakaoTalkSharingAvailable) {
        print('카카오톡으로 공유 가능');
        Uri uri = await ShareClient.instance.shareDefault(template: template);
        await ShareClient.instance.launchKakaoTalk(uri);

        // 공유횟수 증가
        await CollectionPage.incrementCount();
        print('카카오톡 공유 완료!');
      } else {
        //카카오톡 설치페이지로 이동
        launchUrl(
            Uri.parse('https://apps.apple.com/app/kakaotalk/id362057947'));
        print('카카오톡 미설치: 웹 공유 기능 사용 권장');
      }
    } catch (error) {
      print('카카오톡 공유 실패: $error');
    }
  }

  static encrypt.Encrypter _createEncrypter() {
    final key = encrypt.Key.fromUtf8(_secretKey.padRight(32, '0'));
    return encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
  }

  /// 카드 데이터를 암호화하는 메서드
  static String encryptCard({required ChristmasCard card}) {
    try {
      final encrypter = _createEncrypter();

      // JSON 변환 전에 데이터 검증
      assert(card.sender != null, 'sender는 null일 수 없습니다');

      // null 값 제거 및 JSON 변환
      final Map<String, dynamic> jsonMap = card.toJson();
      jsonMap.removeWhere((key, value) => value == null);
      final String cardJson = jsonEncode(jsonMap);

      print('암호화할 JSON: $cardJson'); // 암호화 전 데이터 확인

      // 암호화
      final encrypted = encrypter.encrypt(cardJson, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      print('카드 데이터 암호화 실패: $e');
      throw Exception('카드 데이터 암호화에 실패했습니다');
    }
  }

  /// 암호화된 데이터를 복호화하여 카드 객체로 변환하는 메서드
  static ChristmasCard decryptToCard(String encryptedData) {
    try {
      final encrypter = _createEncrypter();

      // Base64 디코딩 및 복호화
      final encrypted = encrypt.Encrypted.fromBase64(encryptedData);
      final decrypted = encrypter.decrypt(encrypted, iv: _iv);

      print('복호화된 JSON: $decrypted'); // 복호화된 데이터 확인

      // JSON 파싱 및 객체 변환
      final Map<String, dynamic> cardJson = jsonDecode(decrypted);

      // sender 필드 확인
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
