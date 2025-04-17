import 'package:flutter/material.dart';

class CommunityWritePage extends StatefulWidget {
  final Map<String, String>? post;

  const CommunityWritePage({super.key, this.post}); // 수정할 게시글 정보 받을 수 있게!

  @override
  State<CommunityWritePage> createState() => _CommunityWritePageState();
}

class _CommunityWritePageState extends State<CommunityWritePage> {
  final _formKey = GlobalKey<FormState>();
  final List<String> categories = ['자유게시판', '소모임', '펫시터', '댕댕이 찾기'];

  late String selectedCategory;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 초기값 설정 (수정일 경우)
    selectedCategory = widget.post?['category'] ?? '자유게시판';
    _titleController.text = widget.post?['title'] ?? '';
    _contentController.text = widget.post?['content'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post != null ? '게시글 수정' : '글쓰기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: '카테고리'),
                value: selectedCategory,
                items: categories
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: '제목'),
                validator: (value) => value!.isEmpty ? '제목을 입력하세요' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: '내용'),
                maxLines: 5,
                validator: (value) => value!.isEmpty ? '내용을 입력하세요' : null,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedPost = {
                      "title": _titleController.text.trim(),
                      "content": _contentController.text.trim(),
                      "category": selectedCategory,
                    };
                    Navigator.pop(context, updatedPost);
                  }
                },
                child: Text(widget.post != null ? '수정 완료' : '등록하기'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
