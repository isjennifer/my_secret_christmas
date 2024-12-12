import 'package:flutter/material.dart';
import 'package:my_secret_christmas/main.dart';
import 'steps/creation_steps/message_step.dart';
import 'steps/creation_steps/card_selection_step.dart';
import 'steps/creation_steps/hide_message_step.dart';
import 'steps/creation_steps/quiz_step.dart';
import 'steps/creation_steps/send_message_step.dart';

class WriteMessagePage extends StatefulWidget {
  const WriteMessagePage({super.key});

  @override
  State<WriteMessagePage> createState() => _WriteMessagePageState();
}

class StepInfo {
  final String title;
  final String colorIconPath;
  final String grayIconPath;

  StepInfo(this.title, this.colorIconPath, this.grayIconPath);
}

class _WriteMessagePageState extends State<WriteMessagePage> {
  int _currentStep = 0;

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

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text(
              '현재 작성된 메시지가 모두 사라집니다. 그래도 뒤로 가시겠습니까?',
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('아니오'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(true) //이 뒤에 기억된 메시지 없애는 로직 작성
                ,
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
                                      if (_currentStep < 4) {
                                        setState(() {
                                          _currentStep++;
                                        });
                                      } else {
                                        // 메시지 전송 로직 구현
                                        print('메시지 전송');
                                        _currentStep < 4
                                            ? Navigator.pop(context)
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MyHomePage(
                                                          title: ''),
                                                ));
                                        ;
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
