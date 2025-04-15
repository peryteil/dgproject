import 'dart:io';
import 'package:flutter/material.dart';
import 'market_write_page.dart';

class MarketItemPage extends StatelessWidget {
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>)? onUpdate;
  final Function(String)? onDelete;
  final Function()? onGoBack;

  const MarketItemPage({
    super.key,
    required this.product,
    this.onUpdate,
    this.onDelete,
    this.onGoBack,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = product['image'];

    return Scaffold(
      appBar: AppBar(
        title: Text(product['title']),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MarketWritePage(
                    product: product,
                    onSubmit: (updatedProduct) {
                      onUpdate?.call(updatedProduct);
                    },
                  ),
                ),
              );
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              if (onDelete != null) {
                onDelete!(product['id'].toString());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('상품이 삭제되었습니다.')),
                );
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imagePath != null && imagePath != ''
                ? imagePath.startsWith('images/')
                ? Image.asset(imagePath)
                : File(imagePath).existsSync()
                ? Image.file(File(imagePath))
                : const Icon(Icons.broken_image, size: 100)
                : const Icon(Icons.image_not_supported, size: 100),
            const SizedBox(height: 16),
            Text(product['title'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('${product['price']}원'),
            const SizedBox(height: 8),
            Text('판매자: ${product['sellerNickname']}'),
            const SizedBox(height: 8),
            Text('지역: ${product['location']}'),
            const SizedBox(height: 8),
            Text('조회수: ${product['views']}'),
            const SizedBox(height: 16),
            Text(product['description']),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),
            CommentSection(),
          ],
        ),
      ),
    );
  }
}

class CommentSection extends StatefulWidget {
  const CommentSection({super.key});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  List<Map<String, dynamic>> comments = [
    {
      "id": 1,
      "userId": 1,
      "nickname": "초코아빠",
      "content": "가격 좀 깎아주세요!",
      "createdAt": DateTime.now().subtract(Duration(hours: 2)).toString()
    },
    {
      "id": 2,
      "userId": 2,
      "nickname": "귤귤이",
      "content": "연락처 남겨주세요.",
      "createdAt": DateTime.now().subtract(Duration(hours: 1)).toString()
    },
  ];

  final TextEditingController commentController = TextEditingController();
  final TextEditingController editController = TextEditingController();

  final currentUserId = 1;
  int? editingCommentId;

  void addComment() {
    if (commentController.text.trim().isEmpty) return;

    final newComment = {
      "id": comments.length + 1,
      "userId": currentUserId,
      "nickname": "장원영",
      "content": commentController.text.trim(),
      "createdAt": DateTime.now().toString()
    };

    setState(() {
      comments.insert(0, newComment);
      commentController.clear();
    });
  }

  void deleteComment(int id) {
    setState(() {
      comments.removeWhere((c) => c['id'] == id);
    });
  }

  void startEditComment(Map<String, dynamic> comment) {
    setState(() {
      editingCommentId = comment['id'];
      editController.text = comment['content'];
    });
  }

  void saveEditedComment() {
    if (editController.text.trim().isEmpty || editingCommentId == null) return;

    setState(() {
      final index = comments.indexWhere((c) => c['id'] == editingCommentId);
      if (index != -1) {
        comments[index]['content'] = editController.text.trim();
        editingCommentId = null;
        editController.clear();
      }
    });
  }

  void cancelEdit() {
    setState(() {
      editingCommentId = null;
      editController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('댓글', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: '댓글을 입력하세요',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: addComment,
              child: Text('등록'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];
            final isCurrentUser = comment['userId'] == currentUserId;
            final isEditing = comment['id'] == editingCommentId;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 닉네임 + 아이콘
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(comment['nickname'], style: TextStyle(fontWeight: FontWeight.bold)),
                        if (isCurrentUser && !isEditing)
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, size: 20),
                                onPressed: () => startEditComment(comment),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, size: 20),
                                onPressed: () => deleteComment(comment['id']),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    /// 댓글 내용 or 수정 입력 필드
                    isEditing
                        ? Column(
                      children: [
                        TextField(
                          controller: editController,
                          autofocus: true,
                          decoration: InputDecoration(hintText: '댓글 수정'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.check, color: Colors.green),
                              onPressed: saveEditedComment,
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.grey),
                              onPressed: cancelEdit,
                            ),
                          ],
                        ),
                      ],
                    )
                        : Text(comment['content']),
                    const SizedBox(height: 4),
                    Text(
                      comment['createdAt'].substring(11, 16),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
