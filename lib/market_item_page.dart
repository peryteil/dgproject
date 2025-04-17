import 'dart:io';
import 'package:flutter/material.dart';
import 'market_write_page.dart';

class MarketItemPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>)? onUpdate;
  final Function(String)? onDelete;

  const MarketItemPage({
    super.key,
    required this.product,
    this.onUpdate,
    this.onDelete,
  });

  @override
  State<MarketItemPage> createState() => _MarketItemPageState();
}

class _MarketItemPageState extends State<MarketItemPage> {
  bool isLiked = false; // 하트 상태
  List<Map<String, dynamic>> comments = [];

  final TextEditingController commentController = TextEditingController();
  final TextEditingController editController = TextEditingController();
  final currentUserId = 1;
  int? editingCommentId;

  @override
  void initState() {
    super.initState();
    comments = List<Map<String, dynamic>>.from(widget.product['comments'] ?? []);
  }

  void addComment() {
    if (commentController.text.trim().isEmpty) return;

    final newComment = {
      "id": DateTime.now().millisecondsSinceEpoch,
      "userId": currentUserId,
      "nickname": "장원영",
      "content": commentController.text.trim(),
      "createdAt": DateTime.now().toString()
    };

    setState(() {
      comments.insert(0, newComment);
      commentController.clear();
      widget.product['comments'] = comments;
    });
  }

  void deleteComment(int id) {
    setState(() {
      comments.removeWhere((c) => c['id'] == id);
      widget.product['comments'] = comments;
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
        widget.product['comments'] = comments;
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
    final imagePath = widget.product['image'];

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6FB),
      appBar: AppBar(
        title: const Text('댕근마켓',
          style: TextStyle(fontWeight: FontWeight.bold), ),
        actions: [
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.pinkAccent : null,
            ),
            onPressed: () {
              setState(() {
                isLiked = !isLiked;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MarketWritePage(
                    product: widget.product,
                    onSubmit: (updatedProduct) {
                      widget.onUpdate?.call(updatedProduct);
                    },
                  ),
                ),
              );
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              widget.onDelete?.call(widget.product['id'].toString());
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
            Text(widget.product['title'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('${widget.product['price']}원', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('작성자: ${widget.product['sellerNickname']}', style: TextStyle(color: Colors.grey[600],
                fontWeight: FontWeight.bold)),
            Text('지역: ${widget.product['location']}', style: TextStyle(color: Colors.grey[600],
                fontWeight: FontWeight.bold)),
            const Divider(),
            const SizedBox(height: 16),
            Text(widget.product['description']),
            const SizedBox(height: 80),
            Text('조회수: ${widget.product['views']}회', style: TextStyle(color: Colors.grey[600],
                fontWeight: FontWeight.bold)),
            const Divider(),
            const SizedBox(height: 8),
            _buildCommentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('댓글', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  hintText: '댓글을 입력하세요',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: addComment,
              child: const Text('등록'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
                        Text(comment['nickname'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        if (isCurrentUser && !isEditing)
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () => startEditComment(comment),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 20),
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
                          decoration: const InputDecoration(hintText: '댓글 수정'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: saveEditedComment,
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.grey),
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
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
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
