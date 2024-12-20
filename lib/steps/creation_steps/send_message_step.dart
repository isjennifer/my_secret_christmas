// lib/pages/steps/send_message_step.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_secret_christmas/providers/christmas_card_provider.dart';
import 'package:my_secret_christmas/sevices/card_encryption_service.dart';
import 'package:my_secret_christmas/collection_page.dart';
import 'package:my_secret_christmas/sevices/kakao_share_service.dart';
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

  var imageBackground = "insta_story_image.png";
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
          backgroundTopColor: "#06591E",
          backgroundBottomColor: "#BF1011",
          backgroundResourcePath: "",
          attributionURL: "");

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

        // 공유 버튼들
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  final cardData = ref.read(christmasCardProvider);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    '알림',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // 안드로이드 지원 안됨 메시지
                              const Text(
                                '⚠️ 본 앱은 iOS 기기에 최적화되어 있습니다.\n🍎 iOS 사용자에게만 공유해주세요!',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // 확인 버튼
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.grey.shade100,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        '취소',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        KakaoShareService()
                                            .shareToKakao(card: cardData);
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: Color(0xFFFFE812),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        '계속하기',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
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
              // ElevatedButton(
              //   onPressed: () async {
              //     // 카드 데이터 읽기
              //     final cardData = ref.read(christmasCardProvider);
              //     // 암호화된 문자열 생성
              //     final endcodedString = CardEncryptionService.encryptCard(card: cardData);

              //     try {
              //       // 복사 성공 시 모달 표시
              //       if (context.mounted) {
              //         await showDialog(
              //           context: context,
              //           builder: (BuildContext context) {
              //             return Dialog(
              //               shape: RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(16),
              //               ),
              //               child: Container(
              //                 padding: const EdgeInsets.all(24),
              //                 child: Column(
              //                   mainAxisSize: MainAxisSize.min,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     // 헤더
              //                     Row(
              //                       children: [
              //                         const Text(
              //                           '인스타그램 공유하기',
              //                           style: TextStyle(
              //                             fontSize: 20,
              //                             fontWeight: FontWeight.bold,
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                     const SizedBox(height: 24),

              //                     // 안내 컨테이너 1
              //                     Container(
              //                       padding: const EdgeInsets.all(16),
              //                       decoration: BoxDecoration(
              //                         border: Border(
              //                           left: BorderSide(
              //                             color: Colors.pink.shade300,
              //                             width: 4,
              //                           ),
              //                         ),
              //                         color: Colors.pink.shade50,
              //                         borderRadius: BorderRadius.circular(8),
              //                       ),
              //                       child: Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.start,
              //                         children: [
              //                           Row(
              //                             children: const [
              //                               Icon(Icons.copy,
              //                                   size: 18, color: Colors.pink),
              //                               SizedBox(width: 8),
              //                               Text(
              //                                 'URL 복사하기',
              //                                 style: TextStyle(
              //                                   fontWeight: FontWeight.bold,
              //                                   color: Colors.pink,
              //                                 ),
              //                               ),
              //                             ],
              //                           ),
              //                           const SizedBox(height: 8),
              //                           const Text('내가 작성한 메시지의 URL을 복사해주세요.'),
              //                         ],
              //                       ),
              //                     ),
              //                     const SizedBox(height: 16),

              //                     // 안내 컨테이너 2
              //                     Container(
              //                       padding: const EdgeInsets.all(16),
              //                       decoration: BoxDecoration(
              //                         border: Border(
              //                           left: BorderSide(
              //                             color: Colors.pink.shade300,
              //                             width: 4,
              //                           ),
              //                         ),
              //                         color: Colors.pink.shade50,
              //                         borderRadius: BorderRadius.circular(8),
              //                       ),
              //                       child: Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.start,
              //                         children: [
              //                           Row(
              //                             children: const [
              //                               Icon(Icons.edit_square,
              //                                   size: 18, color: Colors.pink),
              //                               SizedBox(width: 8),
              //                               Text(
              //                                 '스토리에 공유하기',
              //                                 style: TextStyle(
              //                                   fontWeight: FontWeight.bold,
              //                                   color: Colors.pink,
              //                                 ),
              //                               ),
              //                             ],
              //                           ),
              //                           const SizedBox(height: 8),
              //                           const Text(
              //                               '인스타그램 스토리 작성시, 링크 스티커를 이용해 붙여넣어주세요.'),
              //                         ],
              //                       ),
              //                     ),
              //                     const SizedBox(height: 24),

              //                     // 버튼 영역
              //                     Row(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       children: [
              //                         TextButton.icon(
              //                           onPressed: () {
              //                             Clipboard.setData(
              //                                 ClipboardData(text: endcodedString));
              //                             ScaffoldMessenger.of(context)
              //                                 .showSnackBar(
              //                               const SnackBar(
              //                                   content: Text(
              //                                       'URL이 클립보드에 복사되었습니다.')),
              //                             );
              //                           },
              //                           icon: const Icon(Icons.copy,
              //                               color: Colors.pink),
              //                           label: const Text(
              //                             'URL 복사',
              //                             style: TextStyle(color: Colors.pink),
              //                           ),
              //                           style: TextButton.styleFrom(
              //                             backgroundColor: Colors.white,
              //                             padding: const EdgeInsets.symmetric(
              //                               horizontal: 16,
              //                               vertical: 12,
              //                             ),
              //                             shape: RoundedRectangleBorder(
              //                               borderRadius: BorderRadius.circular(
              //                                   8), // 모서리 둥글기
              //                               side: BorderSide(
              //                                 color: Colors.pink, // 테두리 색상
              //                                 width: 1.0, // 테두리 두께
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                         const SizedBox(width: 12),
              //                         TextButton.icon(
              //                           onPressed: () {
              //                             shareToInstagram();
              //                           },
              //                           icon: const Icon(Icons.edit_square,
              //                               color: Colors.white),
              //                           label: const Text(
              //                             '스토리 작성',
              //                             style: TextStyle(color: Colors.white),
              //                           ),
              //                           style: TextButton.styleFrom(
              //                             backgroundColor: Colors.pink,
              //                             padding: const EdgeInsets.symmetric(
              //                               horizontal: 16,
              //                               vertical: 12,
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             );
              //           },
              //         );
              //       }
              //     } catch (e) {
              //       // 에러 처리
              //       if (context.mounted) {
              //         showDialog(
              //           context: context,
              //           builder: (BuildContext context) {
              //             return AlertDialog(
              //               title: Text('오류'),
              //               content: Text('링크 복사 중 문제가 발생했습니다.'),
              //               actions: [
              //                 TextButton(
              //                   onPressed: () => Navigator.of(context).pop(),
              //                   child: Text('확인'),
              //                 ),
              //               ],
              //             );
              //           },
              //         );
              //       }
              //     }
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: const Color(0xFFE4405F),
              //     foregroundColor: Colors.white,
              //     padding: const EdgeInsets.symmetric(
              //       vertical: 16,
              //       horizontal: 24,
              //     ),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              //   child: const Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Image(
              //         image: AssetImage('assets/instagram.png'),
              //         width: 26,
              //         height: 26,
              //       ),
              //       SizedBox(width: 8),
              //       Text(
              //         '인스타그램 스토리 공유하기',
              //         style: TextStyle(
              //           fontSize: 16,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
