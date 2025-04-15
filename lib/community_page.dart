import 'package:flutter/material.dart';
import 'community_write_page.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final List<String> categories = ["전체", "자유게시판", "소모임", "펫시터", "댕댕이 찾기"];
  String selectedCategory = "전체";
  String searchTerm = '';

  final List<Map<String, String>> dummyPosts = [
    {
      "title": "산책 메이트 구해요 🐶",
      "content": "내일 아침 강남에서 산책하실 분 구해요!",
      "category": "소모임",
      "author": "초코맘"
    },
    {
      "title": "우리 강아지 자랑 😊",
      "content": "생일 셀카입니다~ 귀엽죠?",
      "category": "자유게시판",
      "author": "복실이아빠"
    },
    {
      "title": "강아지 용품 나눔",
      "content": "하네스, 방석 있어요",
      "category": "펫시터",
      "author": "댕댕러버"
    },
    {
      "title": "카페 추천좀요!",
      "content": "서울 근교 반려견 동반 가능한 카페 있을까요?",
      "category": "댕댕이 찾기",
      "author": "카페왕"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredPosts = dummyPosts.where((post) {
      final matchesCategory = selectedCategory == '전체' || post["category"] == selectedCategory;
      final matchesSearch = post["title"]!.toLowerCase().contains(searchTerm.toLowerCase()) ||
          post["content"]!.toLowerCase().contains(searchTerm.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("댕근 커뮤니티")),
      body: Column(
        children: [
          // ✅ 카테고리 탭
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
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.orange : Colors.grey[300],
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

          // ✅ 검색창
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: '게시글 검색',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
              },
            ),
          ),

          // ✅ 게시글 리스트
          Expanded(
            child: ListView.builder(
              itemCount: filteredPosts.length,
              itemBuilder: (context, index) {
                final post = filteredPosts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(post['title'] ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post['content'] ?? ''),
                        const SizedBox(height: 4),
                        Text("작성자: ${post['author'] ?? '익명'}",
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    trailing: const Icon(Icons.pets),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/community/detail',
                        arguments: Map<String, String>.from(post),
                      ).then((deletedPost) {
                        if (deletedPost is Map<String, String>) {
                          setState(() {
                            dummyPosts.removeWhere((p) => p['title'] == deletedPost['title']);
                          });
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // ✅ 글쓰기 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPost = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CommunityWritePage(),
            ),
          );

          if (newPost != null && newPost is Map<String, String>) {
            setState(() {
              dummyPosts.insert(0, {
                ...newPost,
                "author": "탄이누나"
              });
            });
          }
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.edit),
      ),
    );
  }
}
