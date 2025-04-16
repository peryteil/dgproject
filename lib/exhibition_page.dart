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
          'title': '스프링 펫페어',
          'description': '댕댕이와 함께하는 봄여행!',
          'startDate': '2025-03-01',
          'endDate': '2025-06-15',
          'location': '전남 라테라스',
          'image': 'https://naverbooking-phinf.pstatic.net/20250228_160/1740726776807MYijp_JPEG/laterrace_spring_1000.jpg',
          'url': 'http://laterrace-resort.com/board/bbs/board.php?bo_table=event_&wr_id=336',
          'status': 'current',
          'tags': ['가든', '산책', '여유'],
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