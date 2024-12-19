import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;

class AdMobService {
  //앱 열기 광고
  static String? get appOpenAdUnitId {
    if (Platform.isIOS) {
      return 'ca-app-pub-8028621037426483/9229179871'; //실제용
    }
    return null;
  }

  //전면 광고
  static String? get interstitialAdUnitId {
    if (Platform.isIOS) {
      return 'ca-app-pub-8028621037426483/5609794219'; //실제용
    }
    return null;
  }
}

class AppOpenAdManager {
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  static bool isLoaded = false;

  static final AppOpenAdManager instance = AppOpenAdManager._internal();
  factory AppOpenAdManager() => instance;
  AppOpenAdManager._internal();

  bool _isFirstLaunch = true; // 첫 실행 여부 추적

  /// 광고 로드 요청
  Future<void> loadAppOpenAd() async {
    if (_appOpenAd != null) {
      return;
    }

    AppOpenAd.load(
      adUnitId: AdMobService.appOpenAdUnitId ?? '',
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          isLoaded = true;
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
          isLoaded = false;
        },
      ),
    );
  }

  bool _wasInterstitialShown = false;

  void setInterstitialShown() {
    _wasInterstitialShown = true;
  }

  /// 광고 표시
  void showAdIfAvailable() {
    if (_wasInterstitialShown) {
      _wasInterstitialShown = false;
      return;
    }
    if (!_isFirstLaunch) return; // 첫 실행이 아니면 표시하지 않음
    if (!isLoaded) {
      loadAppOpenAd();
      return;
    }
    if (_isShowingAd) {
      return;
    }
    if (_appOpenAd == null) {
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        print('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        print('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
    );

    _appOpenAd!.show();
    _isFirstLaunch = false; // 광고를 보여준 후 플래그 변경
  }

  /// 광고 해제
  void dispose() {
    _appOpenAd?.dispose();
    _appOpenAd = null;
  }
}
