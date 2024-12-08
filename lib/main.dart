import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_secret_christmas/decode_message_modal.dart';
import 'write_message.dart';

void main() {
  runApp(
    // 최상위 위젯을 ProviderScope로 감싸기
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Merry Secret Christmas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 110, 20, 20)),
        useMaterial3: true,
        textTheme: GoogleFonts.gowunDodumTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const SplashScreen(),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // 화면의 사용 가능한 높이를 계산 (상태바 등 제외)
    final availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    // 버튼의 최대 크기 계산
    final buttonSize = (MediaQuery.of(context).size.width - 40)
        .clamp(0.0, availableHeight * 0.35);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/home_image.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
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
                          builder: (context) => const WriteMessagePage()),
                    );
                  },
                  buttonSize,
                ),
                SizedBox(height: availableHeight * 0.05), // 화면 높이의 5%
                _buildCircularButton(
                  context,
                  '내가 받은\n시크릿 메시지 풀기',
                  () {
                    showDialog(
                      context: context,
                      builder: (context) => const DecodeMessageModal(),
                    );
                  },
                  buttonSize,
                ),
              ],
            ),
          ),
        ),
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
