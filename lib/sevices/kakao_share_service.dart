// lib/services/kakao_share_service.dart

import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:my_secret_christmas/sevices/card_encryption_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/christmas_card.dart';
import '../collection_page.dart';

class KakaoShareService {
  static final KakaoShareService _instance = KakaoShareService._internal();
  factory KakaoShareService() => _instance;
  KakaoShareService._internal();

  static const String androidPlayStoreUrl =
      'https://play.google.com/store/apps/details?id=com.example.myapp';
  static const String iOSAppStoreUrl =
      'https://apps.apple.com/app/instagram/id389801252';

  Future<void> shareToKakao({required ChristmasCard card}) async {
    try {
      final encryptedData = CardEncryptionService.encryptCard(card: card);
      print('암호화된 카드 DATA: $encryptedData');

      final template = FeedTemplate(
        content: Content(
          title: '당신을 위한 시크릿 크리스마스 메시지가 도착했어요!',
          description: '메시지 풀기 버튼을 눌러 크리스마스 메시지를 확인하세요!',
          imageUrl: Uri.parse('https://i.ibb.co/6XyrR0V/Secretsmas.png'),
          link: Link(
            iosExecutionParams: {'cardData': encryptedData, 'path': "decode"},
          ),
        ),
        buttons: [
          Button(
            title: '메시지 풀기',
            link: Link(
              iosExecutionParams: {'cardData': encryptedData, 'path': "decode"},
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

        await CollectionPage.incrementCount();
        print('카카오톡 공유 완료!');
      } else {
        launchUrl(
            Uri.parse('https://apps.apple.com/app/kakaotalk/id362057947'));
        print('카카오톡 미설치: 웹 공유 기능 사용 권장');
      }
    } catch (error) {
      print('카카오톡 공유 실패: $error');
      rethrow;
    }
  }
}
