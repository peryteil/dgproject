import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MarketWritePage extends StatefulWidget {
  final Function(Map<String, Object>) onSubmit;
  final Map<String, dynamic>? product;

  MarketWritePage({required this.onSubmit, this.product});

  @override
  _MarketWritePageState createState() => _MarketWritePageState();
}

class _MarketWritePageState extends State<MarketWritePage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String price = '';
  String description = '';
  List<File> images = [];

  bool isSubmitting = false;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      title = widget.product!['title'] ?? '';
      price = widget.product!['price'].toString();
      description = widget.product!['description'] ?? '';
      if (widget.product!['image'] != null &&
          widget.product!['image'] != '' &&
          !widget.product!['image'].startsWith('images/')) {
        images = [File(widget.product!['image'])];
      }
    }
  }

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        images.add(File(picked.path));
      });
    }
  }

  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isSubmitting = true;
      });

      try {
        String imagePath = '';
        if (images.isNotEmpty) {
          imagePath = images[0].path;
        } else if (widget.product?['image'] != null) {
          imagePath = widget.product!['image'];
        }

        if (imagePath.isEmpty) {
          throw Exception('이미지 경로가 유효하지 않습니다.');
        }

        final Map<String, Object> updatedProduct = {
          'id': widget.product?['id'] ?? DateTime.now().millisecondsSinceEpoch,
          'title': title,
          'price': int.tryParse(price) ?? 0,
          'description': description,
          'location': widget.product?['location'] ?? '서울',
          'sellerNickname': widget.product?['sellerNickname'] ?? '탄이누나',
          'views': widget.product?['views'] ?? 0,
          'createdAt': widget.product?['createdAt'] ?? DateTime.now().toString(),
          'image': imagePath,
          'comments': widget.product?['comments'] ?? <Map<String, dynamic>>[],
        };

        widget.onSubmit(updatedProduct);

        setState(() => isSubmitting = false);
        Navigator.pop(context);
      } catch (e, stackTrace) {
        print('❌ 등록 중 에러 발생: $e');
        print(stackTrace);
        setState(() => isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('등록 중 오류로 인해 성공하지 못했어요.\n${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F8),
      appBar: AppBar(
        title: Text(widget.product != null ? '상품 수정' : '상품 등록'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(labelText: '제목'),
                onSaved: (value) => title = value ?? '',
                validator: (value) => value!.isEmpty ? '제목을 입력해주세요.' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: price,
                decoration: InputDecoration(labelText: '가격'),
                keyboardType: TextInputType.number,
                onSaved: (value) => price = value ?? '',
                validator: (value) => value!.isEmpty ? '가격을 입력해주세요.' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: '설명'),
                maxLines: 3,
                onSaved: (value) => description = value ?? '',
                validator: (value) => value!.isEmpty ? '설명을 입력해주세요.' : null,
              ),
              SizedBox(height: 16),
              Text('이미지 업로드 (1장씩 추가 가능)',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: pickImage,
                icon: Icon(Icons.image),
                label: Text('이미지 선택'),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: images
                    .map((file) => Image.file(file,
                    width: 80, height: 80, fit: BoxFit.cover))
                    .toList() +
                    (widget.product != null &&
                        (widget.product!['image'] ?? '').startsWith('images/') &&
                        images.isEmpty
                        ? [
                      Image.asset(
                        widget.product!['image'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    ]
                        : []),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: isSubmitting ? null : () => Navigator.pop(context),
                    child: Text('취소'),
                  ),
                  ElevatedButton(
                    onPressed: isSubmitting ? null : handleSubmit,
                    child: Text(isSubmitting
                        ? '처리 중...'
                        : widget.product != null
                        ? '수정 완료'
                        : '등록'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
