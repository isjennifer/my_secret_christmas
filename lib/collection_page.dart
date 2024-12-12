import 'package:flutter/cupertino.dart';
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
      name: '덕칠이',
      imagePath: 'assets/animals/duck.jpg',
      silhouettePath: 'assets/animals/back_pattern.jpeg',
      requiredShares: 1,
      description:
          '👋 안녕꽥? 내 이름은 덕칠이야꽥!\n덕칠이는 네가 행복한 크리스마스를 보내길 바래꽥! 메리 크리스마스꽥!',
    ),
    Animal(
      name: '뭉뭉이',
      imagePath: 'assets/animals/dog.jpg',
      silhouettePath: 'assets/animals/back_pattern.jpeg',
      requiredShares: 3,
      description:
          '👋 하이뭉! 내 이름은 뭉뭉이다뭉!\n뭉뭉이는 산책하면서 눈 밟는걸 좋아한다뭉! 뭉뭉이처럼 활기차고 즐거운 크리스마스 보내뭉!',
    ),
    Animal(
      name: '깡총이',
      imagePath: 'assets/animals/rabbit.jpg',
      silhouettePath: 'assets/animals/back_pattern.jpeg',
      requiredShares: 6,
      description:
          '👋 안녕? 내 이름은 깡총이야!\n올해 크리스마스는 예쁘게 꾸미고 가족들과 친구들과 함께 멋진 파티를 열어보는건 어때? 깡총이도 초대해줘!',
    ),
    Animal(
      name: '냥냥이',
      imagePath: 'assets/animals/cat.jpg',
      silhouettePath: 'assets/animals/back_pattern.jpeg',
      requiredShares: 10,
      description:
          '👋 냥냥? 내 이름은 냥냥이다냥!\n냥냥이는 따뜻한 벽난로가 켜진 크리스마스 트리 아래에서 평화롭게 낮잠 잘거다냥! 여유롭고 평화로운 크리스마스 보내라냥!',
    ),
    Animal(
      name: '뒤뚱이',
      imagePath: 'assets/animals/penguin.jpg',
      silhouettePath: 'assets/animals/back_pattern.jpeg',
      requiredShares: 15,
      description:
          '👋 안뇽하세여? 제 이름은 뒤뚱이에여!\n저는 올해 한번도 안울었으니까 산타할아버지께서 선물을 주시겠죠? 정말 안울었어여! 진짜에여! ',
    ),
    Animal(
      name: '꽃분이',
      imagePath: 'assets/animals/deer.jpg',
      silhouettePath: 'assets/animals/back_pattern.jpeg',
      requiredShares: 21,
      description:
          '👋 안녕? 내 이름은 꽃분이야!\n올해 크리스마스는 눈이 왔으면 좋겠어! 우리 함께 화이트 크리스마스를 기대해볼까?',
    ),
    Animal(
      name: '곰도리',
      imagePath: 'assets/animals/bear.jpg',
      silhouettePath: 'assets/animals/back_pattern.jpeg',
      requiredShares: 28,
      description:
          '👋 안녕? 내 이름은 곰도리야.\n나는 따뜻한 동굴 속에서 겨울잠을 자고 있을거야. 크리스마스가 되면 깨워줄래? 맛있는 꿀을 먹어야 하거든.',
    ),
    Animal(
      name: '어흥이',
      imagePath: 'assets/animals/lion.jpg',
      silhouettePath: 'assets/animals/back_pattern.jpeg',
      requiredShares: 36,
      description: '👋 안녕? 내 이름은 어흥이야.\n항상 씩씩하고 당당한 너의 모습이 정말 멋져! 올 한해도 수고했어흥!',
    ),
    Animal(
      name: '콩끼리',
      imagePath: 'assets/animals/elephant.jpg',
      silhouettePath: 'assets/animals/back_pattern.jpeg',
      requiredShares: 45,
      description:
          '👋 안녕? 내 이름은 콩끼리야..\n이런 말 하기 부끄럽지만..사랑하는 사람이 옆에 있다는 건 정말 큰 축복이야..크리스마스에 사랑한다고 말해보는건 어떨까?',
    ),
    Animal(
      name: '유니코니',
      imagePath: 'assets/animals/unicorn.jpg',
      silhouettePath: 'assets/animals/back_pattern.jpeg',
      requiredShares: 55,
      description:
          '👋 안녕? 내 이름은 유니코니!\n와! 정말 대단해! 많은 사람들에게 너의 진심을 담은 편지를 보냈네! 너의 따뜻한 진심이 전해졌으니 온기로 가득찬 크리스마스가 될 것 같아! ✨내 마법으로 너의 행복한 크리스마스가 되게 해줄게!',
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
          title: const Text(
            '🎉 새로운 동물 해금!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  animal.imagePath, // 해금된 동물의 이미지 경로 사용
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, size: 150);
                  },
                ),
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
                              '🐶🐱🐰🦊🐻🐻‍❄️🦁🐤',
                              style: TextStyle(fontSize: 16),
                            ),
                            const Text(
                              '크리스마스 메시지를 보내고,',
                              style: TextStyle(fontSize: 16),
                            ),
                            const Text(
                              '귀여운 동물 친구들을 만나보세요!',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '💌 메시지 보낸 횟수: ${savedShares}',
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
      child: GestureDetector(
        onTap: () {
          isUnlocked
              ? showDialog(
                  context: context,
                  builder: (context) => AnimalModal(animal: animal),
                )
              : '';
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    isUnlocked ? animal.imagePath : animal.silhouettePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    isUnlocked ? animal.name : '??',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isUnlocked
                        ? '${animal.requiredShares}회 공유 완료'
                        : '${animal.requiredShares}회 공유 필요',
                    style: TextStyle(
                      fontSize: 14,
                      color: isUnlocked ? Colors.green : Colors.grey,
                    ),
                  ),
                  if (!isUnlocked) ...[
                    const SizedBox(height: 2),
                    LinearProgressIndicator(
                      value: totalShares / animal.requiredShares,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimalModal extends StatefulWidget {
  final Animal animal;

  const AnimalModal({Key? key, required this.animal}) : super(key: key);

  @override
  _AnimalModalState createState() => _AnimalModalState();
}

class _AnimalModalState extends State<AnimalModal> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              child: Stack(
                children: [
                  Image.asset(
                    widget.animal.imagePath,
                    height: 350,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.2),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Close button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black26,
                      ),
                    ),
                  ),
                  // Title at the bottom of image
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Text(
                      widget.animal.name,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Text(
                    widget.animal.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Action buttons
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
