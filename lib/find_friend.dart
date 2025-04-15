import 'package:flutter/material.dart';

class FindFriendScreen extends StatefulWidget {
  const FindFriendScreen({super.key});

  @override
  State<FindFriendScreen> createState() => _FindFriendScreenState();
}

class _FindFriendScreenState extends State<FindFriendScreen> {
  List<Map<String, dynamic>> currentProfiles = [];
  List<Map<String, dynamic>> matchedDogs = [];
  bool loading = true;
  bool showMatchedDogs = false;

  @override
  void initState() {
    super.initState();
    loadDummyData();
  }

  void loadDummyData() {
    // 1초 뒤에 더미 데이터 세팅
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        currentProfiles = [
          {
            'id': '1',
            'userName': '복슬이',
            'image': 'assets/images/dog4.jpg',
            'petBreed': '골든 리트리버',
            'petAge': 1,
            'petGender': '남아',
            'petPersonality': '장난기 많은 귀염둥이!',
            'location': '서울 마포구',
          },
          {
            'id': '2',
            'userName': '콩이',
            'image': 'assets/images/dog5.jpg',
            'petBreed': '포메라니안',
            'petAge': 2,
            'petGender': '여아',
            'petPersonality': '낯가림이 살짝 있어요',
            'location': '서울 강남구',
          },
        ];
        matchedDogs = [
          {
            'id': '99',
            'nickname': '두부',
            'image': '',
          },
        ];
        loading = false;
      });
    });
  }

  void handleMatch(String id) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('ID $id 선택됨 (더미 매칭 처리)')),
    );
  }

  void handleChat(String dogId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('ID $dogId 채팅 시작 (더미)')),
    );
  }

  void handleDeleteMatch(String id) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('ID $id 매칭 거절 (더미)')),
    );
  }

  Widget buildProfileCard(Map<String, dynamic> profile) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(profile['userName'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),
            // ✅ 이미지: asset 사용
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                profile['image'], // 예: 복슬이.png
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.pets, size: 80),
              ),
            ),

            const SizedBox(height: 12),
            Text('견종: ${profile['petBreed']}'),
            Text('나이: ${profile['petAge']}살'),
            Text('성별: ${profile['petGender']}'),
            Text(profile['petPersonality']),
            Text('📍 ${profile['location']}'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => handleMatch(profile['id']),
              child: const Text('선택하기'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMatchedDogsModal() {
    return AlertDialog(
      title: Text('매칭된 댕댕이 (${matchedDogs.length})'),
      content: SizedBox(
        height: 300,
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: matchedDogs.length,
          itemBuilder: (context, index) {
            final dog = matchedDogs[index];
            return ListTile(
              leading: const Icon(Icons.pets),
              title: Text(dog['nickname']),
              trailing: Wrap(
                spacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () => handleChat(dog['id']),
                    child: const Text('채팅'),
                  ),
                  ElevatedButton(
                    onPressed: () => handleDeleteMatch(dog['id']),
                    child: const Text('거절'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => setState(() => showMatchedDogs = false),
          child: const Text('닫기'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🐶 댕근찾기')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView( // ✅ 스크롤 가능하도록 변경
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('마음에 드는 친구를 선택하세요!'),
            ),

            // ✅ 여기! 두 프로필을 Row → Column으로 변경
            buildProfileCard(currentProfiles[0]),
            const SizedBox(height: 16),
            buildProfileCard(currentProfiles[1]),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: loadDummyData,
                  child: const Text('둘 다 선택 안함'),
                ),
                TextButton(
                  onPressed: () => setState(() => showMatchedDogs = true),
                  child: Text('↩ 매칭된 댕댕이 (${matchedDogs.length})'),
                ),
              ],
            ),
            if (showMatchedDogs) buildMatchedDogsModal(),
          ],
        ),
      ),
    );
  }
}