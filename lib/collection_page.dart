import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'classes/animal.dart';

class CollectionPage extends ConsumerStatefulWidget {
  const CollectionPage({Key? key}) : super(key: key);

  // 새로 추가하는 static public 메서드
  static Future<int> incrementCount() async {
    final prefs = await SharedPreferences.getInstance();
    const String shareCountKey =
        'snowzoo_share_count'; // shareCountKey를 여기서도 접근할 수 있도록 정의
    int currentCount = prefs.getInt(shareCountKey) ?? 0;
    int newCount = currentCount + 1;
    await prefs.setInt(shareCountKey, newCount);
    return newCount;
  }

  @override
  ConsumerState<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends ConsumerState<CollectionPage> {
  Set<int> _previousUnlockedIndices = {};
  int savedShares = 0; // 저장된 공유 수를 저장할 변수 추가

  // 각 동물의 잠금 해제 상태를 저장할 리스트 추가
  List<bool> unlockedAnimals = List.filled(10, false); // 10마리 동물에 대해 초기화

  // 프리퍼런스 키 상수
  static const String shareCountKey = 'snowzoo_share_count';
  static const String unlockPrefix = 'snowzoo_animal_unlock_';

  static const List<Animal> animalList = [
    Animal(
      name: '오리',
      imagePath: 'assets/animals/duck.jpg',
      silhouettePath: 'assets/book.png',
      requiredShares: 1,
    ),
    Animal(
      name: '강아지',
      imagePath: 'assets/images/dog.png',
      silhouettePath: 'assets/images/dog_silhouette.png',
      requiredShares: 3,
    ),
    Animal(
      name: '토끼',
      imagePath: 'assets/images/rabbit.png',
      silhouettePath: 'assets/images/rabbit_silhouette.png',
      requiredShares: 6,
    ),
    Animal(
      name: '고양이',
      imagePath: 'assets/images/cat.png',
      silhouettePath: 'assets/images/cat_silhouette.png',
      requiredShares: 10,
    ),
    Animal(
      name: '펭귄',
      imagePath: 'assets/images/penguin.png',
      silhouettePath: 'assets/images/penguin_silhouette.png',
      requiredShares: 15,
    ),
    Animal(
      name: '곰',
      imagePath: 'assets/images/bear.png',
      silhouettePath: 'assets/images/bear_silhouette.png',
      requiredShares: 21,
    ),
    Animal(
      name: '사자',
      imagePath: 'assets/images/lion.png',
      silhouettePath: 'assets/images/lion_silhouette.png',
      requiredShares: 28,
    ),
    Animal(
      name: '기린',
      imagePath: 'assets/images/giraffe.png',
      silhouettePath: 'assets/images/giraffe_silhouette.png',
      requiredShares: 36,
    ),
    Animal(
      name: '코끼리',
      imagePath: 'assets/images/elephant.png',
      silhouettePath: 'assets/images/elephant_silhouette.png',
      requiredShares: 45,
    ),
    Animal(
      name: '유니콘',
      imagePath: 'assets/images/unicorn.png',
      silhouettePath: 'assets/images/unicorn_silhouette.png',
      requiredShares: 55,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // 초기 해금된 동물 인덱스 저장
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData(); // 모든 데이터 로드
    });
  }

  // 데이터 로드 메서드
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // 공유 수 로드
      savedShares = prefs.getInt(shareCountKey) ?? 0;

      // 각 동물의 잠금 해제 상태 로드
      for (int i = 0; i < animalList.length; i++) {
        unlockedAnimals[i] = prefs.getBool('$unlockPrefix$i') ?? false;
      }
    });
  }

  // 동물 잠금 해제 상태 변경 메서드
  Future<void> updateAnimalUnlock(int index, bool isUnlocked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$unlockPrefix$index', isUnlocked);
    setState(() {
      unlockedAnimals[index] = isUnlocked;
    });
  }

  void _showNormalUnlockAnimation(Animal animal) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('🎉 새로운 동물 해금!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                animal.imagePath, // 해금된 동물의 이미지 경로 사용
                height: 150,
                errorBuilder: (context, error, stackTrace) {
                  print("Image error: $error");
                  return const Icon(Icons.error, size: 150);
                },
              ),
              const SizedBox(height: 16),
              Text(
                '축하합니다!\n${animal.name}을(를) 해금했습니다!',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final collectionState = ref.watch(collectionProvider);

    // // 새로 해금된 동물이 있는지 확인
    // final newUnlockedIndices = collectionState.unlockedAnimalIndices
    //     .difference(_previousUnlockedIndices);

    // // 새로 해금된 동물이 있다면 애니메이션 표시
    // if (newUnlockedIndices.isNotEmpty) {
    //   // 애니메이션이 중복 실행되지 않도록 이전 상태 업데이트
    //   _previousUnlockedIndices =
    //       Set.from(collectionState.unlockedAnimalIndices);

    //   // 각각의 새로 해금된 동물에 대해 애니메이션 표시
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     for (final index in newUnlockedIndices) {
    //       _showNormalUnlockAnimation(collectionState.animals[index]);
    //     }
    //   });
    // }
    // 각 동물에 대해 잠금 해제 조건 확인
    for (int i = 0; i < animalList.length; i++) {
      // 아직 잠금 해제되지 않았고, 공유 수가 요구 수와 같거나 큰 경우
      if (!unlockedAnimals[i] && savedShares >= animalList[i].requiredShares) {
        // 상태 업데이트
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          // 잠금 해제 상태 저장
          await updateAnimalUnlock(i, true);
          // 애니메이션 표시
          _showNormalUnlockAnimation(animalList[i]);
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('SnowZoo : 눈사람 동물원'),
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    color: Colors.white.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Column(
                          children: [
                            const Text(
                              '크리스마스 메시지를 보내고',
                              style: TextStyle(fontSize: 16),
                            ),
                            const Text(
                              '귀여운 동물들을 만나보세요!',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '보낸 횟수: ${savedShares}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: animalList.length,
                    itemBuilder: (context, index) {
                      final animal = animalList[index];
                      final isUnlocked = unlockedAnimals[index];

                      return _buildAnimalCard(
                        animal,
                        isUnlocked,
                        savedShares,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimalCard(Animal animal, bool isUnlocked, int totalShares) {
    return Card(
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                isUnlocked ? animal.imagePath : animal.silhouettePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  animal.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${animal.requiredShares}회 공유 필요',
                  style: TextStyle(
                    fontSize: 14,
                    color: isUnlocked ? Colors.green : Colors.grey,
                  ),
                ),
                if (!isUnlocked) ...[
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: totalShares / animal.requiredShares,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
