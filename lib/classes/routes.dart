import 'package:flutter/material.dart';
import 'package:my_secret_christmas/main.dart';
import 'package:my_secret_christmas/models/christmas_card.dart';
import 'package:my_secret_christmas/steps/open_steps/decode_message_step.dart';

class Routes {
  static const String home = '/';
  static const String decode = '/decode';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(
            builder: (_) => const MyHomePage(title: 'Merry Secret Christmas'));

      case Routes.decode:
        // settings.arguments가 null이거나 타입이 맞지 않으면 에러 처리
        if (settings.arguments is! ChristmasCard) {
          throw Exception('DecodeMessagePage requires ChristmasCard data');
        }
        return MaterialPageRoute(
            builder: (_) => DecodeMessagePage(
                cardData: settings.arguments as ChristmasCard));

      default:
        // 정의되지 않은 라우트에 대한 처리
        return MaterialPageRoute(
            builder: (_) => const MyHomePage(title: 'Merry Secret Christmas'));
    }
  }
}
