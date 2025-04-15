import 'package:flutter/material.dart';

class CommunityDetailPage extends StatefulWidget {
  const CommunityDetailPage({super.key});

  @override
  State<CommunityDetailPage> createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
  List<Map<String, dynamic>> comments = [];
  final TextEditingController _commentController = TextEditingController();

  int likeCount = 0;
  bool isLiked = false;

  // ✅ 더미 유저 정보
  final dummyUser = {'nickname': '댕댕이사랑꾼'};

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;

    if (args == null || args is! Map<String, String>) {
      return const Scaffold(
        body: Center(child: Text('잘못된 접근입니다')),
      );
    }

    final post = args;

    return Scaffold(
      appBar: AppBar(
        title: const Text('게시글 상세'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updatedPost = await Navigator.pushNamed(
                context,
                '/community/edit',
                arguments: post,
              );

              if (updatedPost != null && updatedPost is Map<String, String>) {
                setState(() {
                  post['title'] = updatedPost['title']!;
                  post['content'] = updatedPost['content']!;
                  post['category'] = updatedPost['category']!;
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
                  content: const Text('정말 삭제하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context, post);
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
            Text(
              post['title'] ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Text(
              "작성자: ${post['author'] ?? '익명'}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isLiked = !isLiked;
                        likeCount += isLiked ? 1 : -1;
                      });
                    },
                  ),
                  Text('$likeCount'),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Text(
              post['category'] ?? '',
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(),
            Text(
              post['content'] ?? '',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 24),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: '댓글 입력',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final text = _commentController.text.trim();
                    if (text.isNotEmpty) {
                      setState(() {
                        comments.insert(0, {
                          'author': dummyUser['nickname'],
                          'comment': text,
                          'liked': false,
                          'likeCount': 0,
                        });
                        _commentController.clear();
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text('댓글', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return ListTile(
                    title: Text(comment['author'] ?? '익명'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(comment['comment'] ?? ''),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.thumb_up,
                                color: comment['liked'] ? Colors.blue : Colors.grey,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  comment['liked'] = !comment['liked'];
                                  comment['likeCount'] += comment['liked'] ? 1 : -1;
                                });
                              },
                            ),
                            Text('${comment['likeCount']}'),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            final newComment = await showDialog<String>(
                              context: context,
                              builder: (context) {
                                final TextEditingController editController =
                                TextEditingController(text: comment['comment']);

                                return AlertDialog(
                                  title: const Text('댓글 수정'),
                                  content: TextField(
                                    controller: editController,
                                    decoration: const InputDecoration(hintText: '댓글을 수정하세요'),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('취소'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, editController.text.trim());
                                      },
                                      child: const Text('저장'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (newComment != null && newComment.isNotEmpty) {
                              setState(() {
                                comments[index]['comment'] = newComment;
                              });
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('댓글 삭제'),
                                content: const Text('이 댓글을 삭제하시겠습니까?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('취소'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        comments.removeAt(index);
                                      });
                                      Navigator.pop(context);
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