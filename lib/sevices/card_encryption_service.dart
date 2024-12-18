import 'dart:async';
import 'dart:convert';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:my_secret_christmas/models/christmas_card.dart';
import 'package:my_secret_christmas/collection_page.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class CardEncryptionService {
  // 암호화 관련 상수
  static const String _secretKey = 'secretchristmas';

  // 앱 스토어 다운로드 링크
  static const String androidPlayStoreUrl =
      'https://play.google.com/store/apps/details?id=com.example.myapp';
  // static const String iOSAppStoreUrl = 'https://apps.apple.com';
  static const String iOSAppStoreUrl = 'https://apps.apple.com/app/instagram/id389801252';
  //app/id123456789

  // 고정 IV (16바이트)
  static final _iv = encrypt.IV.fromLength(16);
  // 리소스 해제를 위한 dispose 메서드 추가
  void dispose() {}

  Future<void> shareToKakao({required ChristmasCard card}) async {
    try {
      final encryptedData = encryptCard(card: card);
      print('암호화된 카드 DATA: $encryptedData');

      final template = TextTemplate(
        text:  encryptedData,
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
        print('카카오톡 미설치: 웹 공유 기능 사용 권장');
      }
    } catch (error) {
      print('카카오톡 공유 실패: $error');
    }
  }

  /// 카드 데이터를 암호화하는 메서드
  static String encryptCard({required ChristmasCard card}) {
    try {
      // 암호화 키 설정 (32바이트)
      final key = encrypt.Key.fromUtf8(_secretKey.padRight(32, '0'));
      final encrypter = encrypt.Encrypter(encrypt.AES(key));


      // 카드 데이터를 JSON으로 변환
      final String cardJson = jsonEncode(card.toJson());

      // AES 암호화 수행
      final encrypted = encrypter.encrypt(cardJson, iv: _iv);

      return encrypted.base64;
    } catch (e) {
      print('카드 데이터 암호화 실패: $e');
      throw Exception('카드 데이터 암호화에 실패했습니다');
    }
  }

  /// 암호화된 데이터를 복호화하여 카드 객체로 변환하는 메서드
  static ChristmasCard decryptToCard(String encryptedData, String ivString) {
    try {
      // 암호화 키 설정 (32바이트)
      final key = encrypt.Key.fromUtf8(_secretKey.padRight(32, '0'));
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      // 복호화 수행
      final decrypted = encrypter.decrypt64(encryptedData, iv: _iv);

      // JSON 디코딩 후 ChristmasCard 객체로 변환
      final Map<String, dynamic> cardJson = jsonDecode(decrypted);
      return ChristmasCard.fromJson(cardJson);
    } catch (e) {
      print('카드 데이터 복호화 실패: $e');
      throw Exception('카드 데이터 복호화에 실패했습니다');
    }
  }
}