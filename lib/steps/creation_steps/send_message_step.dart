// lib/pages/steps/send_message_step.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:social_share/social_share.dart';
import 'package:path_provider/path_provider.dart';

class SendMessageStep extends StatefulWidget {
  const SendMessageStep({
    super.key,
    required this.onComplete,
    required this.onPrevious,
  });

  final VoidCallback onComplete;
  final VoidCallback onPrevious;

  @override
  State<SendMessageStep> createState() => _SendMessageStepState();
}

class _SendMessageStepState extends State<SendMessageStep>
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
        // 공유 버튼들
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  // 카카오톡 공유 로직
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
                    Icon(
                      Icons.mode_comment,
                      size: 24,
                      color: Colors.black,
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
                onPressed: () async {
                  // 인스타그램 스토리 공유 로직
                  // try {
                  //       // 파라미터가 null이 아니고 유효한지 확인
                  //       if (facebookappId != null && facebookappId.isNotEmpty && url != null && Uri.tryParse(url) != null) {
                  //         await SocialShare.shareInstagramStory(
                  //           appId: facebookappId,
                  //     imagePath:
                  //         "",
                  //     backgroundTopColor: "#ffffff",
                  //     backgroundBottomColor: "#000000",
                  //     backgroundResourcePath: "",
                  //     attributionURL: "https://deep-link-url"
                  //         );
                  //       } else {
                  //         print("Invalid parameters for sharing");
                  //       }
                  //     } catch (e) {
                  //       print('Social share error: $e');
                  //     }
                  try {
                    print('코드 앞');

                    await SocialShare.shareInstagramStory(
                        appId: facebookappId, // Facebook 개발자 콘솔에서 받은 실제 App ID
                        imagePath: imageBackgroundPath,
                        backgroundTopColor: "#ffffff",
                        backgroundBottomColor: "#000000",
                        backgroundResourcePath: "",
                        attributionURL: "https://deep-link-url");

                    print('코드 뒤');
                  } catch (e) {
                    print('Instagram 공유 중 오류 발생: $e');
                  }
                  SocialShare.checkInstalledAppsForShare().then((data) {
                    print(data.toString());
                  });
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
                    Icon(
                      Icons.camera_alt,
                      size: 24,
                      color: Colors.white,
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
