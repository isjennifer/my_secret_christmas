import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
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
      // 앱이 종료된 상태에서 실행된 경우의 딥링크 처리
      final initialUri = await getInitialUri();
      if (initialUri != null) {
        _handleLink(initialUri);
      }

      // 앱이 실행 중일 때의 딥링크 처리
      uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          _handleLink(uri);
        }
      }, onError: (err) {
        print('딥링크 스트림 에러: $err');
      });
    } catch (e) {
      print('딥링크 초기화 에러: $e');
    }
  }

  // Uri 객체를 직접 처리하도록 수정
  void _handleLink(Uri uri) {
    print('수신된 URI: $uri'); // 디버깅용

    if (uri.scheme == scheme) {
      // queryParameters에서 path 확인
      final path = uri.queryParameters['path'];
      print('Path 파라미터: $path'); // 디버깅용

      switch (path) {
        case 'decode':
          _navigateToDecodePage();
          break;
        // 다른 path 케이스들 추가 가능
        default:
          print('알 수 없는 path 파라미터: $path');
          // path가 없는 경우 host로 폴백
          if (uri.host == host) {
            _navigateToDecodePage();
          }
      }
    }
  }

  void _navigateToDecodePage() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => const DecodeMessagePage(),
      ),
    );
  }

  Future<void> shareToKakao({required ChristmasCard card}) async {
    try {
      // JSON으로 변환하고 base64로 인코딩
      final String cardJson = jsonEncode(card.toJson());
      final String encodedCard = base64Encode(utf8.encode(cardJson));

      final template = FeedTemplate(
        content: Content(
          title: '크리스마스 시크릿 메시지가 도착했어요!',
          description: '지금 바로 확인해보세요!',
          imageUrl: Uri.parse('assets/book.png'),
          link: Link(
            androidExecutionParams: {'path': 'decode'},
            iosExecutionParams: {'path': 'decode'},
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
