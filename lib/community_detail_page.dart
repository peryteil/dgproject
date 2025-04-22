import 'package:flutter/material.dart';

class CommunityDetailPage extends StatefulWidget {
  final Map<String, dynamic> post;

  const CommunityDetailPage({super.key, required this.post});

  @override
  State<CommunityDetailPage> createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
  bool isLiked = false;
  late Map<String, dynamic> post;
  late List<Map<String, dynamic>> comments;

  final dummyUser = {'nickname': '탄이누나'};
  int? editingIndex;
  final TextEditingController _editingController = TextEditingController();
  final TextEditingController _newCommentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    post = widget.post;
    comments = List<Map<String, dynamic>>.from(post['comments'] ?? []);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        final currentViews = int.tryParse(post['views'].toString()) ?? 0;
        post['views'] = currentViews + 1;
      });
    });
  }

  @override
  void dispose() {
    post['comments'] = comments;
    Navigator.pop(context, post);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6FB),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, post),
        ),
        title: const Text('댕근 커뮤니티', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.pinkAccent : null,
            ),
            onPressed: () => setState(() => isLiked = !isLiked),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updatedPost = await Navigator.pushNamed(
                context,
                '/community/edit',
                arguments: {
                  'id': post['id'],
                  'title': post['title'],
                  'content': post['content'],
                  'category': post['category'],
                },
              );

              if (updatedPost != null && updatedPost is Map<String, dynamic>) {
                setState(() {
                  post['title'] = updatedPost['title'];
                  post['content'] = updatedPost['content'];
                  post['category'] = updatedPost['category'];
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('게시글 삭제'),
                  content: const Text('정말 이 게시글을 삭제하시겠어요?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // 닫기
                        Navigator.pop(context, {'deleted': true, 'id': post['id']});
                      },
                      child: const Text('삭제', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],

      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post['title'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('작성자: ${post['author']}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            Text('지   역: ${post['location']}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            Text(post['category'], style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            const Divider(),
            Text(post['content'], style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 80),
            Text('조회수: ${post['views']}회', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            const Divider(height: 32),
            const Text('댓글', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newCommentController,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      filled: true,
                      fillColor: const Color(0xFFF8F3FF),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final text = _newCommentController.text.trim();
                    if (text.isNotEmpty) {
                      setState(() {
                        comments.insert(0, {
                          'author': dummyUser['nickname'],
                          'content': text,
                          'createdAt': TimeOfDay.now().format(context),
                        });
                        _newCommentController.clear();
                      });
                    }
                  },
                  child: const Text('등록'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  final isEditing = editingIndex == index;
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F0F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(comment['author'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            isEditing
                                ? Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check, color: Colors.green),
                                  onPressed: () {
                                    setState(() {
                                      comments[index]['content'] = _editingController.text;
                                      editingIndex = null;
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.clear, color: Colors.red),
                                  onPressed: () => setState(() => editingIndex = null),
                                ),
                              ],
                            )
                                : Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 18),
                                  onPressed: () {
                                    setState(() {
                                      editingIndex = index;
                                      _editingController.text = comment['content'];
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => setState(() => comments.removeAt(index)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        isEditing
                            ? TextField(
                          controller: _editingController,
                          maxLines: null,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        )
                            : Text(comment['content']),
                        const SizedBox(height: 4),
                        Text(comment['createdAt'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
