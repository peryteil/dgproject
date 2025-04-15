import 'package:flutter/material.dart';

class CommunityWritePage extends StatefulWidget {
  const CommunityWritePage({super.key});

  @override
  State<CommunityWritePage> createState() => _CommunityWritePageState();
}

class _CommunityWritePageState extends State<CommunityWritePage> {
  final _formKey = GlobalKey<FormState>();
  String selectedCategory = '자유게시판';
  String title = '';
  String content = '';

  final List<String> categories = ['자유게시판', '소모임', '펫시터', '댕댕이 찾기'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, String>) {
      String incomingCategory = args['category'] ?? '자유게시판';
      if (incomingCategory == '자유') incomingCategory = '자유게시판';

      if (categories.contains(incomingCategory)) {
        selectedCategory = incomingCategory;
      }
      title = args['title'] ?? '';
      content = args['content'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('글쓰기')),
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
                initialValue: title,
                decoration: const InputDecoration(labelText: '제목'),
                onChanged: (value) => title = value,
                validator: (value) => value!.isEmpty ? '제목을 입력하세요' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: content,
                decoration: const InputDecoration(labelText: '내용'),
                maxLines: 5,
                onChanged: (value) => content = value,
                validator: (value) => value!.isEmpty ? '내용을 입력하세요' : null,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newPost = {
                      "title": title,
                      "content": content,
                      "category": selectedCategory,
                      "author": "탄이누나", // ✅ 작성자 더미 추가
                    };
                    Navigator.pop(context, newPost);
                  }
                },
                child: const Text('등록하기'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
