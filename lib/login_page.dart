import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _loginError;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _loginError = null;
    });

    final enteredEmail = _emailController.text.trim();
    final enteredPassword = _passwordController.text;

    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('userEmail');
    final storedPassword = prefs.getString('password');

    if (enteredEmail == storedEmail && enteredPassword == storedPassword) {
      Navigator.pushReplacementNamed(context, '/');
    } else {
      setState(() {
        _loginError = '이메일 또는 비밀번호가 일치하지 않습니다.';
      });
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: SingleChildScrollView( // 변경!
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column( // 변경!
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '댕근 서비스를 이용하려면 로그인해주세요.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),

              if (_loginError != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.red[100],
                  child: Text(
                      _loginError!, style: const TextStyle(color: Colors.red)),
                ),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: '이메일',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? '이메일을 입력해주세요.' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) =>
                value == null || value.isEmpty ? '비밀번호를 입력해주세요.' : null,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: Text(_isLoading ? '로그인 중...' : '로그인'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
