import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:my_secret_christmas/main.dart';
import 'package:my_secret_christmas/models/christmas_card.dart';
import 'package:my_secret_christmas/providers/christmas_card_provider.dart';
import 'package:my_secret_christmas/sevices/ad_mob_service.dart';
import 'steps/creation_steps/message_step.dart';
import 'steps/creation_steps/card_selection_step.dart';
import 'steps/creation_steps/hide_message_step.dart';
import 'steps/creation_steps/quiz_step.dart';
import 'steps/creation_steps/send_message_step.dart';

class WriteMessagePage extends ConsumerStatefulWidget {
  const WriteMessagePage({super.key});

  @override
  ConsumerState<WriteMessagePage> createState() => _WriteMessagePageState();
}

class StepInfo {
  final String title;
  final String colorIconPath;
  final String grayIconPath;

  StepInfo(this.title, this.colorIconPath, this.grayIconPath);
}

class _WriteMessagePageState extends ConsumerState<WriteMessagePage> {
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    // 광고 생성
    _creatInterstitialAd();
  }

  // 단계 정보 리스트
  final List<StepInfo> _steps = [
    StepInfo(
        '메시지 작성', 'assets/letter_pen_color.png', 'assets/letter_pen_black.png'),
    StepInfo('카드 선택', 'assets/envelope_color.png', 'assets/envelope_black.png'),
    StepInfo('메시지 숨기기', 'assets/hide_color.png', 'assets/hide_black.png'),
    StepInfo('퀴즈 내기', 'assets/quiz_color.png', 'assets/quiz_black.png'),
    StepInfo('메시지 보내기', 'assets/send_color.png', 'assets/send_black.png')
  ];

  Widget _buildStepIndicator() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _steps.length,
        itemBuilder: (context, index) {
          bool isActive = index <= _currentStep;
          return SizedBox(
            width: MediaQuery.of(context).size.width / 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive ? Colors.white : Colors.grey,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: index < _currentStep
                            ? Image.asset(
                                _steps[index].colorIconPath,
                                width: 24,
                                height: 24,
                              )
                            : Image.asset(
                                isActive
                                    ? _steps[index].colorIconPath
                                    : _steps[index].grayIconPath,
                                width: 24,
                                height: 24,
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _steps[index].title,
                  style: TextStyle(
                    color: isActive ? Colors.red : Colors.grey,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return MessageStep(onNext: () => setState(() => _currentStep++));
      case 1:
        return CardSelectionStep(
          onNext: () => setState(() => _currentStep++),
          onPrevious: () => setState(() => _currentStep--),
        );
      case 2:
        return HideMessageStep(
          onNext: () => setState(() => _currentStep++),
          onPrevious: () => setState(() => _currentStep--),
        );
      case 3:
        return QuizStep(
          onNext: () => setState(() => _currentStep++),
          onPrevious: () => setState(() => _currentStep--),
        );
      case 4:
        return SendMessageStep(
          onComplete: () {
            print('메시지 전송');
            Navigator.pop(context);
          },
          onPrevious: () => setState(() => _currentStep--),
        );
      default:
        return Container();
    }
  }

  // 첫 번째 스텝 유효성 검사
  bool _validateFirstStep(ChristmasCard cardState, BuildContext context) {
    if (cardState.sender?.isEmpty ?? true) {
      _showSnackBar(context, '보내는 사람을 입력해주세요');
      return false;
    }
    if (cardState.content?.isEmpty ?? true) {
      _showSnackBar(context, '메시지 내용을 입력해주세요');
      return false;
    }
    if (cardState.recipient?.isEmpty ?? true) {
      _showSnackBar(context, '받는 사람을 입력해주세요');
      return false;
    }
    return true;
  }

// 두 번째 스텝 유효성 검사
  bool _validateSecondStep(ChristmasCard cardState, BuildContext context) {
    if (cardState.cardImageUrl?.isEmpty ?? true) {
      _showSnackBar(context, '카드를 선택해주세요');
      return false;
    }
    return true;
  }

// 세 번째 스텝 유효성 검사
  bool _validateThirdStep(BuildContext context) {
    final isHiding = ref.watch(isHidingProvider);
    if (isHiding) {
      _showSnackBar(context, '메시지를 숨기는 중입니다...');
      return false;
    }
    return true;
  }

// 네 번째 스텝 유효성 검사
  bool _validateFourthStep(ChristmasCard cardState, BuildContext context) {
    if (cardState.quiz?.question?.isEmpty ?? true) {
      _showSnackBar(context, '문제를 입력해주세요');
      return false;
    }
    if (cardState.quiz?.answer?.isEmpty ?? true) {
      _showSnackBar(context, '답을 입력해주세요');
      return false;
    }
    if (cardState.quiz?.hint1?.isEmpty ?? true) {
      _showSnackBar(context, '첫번째 힌트를 입력해주세요');
      return false;
    }
    if (cardState.quiz?.hint2?.isEmpty ?? true) {
      _showSnackBar(context, '두번째 힌트를 입력해주세요');
      return false;
    }
    return true;
  }

// 다음 스텝으로 이동
  void _moveToNextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
    }
  }

// 스낵바 표시 헬퍼 메서드
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

// 제출 처리
  void _handleSubmission(BuildContext context) {
    print('완료 버튼');
    if (_currentStep < 4) {
      Navigator.pop(context);
    } else {
      ref.read(christmasCardProvider.notifier).resetCard();
      ref.read(isHidingProvider.notifier).state = true;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(title: ''),
        ),
      );
      requestReview();
      // openStoreListing();
    }
  }

  InterstitialAd? _interstitialAd;

  // 전면 광고 생성
  void _creatInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdMobService.interstitialAdUnitId!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  Future<void> requestReview() async {
    final InAppReview inAppReview = InAppReview.instance;
    try {
      // 앱스토어에서 리뷰 가능한지 확인
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      }
    } catch (e) {
      print('리뷰 요청 중 에러 발생: $e');
    }
  }

  // 스토어로 직접 이동하는 방법도 제공
  Future<void> openStoreListing() async {
    final InAppReview inAppReview = InAppReview.instance;
    try {
      await inAppReview.openStoreListing(appStoreId: 'tjdgk3575@naver.com');
    } catch (e) {
      print('스토어 페이지 열기 중 에러 발생: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    final isHiding = ref.watch(isHidingProvider);
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('알림'),
            content: const Text(
              '현재 작성된 메시지가 모두 사라집니다. 뒤로 가시겠습니까?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('아니오'),
              ),
              TextButton(
                onPressed: () {
                  ref.read(christmasCardProvider.notifier).resetCard();
                  ref.read(isHidingProvider.notifier).state = true;
                  Navigator.of(context).pop(true);
                },
                child: const Text('예'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 기본적으로 뒤로가기 비활성화
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }

        // 사용자에게 다이얼로그 표시
        final bool shouldPop = await _showExitDialog(context);
        if (shouldPop) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('시크릿 메시지 보내기'),
          backgroundColor: Colors.red.withOpacity(0.8),
          foregroundColor: Colors.white,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/home_image.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  color: Colors.white.withOpacity(0.9),
                  child: _buildStepIndicator(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Card(
                        color: Colors.white.withOpacity(0.9),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildCurrentStepContent(),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (_currentStep > 0)
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _currentStep--;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                      ),
                                      child: const Text('이전'),
                                    ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final cardState =
                                          ref.read(christmasCardProvider);
                                      final isHiding =
                                          ref.watch(isHidingProvider);

                                      // 스텝별 유효성 검사 및 처리
                                      switch (_currentStep) {
                                        case 0:
                                          if (!_validateFirstStep(
                                              cardState, context)) return;
                                          _moveToNextStep();
                                          break;

                                        case 1:
                                          if (!_validateSecondStep(
                                              cardState, context)) return;
                                          _moveToNextStep();

                                          break;

                                        case 2:
                                          if (!_validateThirdStep(context))
                                            return;
                                          _moveToNextStep();
                                          ref
                                              .read(isHidingProvider.notifier)
                                              .state = isHiding;
                                          break;

                                        case 3:
                                          if (!_validateFourthStep(
                                              cardState, context)) return;
                                          _moveToNextStep();
                                          AppOpenAdManager.instance
                                              .setInterstitialShown(); // 추가
                                          //전면 광고 보여줌
                                          _interstitialAd!.show();
                                          break;

                                        default:
                                          _handleSubmission(context);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                    ),
                                    child: Text(_currentStep < 4 ? '다음' : '완료'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
