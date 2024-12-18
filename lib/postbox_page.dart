import 'package:flutter/material.dart';
import 'package:my_secret_christmas/classes/message_preference.dart';
import 'package:my_secret_christmas/postbox_message.dart';
import 'package:my_secret_christmas/steps/open_steps/message_reveal_step.dart';

class PostboxPage extends StatefulWidget {
  const PostboxPage({Key? key}) : super(key: key);

  @override
  State<PostboxPage> createState() => _PostboxPageState();
}

class _PostboxPageState extends State<PostboxPage> {
  List<Message> messages = [];
  bool isDeleteMode = false; // 삭제 모드 상태 변수 추가
  Set<int> selectedMessages = {}; // 선택된 메시지들의 인덱스를 저장할 Set 추가

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final loadedMessages = await MessagePreferences.loadMessages();
    setState(() {
      messages = loadedMessages;
    });
  }

  Future<void> _deleteSelectedMessages() async {
    // 선택된 메시지들의 인덱스를 내림차순으로 정렬
    // (큰 인덱스부터 삭제해야 작은 인덱스의 위치가 변하지 않음)
    final sortedIndices = selectedMessages.toList()
      ..sort((a, b) => b.compareTo(a));

    // 각 선택된 메시지 삭제
    for (int index in sortedIndices) {
      await MessagePreferences.deleteMessage(index);
    }

    // UI 업데이트를 위해 메시지 목록 다시 로드
    await _loadMessages();

    // 삭제 모드 종료 및 선택 초기화
    setState(() {
      isDeleteMode = false;
      selectedMessages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '받은 시크릿 메시지',
        ),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (isDeleteMode) // 삭제 모드일 때만 전체선택 버튼 표시
            TextButton(
              child: Text(
                selectedMessages.length == messages.length ? '전체해제' : '전체선택',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () {
                setState(() {
                  if (selectedMessages.length == messages.length) {
                    // 모두 선택된 상태면 전체 해제
                    selectedMessages.clear();
                  } else {
                    // 전체 선택
                    selectedMessages = Set.from(
                        List.generate(messages.length, (index) => index));
                  }
                });
              },
            ),
          TextButton(
            child: Text(
              isDeleteMode ? '취소' : '삭제',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: () {
              setState(() {
                isDeleteMode = !isDeleteMode;
                selectedMessages.clear(); // 모드 전환시 선택 초기화
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[800]!, Colors.blue[100]!],
          ),
        ),
        child: messages.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.mail_outline,
                      size: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '아직 받은 메시지가 없어요.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        onTap: () {
                          if (isDeleteMode) {
                            setState(() {
                              if (selectedMessages.contains(index)) {
                                selectedMessages.remove(index);
                              } else {
                                selectedMessages.add(index);
                              }
                            });
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostboxMessagePage(
                                  sender: message.sender,
                                  content: message.content,
                                  recipient: message.recipient,
                                  cardImageUrl: message.cardImageUrl,
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.green[50]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.green[700],
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      const Center(
                                        child: Icon(
                                          Icons.mail,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Icon(
                                            Icons.favorite,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'From. ${message.sender}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'To. ${message.recipient}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                isDeleteMode
                                    ? Checkbox(
                                        value: selectedMessages.contains(index),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (value == true) {
                                              selectedMessages.add(index);
                                            } else {
                                              selectedMessages.remove(index);
                                            }
                                          });
                                        },
                                      )
                                    : Icon(
                                        Icons.chevron_right,
                                        color: Colors.grey[400],
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      // 선택된 항목이 있을 때만 삭제 버튼 표시
      floatingActionButton: isDeleteMode && selectedMessages.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: Colors.red,
              child: const Icon(Icons.delete),
              onPressed: () {
                // 여기에 선택된 메시지 삭제 로직 구현
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('메시지 삭제'),
                      content: Text(
                          '선택한 ${selectedMessages.length}개의 메시지를 삭제하시겠습니까?'),
                      actions: [
                        TextButton(
                          child: const Text('취소'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: const Text('삭제'),
                          onPressed: () {
                            // 삭제 로직 구현

                            Navigator.of(context).pop();
                            _deleteSelectedMessages(); // 선택된 메시지들 삭제
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            )
          : null,
    );
  }
}
