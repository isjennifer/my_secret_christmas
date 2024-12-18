import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;

class AdMobService {
  //앱 열기 광고
  static String? get appOpenAdUnitId {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/5575463023'; //테스트용
    }
    return null;
  }

  //전면 광고
  static String? get interstitialAdUnitId {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; //테스트용
    }
    return null;
  }
}
