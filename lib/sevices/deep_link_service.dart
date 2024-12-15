import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:my_secret_christmas/main.dart';
import 'package:my_secret_christmas/models/christmas_card.dart';
import 'package:my_secret_christmas/steps/open_steps/decode_message_step.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class DeepLinkHandler {
  static final DeepLinkHandler _instance = DeepLinkHandler._internal();
  factory DeepLinkHandler() => _instance;
  DeepLinkHandler._internal();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String scheme = 'myapp';
  static const String host = 'decode';
  static const String androidPackageName = 'com.example.myapp';
  static const String iOSAppStoreId = '123456789';

  Future<void> initUniLinks() async {
    try {
      print('Deep Link 초기화 시작...');
      final initialUri = await getInitialUri();
      print('Initial URI: $initialUri');
      if (initialUri != null) {
        _handleLink(initialUri);
      }

      uriLinkStream.listen((Uri? uri) {
        print('수신된 딥링크: $uri');
        if (uri != null) _handleLink(uri);
      }, onError: (err) {
        print('딥링크 스트림 에러: $err');
      });
    } catch (e) {
      print('딥링크 초기화 에러: $e');
    }
  }

  void _handleLink(Uri uri) {
    print('==== 딥링크 처리 시작 ====');
    print('수신된 URI: $uri');
    print('스킴: ${uri.scheme}');
    print('호스트: ${uri.host}');
    print('경로: ${uri.path}');
    print('쿼리 파라미터: ${uri.queryParameters}');

    if (uri.scheme == scheme && uri.host == 'decode') {
      final cardData = uri.queryParameters['cardData'];
      print('카드 데이터: $cardData');

      if (cardData != null) {
        try {
          final decodedBytes = base64Decode(cardData);
          final decodedJson = utf8.decode(decodedBytes);
          final cardDataMap = jsonDecode(decodedJson);
          print('디코딩된 카드 데이터: $cardDataMap');

          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                // builder: (context) => DecodeMessagePage(cardData: cardDataMap),
                // builder: (context) => DecodeMessagePage(),
                builder: (context) => MyHomePage(title: 'Merry Secret Christmas'),
              ),
            );
          });
        } catch (e) {
          print('카드 데이터 디코딩 에러: $e');
          _navigateToDecodePage();
        }
      } else {
        print('카드 데이터 없음');
        _navigateToDecodePage();
      }
    }
  }

  Future<void> shareToKakao({required ChristmasCard card}) async {
    try {
      // JSON으로 변환하고 base64로 인코딩
      final String cardJson = jsonEncode(card.toJson());
      final String encodedCard = base64Encode(utf8.encode(cardJson));

      // iOS용 URL 스킴 설정
      final iosScheme = '$scheme://decode';

      final template = FeedTemplate(
        content: Content(
          title: '크리스마스 시크릿 메시지가 도착했어요!',
          description: '지금 바로 확인해보세요!',
          imageUrl: Uri.parse('assets/book.png'),
          link: Link(
            webUrl: Uri.parse(iosScheme),
            mobileWebUrl: Uri.parse(iosScheme),
          ),
        ),
        buttons: [
          Button(
            title: '메시지 확인하기',
            link: Link(
              androidExecutionParams: {
                'path': 'decode',
                'cardData': encodedCard,
              },
              iosExecutionParams: {
                'path': 'decode',
                'cardData': encodedCard,
              },
              // iOS Universal Link 지원
              mobileWebUrl: Uri.parse('$iosScheme?cardData=$encodedCard'),
              webUrl: Uri.parse('$iosScheme?cardData=$encodedCard'),
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
        print('카카오톡 공유 완료!');
      } else {
        print('카카오톡 미설치: 웹 공유 기능 사용 권장');
      }
    } catch (error) {
      print('카카오톡 공유 실패: $error');
    }
  }

  void _navigateToDecodePage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => const DecodeMessagePage(),
        ),
      );
    });
  }

  Future<void> handleAppLink() async {
    // pageId 파라미터 제거
    final appScheme = '$scheme://$host';

    try {
      final canLaunch = await canLaunchUrl(Uri.parse(appScheme));
      if (canLaunch) {
        await launchUrl(Uri.parse(appScheme));
        return;
      }

      if (Platform.isAndroid) {
        final playStoreUrl = 'market://details?id=$androidPackageName';
        await launchUrl(Uri.parse(playStoreUrl));
      } else if (Platform.isIOS) {
        final appStoreUrl = 'https://apps.apple.com/app/id$iOSAppStoreId';
        await launchUrl(Uri.parse(appStoreUrl));
      }
    } catch (e) {
      print('앱 실행 또는 스토어 이동 실패: $e');
    }
  }
}
