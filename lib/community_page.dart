import 'package:flutter/material.dart';
import 'community_write_page.dart';
import 'community_detail_page.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  int currentPage = 0;
  int itemsPerPage = 7;

  final List<String> categories = ["전체", "자유게시판", "소모임", "펫시터", "댕댕이 찾기"];
  String selectedCategory = "전체";
  String searchTerm = '';

  final List<Map<String, dynamic>> dummyPosts = [
    {
      "id": 1,
      "title": "산책 메이트 구해요 🐶",
      "content": "내일 오전 8시쯤 강남 근처에서 산책하실 분 찾아요!",
      "category": "소모임",
      "author": "죠코모랑",
      "location": "서울",
      "views": "12",
      "comments": [
        {"author": "해피맘", "content": "메시지 드릴게요!", "createdAt": "12:30"},
        {"author": "두부엄마", "content": "근처인데 관심 있어요!", "createdAt": "01:38"},
        {"author": "두부엄마", "content": "너무 귀여워요!", "createdAt": "01:22"}
      ],
    },
    {
      "id": 2,
      "title": "우리 강아지 첫 돌 자랑해요 🎂🐶",
      "content": "강아지가 오늘 생일이에요! 축하해주세요!",
      "category": "자유게시판",
      "author": "복실이아빠",
      "location": "부산",
      "views": "31",
      "comments": [
        {"author": "해피맘", "content": "근처인데 관심 있어요!", "createdAt": "00:48"},
        {"author": "태양이누나", "content": "좋은 정보 감사합니다!", "createdAt": "00:18"}
      ],
    },
    {
      "id": 3,
      "title": "이번 주말 강아지 봐주실 분 구해요!",
      "content": "2박 3일 출장이라 토~월 강아지 봐주실 분 구합니다.",
      "category": "분실",
      "author": "댕댕러버",
      "location": "대구",
      "views": "7",
      "comments": [
        {"author": "라라맘", "content": "응원합니다 🙌", "createdAt": "00:37"},
        {"author": "태양이누나", "content": "정말 멋져요~", "createdAt": "01:48"},
        {"author": "유미짱", "content": "근처인데 관심 있어요!", "createdAt": "23:16"}
      ],
    },
    {
      "id": 4,
      "title": "이 강아지 혹시 보셨나요?",
      "content": "서울 성수동 근처에서 흰색 푸들을 잃어버렸어요.",
      "category": "댕댕이 찾기",
      "author": "카페형",
      "location": "인천",
      "views": "22",
      "comments": [
        {"author": "라라맘", "content": "응원합니다 🙌", "createdAt": "00:57"},
        {"author": "유미짱", "content": "응원합니다 🙌", "createdAt": "00:45"},
        {"author": "몽실할미", "content": "정말 멋져요~", "createdAt": "00:02"}
      ],
    },
    {
      "id": 5,
      "title": "강아지 간식 추천 좀요!",
      "content": "치석 관리에 좋은 간식 있을까요?",
      "category": "자유게시판",
      "author": "치즈누나",
      "location": "서울",
      "views": "12",
      "comments":  [
        {"author": "해피맘", "content": "메시지 드릴게요!", "createdAt": "01:19"},
        {"author": "두부엄마", "content": "응원합니다 🙌", "createdAt": "00:46"}
      ],
    },
    {
      "id": 6,
      "title": "산책로 추천해주실 분~",
      "content": "성남 쪽 산책하기 좋은 공원 있으면 추천해주세요!",
      "category": "소모임",
      "author": "멍멍이주인",
      "location": "성남",
      "views": "10",
      "comments": [
        {"author": "몽실할미", "content": "너무 귀여워요!", "createdAt": "02:01"},
        {"author": "라라맘", "content": "응원합니다 🙌", "createdAt": "00:19"}
      ],
    },
    {
      "id": 7,
      "title": "애견카페 같이 가실 분!",
      "content": "홍대 애견카페 갈 건데 강쥐 친구 만들어주고 싶어요 :)",
      "category": "소모임",
      "author": "퐁당퐁당",
      "location": "서울",
      "views": "8",
      "comments":  [
        {"author": "유미짱", "content": "메시지 드릴게요!", "createdAt": "00:03"},
        {"author": "두부엄마", "content": "정말 멋져요~", "createdAt": "01:51"},
        {"author": "태양이누나", "content": "메시지 드릴게요!", "createdAt": "23:31"}
      ],
    },
    {
      "id": 8,
      "title": "펫시터 구합니다!",
      "content": "다음 주 출장인데 강아지 맡아주실 분 찾습니다.",
      "category": "펫시터",
      "author": "루이맘",
      "location": "서울",
      "views": "15",
      "comments":[
        {"author": "유미짱", "content": "메시지 드릴게요!", "createdAt": "23:51"},
        {"author": "몽실할미", "content": "너무 귀여워요!", "createdAt": "01:11"},
        {"author": "태양이누나", "content": "좋은 정보 감사합니다!", "createdAt": "02:05"}
      ],
    },
  ];

  List<Map<String, dynamic>> get filteredPosts {
    return dummyPosts.where((post) {
      final matchesCategory = selectedCategory == '전체' || post["category"] == selectedCategory;
      final matchesSearch = post["title"].toLowerCase().contains(searchTerm.toLowerCase()) ||
          post["content"].toLowerCase().contains(searchTerm.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<Map<String, dynamic>> get pagedPosts {
    final start = currentPage * itemsPerPage;
    final end = start + itemsPerPage;
    return filteredPosts.sublist(start, end > filteredPosts.length ? filteredPosts.length : end);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F8),
      appBar: AppBar(
        title: const Text('댕근 커뮤니티', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // 카테고리 필터
          Container(
            height: 48,
            margin: const EdgeInsets.only(top: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                      currentPage = 0;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.pink : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 검색창
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: '게시글 검색',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                  currentPage = 0;
                });
              },
            ),
          ),

          // 게시글 리스트
          Expanded(
            child: ListView.builder(
              itemCount: pagedPosts.length,
              itemBuilder: (context, index) {
                final post = pagedPosts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          '작성자: ${post['author']}   조회수: ${post['views']}회',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.pets),
                    onTap: () async {
                      final updatedPost = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommunityDetailPage(post: post),
                        ),
                      );

                      if (updatedPost != null) {
                        setState(() {
                          if (updatedPost['deleted'] == true) {
                            dummyPosts.removeWhere((p) => p['id'] == updatedPost['id']);
                          } else {
                            final index = dummyPosts.indexWhere((p) => p['id'] == updatedPost['id']);
                            if (index != -1) dummyPosts[index] = updatedPost;
                          }
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),

          // 페이지네이션
          if (filteredPosts.length > itemsPerPage)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: currentPage > 0 ? () => setState(() => currentPage--) : null,
                  child: const Text('이전'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: (currentPage + 1) * itemsPerPage < filteredPosts.length
                      ? () => setState(() => currentPage++)
                      : null,
                  child: const Text('다음'),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPost = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CommunityWritePage()),
          );

          if (newPost != null && newPost is Map<String, String>) {
            setState(() {
              dummyPosts.insert(0, {
                'id': DateTime.now().millisecondsSinceEpoch, // ✅ 고유 ID 부여
                ...newPost,
                'author': '탄이누나',
                'location': '서울',
                'comments': [],
                'views': '0',
              });
            });
          }
        },
        backgroundColor: Colors.pink,
        mini: true,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }
}
