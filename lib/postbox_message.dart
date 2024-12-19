import 'package:flutter/material.dart';
import 'package:my_secret_christmas/main.dart';
import 'package:my_secret_christmas/write_message.dart';

class PostboxMessagePage extends StatefulWidget {
  final String sender;
  final String content;
  final String recipient;
  final String cardImageUrl;

  const PostboxMessagePage({
    super.key,
    required this.sender,
    required this.content,
    required this.recipient,
    required this.cardImageUrl,
  });

  @override
  State<PostboxMessagePage> createState() => _PostboxMessagePageState();
}

class _PostboxMessagePageState extends State<PostboxMessagePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation_img;
  late Animation<double> _fadeAnimation_message;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation_img = Tween<double>(
      begin: 1.0,
      end: 0.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
    ));

    _fadeAnimation_message = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
    ));

    // 애니메이션 자동 시작
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.cardImageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
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
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.lock_open,
                                color: Colors.red,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '시크릿 메시지가 풀렸어요!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // 카드 이미지가 점점 흐려지는 효과
                              AnimatedBuilder(
                                animation: _controller,
                                builder: (context, child) {
                                  return Opacity(
                                    opacity: _fadeAnimation_img.value,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        widget.cardImageUrl,
                                        height: 500,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // 메시지가 점점 선명해지는 효과
                              AnimatedBuilder(
                                animation: _controller,
                                builder: (context, child) {
                                  return Opacity(
                                    opacity: _fadeAnimation_message.value,
                                    child: Container(
                                      height: 500,
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 24),
                                          // 받는 사람 (고정)
                                          Container(
                                            width: double.infinity,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${widget.recipient}에게,',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 24),

                                          // 내용 (스크롤 가능)
                                          Expanded(
                                            child: Scrollbar(
                                              thickness: 6.0, // 스크롤바 두께
                                              radius: const Radius.circular(
                                                  3.0), // 스크롤바 모서리 둥글기
                                              thumbVisibility:
                                                  false, // 스크롤바 항상 표시
                                              child: SingleChildScrollView(
                                                child: Text(
                                                  widget.content,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    height: 1.5,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 24),

                                          // 보내는 사람 (고정)
                                          Container(
                                            width: double.infinity,
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              '${widget.sender}가.',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 답장하기 버튼
              Positioned(
                bottom: 80,
                left: 20,
                right: 20,
                child: SafeArea(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WriteMessagePage(),
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '답장하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              // 목록으로 버튼
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: SafeArea(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '목록으로',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
