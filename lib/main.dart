//main.dart 페이지
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:my_secret_christmas/collection_page.dart';
import 'package:my_secret_christmas/decode_message_modal.dart';
import 'package:my_secret_christmas/postbox_page.dart';
import 'package:my_secret_christmas/sevices/kakao_scheme_service.dart';
import 'write_message.dart';
import './widgets/snowflake.dart';
import './widgets/snow_theme.dart';
import './widgets/snow_wrapper.dart';
import './widgets/audio_service.dart';

Future<void> main() async {
  // 개발 완료 후 삭제 (디버그 모드에서만 실행)
  // 앱 시작시 보낸 횟수 초기화
  // WidgetsFlutterBinding.ensureInitialized();
  // if (kDebugMode) {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();
  // }
  // ;
  WidgetsFlutterBinding.ensureInitialized();

  // KakaoSdk 초기화
  KakaoSdk.init(
    nativeAppKey: 'decf946daaaa80724532096b84f512cb',
  );

  // 딥링크 핸들러 초기화
  await KakaoSchemeHandler().initUniLinks();

  runApp(
    // 최상위 위젯을 ProviderScope로 감싸기
    ProviderScope(
      child: MyApp(navigatorKey: KakaoSchemeHandler.navigatorKey),
    ),
  );
}

// This widget is the root of your application.
class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({super.key, required this.navigatorKey});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    _initBackgroundMusic();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _initBackgroundMusic() async {
    await _audioService.initBackgroundMusic('audio/background_music.mp3');
    await _audioService.play();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 앱 상태 변경 시 음악 제어
    switch (state) {
      case AppLifecycleState.paused:
        // 앱이 백그라운드로 갈 때
        _audioService.pause();
        break;
      case AppLifecycleState.resumed:
        // 앱이 포그라운드로 돌아올 때
        if (_audioService.isPlaying) {
          _audioService.play();
        }
        break;
      case AppLifecycleState.detached:
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _audioService.stop();
    _audioService.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SnowTheme(
      showSnow: true, // 눈 효과 켜기/끄기 제어
      child: MaterialApp(
        navigatorKey: widget.navigatorKey,
        title: 'Merry Secret Christmas',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 110, 20, 20),
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.gowunDodumTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        builder: (context, child) {
          return SnowWrapper(child: child!);
        },
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showLogo = true; // 초기에는 로고를 보여줍니다

  @override
  void initState() {
    super.initState();

    // 2초 후에 스플래시 이미지로 전환
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _showLogo = false; // 로고를 숨기고 스플래시 이미지를 보여줍니다
      });

      // 추가로 1초 후에 메인 페이지로 이동
      Timer(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MyHomePage(title: 'Merry Secret Christmas'),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedCrossFade(
        duration: const Duration(milliseconds: 500), // 페이드 애니메이션 시간
        firstChild: Center(
          child: Image.asset(
            'assets/laq_logo.png', // 로고 이미지 경로
            width: 200, // 로고 크기 조절
            height: 200,
          ),
        ),
        secondChild: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/splash_screen.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        crossFadeState:
            _showLogo ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      ),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // 화면의 사용 가능한 높이를 계산 (상태바 등 제외)
    final availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    // 버튼의 최대 크기 계산
    final buttonSize = (MediaQuery.of(context).size.width - 40)
        .clamp(0.0, availableHeight * 0.35);
    final AudioService _audioService = AudioService(); // AudioService 인스턴스 추가

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/home_image.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Center(
                    // Column을 Center로 감싸서 중앙 정렬 유지
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildCircularButton(
                            context,
                            '시크릿 크리스마스\n메시지 보내기',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const WriteMessagePage(),
                                ),
                              );
                            },
                            buttonSize,
                          ),
                          SizedBox(height: availableHeight * 0.05),
                          _buildCircularButton(
                            context,
                            '내가 받은\n시크릿 메시지 풀기',
                            () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    const DecodeMessageModal(),
                              );
                            },
                            buttonSize,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: Icon(
                        _audioService.isPlaying
                            ? Icons.volume_up
                            : Icons.volume_off,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      onPressed: () {
                        if (_audioService.isPlaying) {
                          _audioService.pause();
                        } else {
                          _audioService.play();
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  Positioned(
                    bottom: -15,
                    left: 10,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CollectionPage(),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 130,
                        height: 130,
                        child: Image.asset(
                          'assets/book.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PostboxPage(),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 140,
                        height: 140,
                        child: Image.asset(
                          'assets/postbox.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -10,
            left: 0,
            right: 0,
            child: RepaintBoundary(
              child: IgnorePointer(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Image.asset(
                    'assets/snow_bottom.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const RepaintBoundary(
            child: IgnorePointer(
              // 여기에 IgnorePointer 추가
              child: SnowfallWidget(
                numberOfSnowflakes: 100,
                snowColor: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCircularButton(
      BuildContext context, String text, VoidCallback onPressed, double size) {
    final borderColor = text.contains('보내기') ? Colors.red : Colors.green;

    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          foregroundColor: Colors.white.withOpacity(0.4),
          backgroundColor: Colors.white.withOpacity(0.2),
          elevation: 10,
          shadowColor: borderColor.withOpacity(0.8),
          side: BorderSide(color: borderColor, width: 5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              text.contains('보내기')
                  ? 'assets/giftbox_closed.png'
                  : 'assets/giftbox_open.png',
              width: size * 0.3,
              height: size * 0.3,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.5,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(2, 2),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
