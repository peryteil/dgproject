import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'market_page.dart';
import 'register_page.dart';
import 'community_page.dart';
import 'community_write_page.dart';
import 'community_detail_page.dart';
import 'community_edit_page.dart';
import 'find_friend.dart';
import 'exhibition_page.dart';


void main() {
  runApp(const MyApp());
}

class MyAppBarActions extends StatefulWidget {
  const MyAppBarActions({super.key});

  @override
  State<MyAppBarActions> createState() => _MyAppBarActionsState();
}

class _MyAppBarActionsState extends State<MyAppBarActions> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();

  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userEmail = prefs.getString('userEmail');
    setState(() {
      _isLoggedIn = userEmail != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (_isLoggedIn)
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: '로그아웃',
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('userEmail');
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '댕근',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginPage(), // ✅ 로그인 라우트 추가
        '/': (context) => const HomePage(),
        '/register': (context) => const RegisterPage(),
        '/exhibition': (context) => const ExhibitionScreen(),
        '/community': (context) => const CommunityPage(),
        '/community/write': (context) => const CommunityWritePage(),
        '/community/detail': (context) => const CommunityDetailPage(),
        '/community/edit': (context) => const CommunityEditPage(),
        '/market': (context) => MarketPage(),
        '/find': (context) => const FindFriendScreen(),
      },
    );
  }
}

// ✅ HomePage 위젯
class Dog {
  final String image;
  final String userName;
  final String petBreed;
  final int petAge;

  Dog({
    required this.image,
    required this.userName,
    required this.petBreed,
    required this.petAge,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  List<Dog> topDogs = [];
  bool isLoading = true;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadTopDogs();
    _loadUserEmail();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        topDogs = [
          Dog(image: 'assets/images/dog1.jpg', userName: '초코', petBreed: '포메라니안', petAge: 3),
          Dog(image: 'assets/images/dog2.jpg', userName: '복실이', petBreed: '포메라니안', petAge: 2),
          Dog(image: 'assets/images/dog3.jpg', userName: '단추', petBreed: '포메라니안', petAge: 4),
        ];
        isLoading = false;
      });
    });
  }
  void _loadTopDogs() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        topDogs = [
          Dog(image: 'assets/images/dog1.jpg', userName: '초코', petBreed: '포메라니안', petAge: 3),
          Dog(image: 'assets/images/dog2.jpg', userName: '복실이', petBreed: '포메라니안', petAge: 2),
          Dog(image: 'assets/images/dog3.jpg', userName: '단추', petBreed: '포메라니안', petAge: 4),
        ];
        isLoading = false;
      });
    });
  }

  void _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail');
    });
  }

  Widget buildDogCard(Dog dog, String rankEmoji) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.asset( // 또는 Image.network
            dog.image,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(rankEmoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 4),
            Text(dog.userName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Text('${dog.petBreed}, ${dog.petAge}살'),
      ],
    );
  }


  Widget featureCard(String emoji, String title, String desc, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(desc, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 100,
              height: 100,
            ),
          ],
        ),
        actions: const [
          MyAppBarActions(), // 로그인 여부 따라 조건부 렌더링
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '댕근과 함께 하는 즐거운 산책',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('내 강아지에게 딱 맞는 산책 친구를 찾아보세요.'),
            const SizedBox(height: 16),
            if (userEmail == null)
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text('회원가입'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Text('로그인'),
                  ),
                ],
              ),
            const SizedBox(height: 32),
            const Text(
              '이달의 인기 댕댕이',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('댕근 회원들이 가장 많이 찾는 인기 강아지를 소개합니다'),
            const SizedBox(height: 16),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (topDogs.length > 1)
                    Flexible(child: buildDogCard(topDogs[1], '🥈')),
                  if (topDogs.isNotEmpty)
                    Flexible(child: buildDogCard(topDogs[0], '🥇')),
                  if (topDogs.length > 2)
                    Flexible(child: buildDogCard(topDogs[2], '🥉')),
                ],
              ),
            const SizedBox(height: 40),
            const Text(
              '댕근 소개',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('댕근은 강아지 산책 친구를 찾고 소통할 수 있는 커뮤니티입니다.'),
            const Text('산책 친구 매칭, 커뮤니티 등 다양한 기능을 제공합니다.'),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                featureCard('🦴', '댕근 찾기', '산책 약속과 할 일 관리', '/find'),
                featureCard('🎪', '박람회 정보', '예정된 박람회 정보', '/exhibition'),
                featureCard('💬', '커뮤니티', '견주들과 소통', '/community'),
                featureCard('🛒', '댕근마켓', '반려용품 거래', '/market'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');

    // 로그인 되어 있으면 HomePage, 아니면 LoginPage로 이동
    if (email != null && email.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}