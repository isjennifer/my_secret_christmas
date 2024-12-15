// lib/pages/steps/send_message_step.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_secret_christmas/providers/christmas_card_provider.dart';
import 'package:my_secret_christmas/sevices/deep_link_service.dart';
import 'package:my_secret_christmas/collection_page.dart';
import 'dart:io';
import 'package:social_share/social_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SendMessageStep extends ConsumerStatefulWidget {
  const SendMessageStep({
    super.key,
    required this.onComplete,
    required this.onPrevious,
  });

  final VoidCallback onComplete;
  final VoidCallback onPrevious;

  @override
  ConsumerState<SendMessageStep> createState() => _SendMessageStepState();
}

class _SendMessageStepState extends ConsumerState<SendMessageStep>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  int activeArrowIndex = 0;
  String facebookappId = '4724835711075959';

  var imageBackground = "home_image.jpeg";
  // var videoBackground = "video-background.mp4";
  String imageBackgroundPath = "";
  // String videoBackgroundPath = "";

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            activeArrowIndex = (activeArrowIndex + 1) % 3;
          });
          controller?.reset();
          controller?.forward();
        }
      });

    controller?.forward();
    copyBundleAssets();
  }

  Future<void> copyBundleAssets() async {
    imageBackgroundPath = await copyImage(imageBackground);
    // videoBackgroundPath = await copyImage(videoBackground);
  }

  Future<String> copyImage(String filename) async {
    final tempDir = await getTemporaryDirectory();
    ByteData bytes = await rootBundle.load("assets/$filename");
    final assetPath = '${tempDir.path}/$filename';
    File file = await File(assetPath).create();
    await file.writeAsBytes(bytes.buffer.asUint8List());
    return file.path;
  }

  void shareToInstagram() async {
    final apps = await SocialShare.checkInstalledAppsForShare();

    if (apps?['instagram'] == true) {
      // Instagram이 설치되어 있을 때만 공유 시도
      await SocialShare.shareInstagramStory(
          appId: facebookappId,
          imagePath: imageBackgroundPath,
          backgroundTopColor: "#ffffff",
          backgroundBottomColor: "#000000",
          backgroundResourcePath: "",
          attributionURL: "https://deep-link-url");
      await CollectionPage.incrementCount();
    } else {
      // Instagram이 설치되어 있지 않을 때의 처리
      // 예: 사용자에게 알림을 보여주거나 스토어로 이동
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('알림'),
          content: Text('Instagram 앱이 설치되어 있지 않습니다. 앱을 설치하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                //  App Store로 이동하는 로직
                launchUrl(Uri.parse(
                    'https://apps.apple.com/app/instagram/id389801252'));
              },
              child: Text('설치하기'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '메시지 보내기',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        const Center(
          child: Text('나만의 시크릿 메시지를 누구에게 보낼까요?'),
        ),
        const SizedBox(height: 30),
        // 변환 애니메이션 영역
        SizedBox(
          height: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 편지 이미지
              Image.asset(
                'assets/envelope_color.png',
                width: 80,
                height: 80,
              ),
              const SizedBox(width: 20),
              // 화살표 애니메이션
              Row(
                children: List.generate(3, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.1),
                    child: Icon(
                      Icons.arrow_right,
                      color:
                          index == activeArrowIndex ? Colors.red : Colors.grey,
                      size: 30,
                    ),
                  );
                }),
              ),
              const SizedBox(width: 20),
              // 종이비행기 이미지
              Image.asset(
                'assets/send_color.png',
                width: 80,
                height: 80,
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        const Text(
          '⚠️ 본 앱은 현재 Android 버전을 지원하지 않습니다.\n🍎 iOS 사용자에게만 공유해주세요!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        // 공유 버튼들
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  // 카카오톡 공유 로직
                  final cardData = ref.read(christmasCardProvider);
                  DeepLinkHandler().shareToKakao(card: cardData);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFE812),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/kakao.png'),
                      width: 26,
                      height: 26,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '카카오톡으로 보내기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  shareToInstagram();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE4405F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/instagram.png'),
                      width: 26,
                      height: 26,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '인스타그램 스토리 공유하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
