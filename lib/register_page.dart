import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _personalityController = TextEditingController();
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _petAgeController = TextEditingController();

  String _petGender = '남아';
  // XFile? _pickedImage;

  bool _isLoading = false;

  // Future<void> _pickImage() async {
  //   final ImagePicker picker = ImagePicker();
  //   final picked = await picker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     _pickedImage = picked;
  //   });
  // }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', _emailController.text.trim());
      await prefs.setString('password', _passwordController.text);
      await prefs.setString('username', _usernameController.text.trim());

      await Future.delayed(const Duration(seconds: 1)); // 등록 처리 완료 시점

      if (!mounted) return;
      // Navigator.pushReplacementNamed(context, '/'); // ✅ 홈으로 이동

      // 혹은 로그인 페이지로 이동하고 싶다면:
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscure = false, TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
        (value == null || value.isEmpty) ? '$label을(를) 입력해주세요' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('이메일', _emailController, type: TextInputType.emailAddress),
              _buildTextField('비밀번호', _passwordController, obscure: true),
              _buildTextField('비밀번호 확인', _repeatPasswordController, obscure: true),
              _buildTextField('닉네임', _usernameController),
              _buildTextField('지역', _locationController),
              const SizedBox(height: 8),
              _buildTextField('반려견 이름', _petNameController),
              _buildTextField('반려견 나이', _petAgeController, type: TextInputType.number),
              DropdownButtonFormField(
                value: _petGender,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '반려견 성별',
                ),
                items: const [
                  DropdownMenuItem(value: '남아', child: Text('남아')),
                  DropdownMenuItem(value: '여아', child: Text('여아')),
                ],
                onChanged: (value) => setState(() => _petGender = value!),
              ),
              const SizedBox(height: 8),
              _buildTextField('견종', _breedController),
              _buildTextField('성격', _personalityController),
              const SizedBox(height: 16),
              // Row(
              //   children: [
              //     _pickedImage != null
              //         ? Image.file(
              //       File(_pickedImage!.path),
              //       width: 80,
              //       height: 80,
              //       fit: BoxFit.cover,
              //     )
              //         : const Icon(Icons.image, size: 80, color: Colors.grey),
              //     const SizedBox(width: 12),
              //     ElevatedButton(
              //       onPressed: _pickImage,
              //       child: const Text('반려견 사진 업로드'),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                child: Text(_isLoading ? '가입 중...' : '회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
