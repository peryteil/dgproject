import 'package:flutter/material.dart';

class CommunityEditPage extends StatefulWidget {
  const CommunityEditPage({super.key});

  @override
  State<CommunityEditPage> createState() => _CommunityEditPageState();
}

class _CommunityEditPageState extends State<CommunityEditPage> {
  final _formKey = GlobalKey<FormState>();
  final List<String> categories = ['자유게시판', '소모임', '펫시터', '댕댕이 찾기'];
  String selectedCategory = '자유게시판';
  String title = '';
  String content = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      setState(() {
        selectedCategory = args['category'] ?? '자유게시판';
        title = args['title'] ?? '';
        content = args['content'] ?? '';
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('게시글 수정')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField(
                value: selectedCategory,
                items: categories.map((cat) => DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                decoration: const InputDecoration(labelText: '카테고리'),
              ),
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: '제목'),
                onChanged: (value) => title = value,
              ),
              TextFormField(
                initialValue: content,
                decoration: const InputDecoration(labelText: '내용'),
                maxLines: 5,
                onChanged: (value) => content = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'title': title,
                    'content': content,
                    'category': selectedCategory,
                  });
                },
                child: const Text('수정 완료'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
