// lib/pages/decode_message_page.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_secret_christmas/steps/open_steps/message_reveal_step.dart';

class DecodeMessagePage extends StatefulWidget {
  const DecodeMessagePage({super.key});

  @override
  State<DecodeMessagePage> createState() => _DecodeMessagePageState();
}

class _DecodeMessagePageState extends State<DecodeMessagePage> {
  final _answerController = TextEditingController();
  static const String CORRECT_ANSWER = '정답';
  bool isCorrect = false;
  int _attemptCount = 0;
  bool _showAnswer = false;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('시크릿 메시지 풀기'),
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                '(발신자)님이 크리스마스 메시지를 보냈어요!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 15),
                              ShakingEnvelope(
                                width: 100,
                                height: 100,
                                imagePath: 'assets/envelope_color.png',
                              ),
                              SizedBox(height: 10),
                              if (_attemptCount == 0 && isCorrect == false)
                                Text(
                                  '(발신자)가 (수신자)에게 보내는\n멋진 크리스마스 카드가 도착했어요!\n안에는 시크릿 메시지가 숨겨져있어요.\n메시지를 보려면 (발신자)가 낸 퀴즈를 맞혀야해요.\n얼른 풀어볼까요?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              if (_attemptCount == 1 && isCorrect == false)
                                Text(
                                  '정답이 아니에요 ㅠㅠ\n첫번째 힌트가 열렸어요!\n힌트를 참고해서 다시 풀어볼까요?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              if (_attemptCount == 2 && isCorrect == false)
                                Text(
                                  '정답이 아니에요 ㅠㅠ\n두번째 힌트가 열렸어요!\n힌트를 참고해서 다시 풀어볼까요?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              if (_attemptCount >= 3 && isCorrect == false)
                                Text(
                                  '정답이 아니에요 ㅠㅠ\n세번의 기회를 다 써버렸지만,\n산타할아버지께 도움을 요청해볼까요?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              if (_attemptCount >= 3 && isCorrect == false)
                                AnimatedSwitcher(
                                  duration: const Duration(
                                      milliseconds: 500), // 애니메이션 지속 시간
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: ScaleTransition(
                                        scale: animation,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: TextButton(
                                    key: ValueKey<bool>(
                                        _showAnswer), // 상태가 변경될 때 위젯을 식별하기 위한 키
                                    onPressed: () {
                                      if (!_showAnswer) {
                                        setState(() {
                                          _showAnswer = true;
                                        });
                                      }
                                    },
                                    child: Text(
                                      _showAnswer
                                          ? '🎅 : 허허허! 메리크리스마스!\n정답은 "$CORRECT_ANSWER" 란다!'
                                          : '📣 산타할아버지! 정답을 알려주세요!',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // 퀴즈 부분
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '📝 퀴즈를 풀어주세요!',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  // 하트 표시
                                  Text(
                                    '💔 ' * min(3, _attemptCount) +
                                        '❤️ ' *
                                            (3 -
                                                min(3,
                                                    _attemptCount)), // min 함수로 최대 3번까지만 제한
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Q. 이 사람이 가장 좋아하는 크리스마스 캐롤은?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (_attemptCount >= 1 && isCorrect == false)
                                Text(
                                  'Hint1. 첫번째 힌트입니다.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              if (_attemptCount >= 2 && isCorrect == false)
                                Text(
                                  'Hint2. 두번째 힌트입니다.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              const SizedBox(height: 15),
                              TextField(
                                controller: _answerController,
                                decoration: InputDecoration(
                                  labelText: '정답을 입력해주세요',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                maxLength: 10,
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _attemptCount++; // 버튼을 누를 때마다 시도 횟수 증가
                                      isCorrect =
                                          _answerController.text.trim() ==
                                              CORRECT_ANSWER;
                                    });

                                    if (isCorrect) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MessageRevealPage()),
                                      );
                                    } else {
                                      // 오답일 경우 사용자에게 피드백 제공
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('틀렸습니다. 다시 시도해보세요!'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: const Text(
                                    '정답 제출하기',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ShakingEnvelope extends StatefulWidget {
  final double width;
  final double height;
  final String imagePath;

  const ShakingEnvelope({
    required this.width,
    required this.height,
    required this.imagePath,
    super.key,
  });

  @override
  State<ShakingEnvelope> createState() => _ShakingEnvelopeState();
}

class _ShakingEnvelopeState extends State<ShakingEnvelope>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 초기화
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    // 쉐이킹 효과를 위한 Tween 애니메이션 설정
    _animation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        // 더 자연스러운 흔들림을 위해 사인 곡선 사용
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    // 애니메이션 시작
    _controller.repeat(reverse: true);

    // 1.5초 후 애니메이션 정지
    Future.delayed(const Duration(milliseconds: 1500), () {
      _controller.stop();
      // 원래 위치로 복귀
      _controller.animateTo(0.5);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      // 각도를 라디안으로 변환 (약한 흔들림을 위해 0.05를 곱함)
      angle: _animation.value * 0.1,
      child: Container(
        width: widget.width,
        height: widget.height,
        child: Image.asset(
          widget.imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
