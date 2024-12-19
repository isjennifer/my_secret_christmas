// lib/services/app_links_service.dart

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_secret_christmas/classes/routes.dart';
import 'package:my_secret_christmas/models/christmas_card.dart';
import 'package:my_secret_christmas/sevices/card_encryption_service.dart';
import 'package:my_secret_christmas/sevices/navigation_service.dart';

class AppLinksService {
  static final AppLinksService _instance = AppLinksService._internal();
  factory AppLinksService() => _instance;
  AppLinksService._internal();

  final _appLinks = AppLinks();

  // 구독을 저장하기 위한 변수
  StreamSubscription<Uri>? _linkSubscription;

  // 초기 링크를 처리하기 위한 변수
  Uri? _initialLink;
  bool _initialLinkHandled = false;

  Future<void> init() async {
    // 앱이 종료된 상태에서 딥링크로 실행된 경우의 초기 링크 처리
    try {
      _initialLink = await _appLinks.getInitialLink();
    } on PlatformException {
      debugPrint('Failed to get initial app link.');
    }

    // 앱이 실행 중일 때 들어오는 딥링크 처리
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri? uri) {
        _handleAppLink(uri);
      },
      onError: (err) {
        debugPrint('App link error: $err');
      },
    );

    // 초기 링크가 있으면 처리
    if (_initialLink != null && !_initialLinkHandled) {
      _handleAppLink(_initialLink);
      _initialLinkHandled = true;
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }

  void _handleAppLink(Uri? uri) {
    if (uri == null) return;
    print("handling uri: $uri");

    // iOS execution params 처리
    final params = uri.queryParameters;
    final path = params['path'];
    final cardData = params['cardData'];

    // URI 경로에 따른 라우팅 처리
    switch (path) {
      case 'decode':
        if (cardData != null) {
          // 복호화된 카드 데이터를 직접 DecodeMessagePage로 전달
          var decryptedCard = CardEncryptionService.decryptToCard(cardData);
          NavigationService()
              .navigateTo(Routes.decode, arguments: decryptedCard);
        }
        break;

      default:
        debugPrint('Unknown deep link path: ${uri.path}');
    }
  }
}
