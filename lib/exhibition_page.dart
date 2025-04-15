import 'package:flutter/material.dart';

class ExhibitionScreen extends StatefulWidget {
  const ExhibitionScreen({super.key});

  @override
  State<ExhibitionScreen> createState() => _ExhibitionScreenState();
}

class _ExhibitionScreenState extends State<ExhibitionScreen> {
  List<Map<String, dynamic>> exhibitions = [];
  String activeTab = 'current';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDummyData();
  }

  void loadDummyData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      exhibitions = [
        {
          'id': 1,
          'title': '케이펫페어 세텍',
          'description': '봄나들이에 딱! 펫 페어!',
          'startDate': '2025-03-16',
          'endDate': '2025-04-03',
          'location': '세텍 학여울역',
          'image': 'https://d5bvmdkxgb6q.cloudfront.net/wp-content/uploads/2024/12/02113013/25%EC%BC%80%EC%9D%B4%ED%8E%AB%ED%8E%98%EC%96%B4-%EB%A9%94%EA%B0%80%EC%A3%BC-%ED%82%A4%EB%B9%84%EC%A3%BC%EC%96%BC_297X420mm_3.%EC%84%B8%ED%85%8D-1200x1697.jpg',
          'url': 'https://k-pet.co.kr/information/scheduled-list/2025_kpet_setec/',
          'status': 'current',
          'tags': ['건강검진', '영양', '운동'],
        },
        {
          'id': 2,
          'title': '대전펫 & 캣쇼',
          'description': '전문가와 함께하는 펫 쇼',
          'startDate': '2025-05-09',
          'endDate': '2025-05-11',
          'location': '대전 컨벤션센터',
          'image': 'https://www.pet-show.co.kr/img_up/shop_pds/petshow/build/option/2025--po-seu-teo-05--dae-jeon10801731045751.jpg',
          'url': 'https://www.pet-show.co.kr/page/page139',
          'status': 'upcoming',
          'tags': ['교육', '행동교정', '훈련'],
        },
      ];
      isLoading = false;
    });
  }

  List<Map<String, dynamic>> get filteredExhibitions =>
      exhibitions.where((e) => e['status'] == activeTab).toList();

  Widget buildTabButton(String tab, String label) {
    final isActive = activeTab == tab;
    return Expanded(
      child: TextButton(
        onPressed: () => setState(() => activeTab = tab),
        child: Text(label,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.blue : Colors.grey,
            )),
      ),
    );
  }

  Widget buildExhibitionCard(Map<String, dynamic> exhibition) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                exhibition['image'],
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: exhibition['status'] == 'current' ? Colors.green : Colors.orange,
                  child: Text(
                    exhibition['status'] == 'current' ? '진행 중' : '예정',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exhibition['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("${exhibition['startDate']} ~ ${exhibition['endDate']}", style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Text(exhibition['description']),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 4),
                    Text(exhibition['location']),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: (exhibition['tags'] as List).map((tag) => Chip(label: Text("#$tag"))).toList(),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // 상세보기 링크
                      final url = exhibition['url'];
                      debugPrint('자세히 보기: $url');
                    },
                    child: const Text('자세히 보기'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('반려동물 박람회 정보')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('현재 진행 중인 박람회와 예정된 박람회 정보를 확인하세요.'),
          ),
          Row(
            children: [
              buildTabButton('current', '진행 중인 박람회'),
              buildTabButton('upcoming', '예정된 박람회'),
            ],
          ),
          Expanded(
            child: filteredExhibitions.isEmpty
                ? const Center(child: Text('등록된 박람회가 없습니다.'))
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredExhibitions.length,
              itemBuilder: (context, index) {
                return buildExhibitionCard(filteredExhibitions[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}