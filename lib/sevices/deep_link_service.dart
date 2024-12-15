import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:my_secret_christmas/models/christmas_card.dart';
import 'package:my_secret_christmas/steps/open_steps/decode_message_step.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_secret_christmas/collection_page.dart';

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

  bool _isInitialized = false;
  StreamSubscription? _linkSubscription;

  Future<void> initUniLinks() async {
    print('Deep Link 초기화 시작...');

    if (_isInitialized) {
      print('Deep Link가 이미 초기화되었습니다!');
      _linkSubscription?.cancel(); // 기존 구독 취소
      _isInitialized = false;
    }

    try {
      // 앱이 완전히 종료된 상태에서 시작될 때의 딥링크 처리
      final initialUri = await getInitialUri();
      print('Initial URI: $initialUri');
      if (initialUri != null) {
        _handleLink(initialUri);
      }

      // 스트림 구독 설정
      _linkSubscription = uriLinkStream.listen((Uri? uri) {
        print('수신된 딥링크: $uri');
        if (uri != null) _handleLink(uri);
      }, onError: (err) {
        print('딥링크 스트림 에러: $err');
      });

      _isInitialized = true;
    } catch (e) {
      print('딥링크 초기화 에러: $e');
    }
  }

  // 리소스 해제를 위한 dispose 메서드 추가
  void dispose() {
    _linkSubscription?.cancel();
    _isInitialized = false;
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
          final Map<String, dynamic> cardDataMap = jsonDecode(decodedJson);
          print('디코딩된 카드 데이터: $cardDataMap');
          // Map을 ChristmasCard 객체로 변환
          final ChristmasCard christmasCard =
              ChristmasCard.fromJson(cardDataMap);

          _navigateToDecodePage(christmasCard);
        } catch (e) {
          print('카드 데이터 디코딩 에러: $e');
        }
      } else {
        print('카드 데이터 없음');
      }
    }
  }

  Future<void> shareToKakao({required ChristmasCard card}) async {
    try {
      final deepLinkUrl = createDeepLinkUrl(card: card);
      print('생성된 딥링크 URL: $deepLinkUrl');

      final template = FeedTemplate(
        content: Content(
          title: '크리스마스 시크릿 메시지가 도착했어요!',
          description: '지금 바로 확인해보세요!',
          imageUrl: Uri.parse('assets/book.png'),
          link: Link(
            webUrl: Uri.parse(deepLinkUrl),
            mobileWebUrl: Uri.parse(deepLinkUrl),
          ),
        ),
        buttons: [
          Button(
            title: '메시지 확인하기',
            link: Link(
              androidExecutionParams: {
                'path': 'decode',
                'cardData': base64Encode(utf8.encode(jsonEncode(card.toJson()))),
              },
              iosExecutionParams: {
                'path': 'decode',
                'cardData': base64Encode(utf8.encode(jsonEncode(card.toJson()))),
              },
              // iOS Universal Link 지원
              mobileWebUrl: Uri.parse(deepLinkUrl),
              webUrl: Uri.parse(deepLinkUrl),
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

  // 딥링크 URL 생성 메서드
  String createDeepLinkUrl({required ChristmasCard card}) {
    try {
      // JSON으로 변환하고 base64로 인코딩
      final String cardJson = jsonEncode(card.toJson());
      final String encodedCard = base64Encode(utf8.encode(cardJson));

      // URL 생성
      final deepLinkUrl = Uri(
          scheme: scheme,
          host: host,
          queryParameters: {'cardData': encodedCard}).toString();

      print('생성된 딥링크 URL: $deepLinkUrl');
      return deepLinkUrl;
    } catch (e) {
      print('딥링크 URL 생성 실패: $e');
      throw Exception('딥링크 URL 생성에 실패했습니다');
    }
  }

  void _navigateToDecodePage(ChristmasCard cardData) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => DecodeMessagePage(cardData: cardData),
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
