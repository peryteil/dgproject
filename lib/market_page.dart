import 'dart:io';
import 'package:flutter/material.dart';
import 'market_write_page.dart';
import 'market_item_page.dart';

class MarketPage extends StatefulWidget {
  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];

  int currentPage = 1;
  final int itemsPerPage = 6;
  String searchTerm = "";

  final List<String> locations = [
    "서울", "부산", "대구", "인천", "서울",
    "대전", "서울", "강릉", "제주", "서울",
    "대전", "서울", "천안", "용인", "제주"
  ];

  @override
  void initState() {
    super.initState();
    loadDummyData();
  }

  void loadDummyData() {
    final sellerNames = [
      "탄이누나", "토토", "구름이", "하늘이", "복순이",
      "쭈꾸미", "바둑이", "콩이", "모찌", "루비",
      "떡이", "쪼꼬미", "바나나", "마루", "호두"
    ];

    final productTitles = [
      "귀여운 인형 입니다", "강아지 공 팔아요", "오리 인형 입니다", "강아지 간식",
      "강아지 잠옷", "분홍색 강아지 옷 올려봐요 ", "소형견 옷 팔아요", "넘 귀여운 강아지 가방",
      "강아지 침대", "푹신한 집 입니다 ", "얼마안 쓴 계단 입니다", "강아지 의자 싸게 올려요",
      "강아지 수건 좋아요", "가방 넘 귀엽죠", "산책할 때 최고"
    ];

    final dummy = List.generate(15, (index) {
      final imgNum = (index + 1).toString().padLeft(2, '0');

      List<Map<String, dynamic>> dummyComments = [];

      if (index == 0) {
        dummyComments = [
          {"id": 1, "userId": 1, "nickname": "루이형", "content": "혹시 배송 가능한가요?", "createdAt": "2025-04-15T02:47:44"},
          {"id": 2, "userId": 2, "nickname": "초코맘", "content": "가격 좀 내릴 수 있을까요?", "createdAt": "2025-04-15T02:50:44"},
          {"id": 3, "userId": 3, "nickname": "귤귤이", "content": "이거 너무 귀엽네요!", "createdAt": "2025-04-15T07:47:44"},
        ];
      } else if (index == 1) {
        dummyComments = [
          {"id": 1, "userId": 1, "nickname": "뽀미언니", "content": "직거래 가능한가요?", "createdAt": "2025-04-17T01:47:44"},
          {"id": 2, "userId": 2, "nickname": "콩이아빠", "content": "사이즈가 어떻게 되나요?", "createdAt": "2025-04-16T07:47:44"},
        ];
      } else if (index == 2) {
        dummyComments = [
          {"id": 1, "userId": 1, "nickname": "뽀미언니", "content": "연락처 남겨주세요!", "createdAt": "2025-04-15T10:47:44"},
          {"id": 2, "userId": 2, "nickname": "콩이아빠", "content": "상태 괜찮은가요?", "createdAt": "2025-04-16T15:47:44"},
        ];
      }

      return {
        'id': index,
        'title': productTitles[index],
        'price': (index + 1) * 1000,
        'location': locations[index % locations.length],
        'sellerNickname': sellerNames[index],
        'views': index * 5,
        'description': productTitles[index],
        'createdAt': DateTime.now().subtract(Duration(days: index)).toString(),
        'image': 'images/product$imgNum.PNG',
        'comments': dummyComments,
      };
    });

    setState(() {
      products = dummy;
      filteredProducts = dummy;
    });
  }

  void handleNewProduct(Map<String, dynamic> newProduct) {
    setState(() {
      products.insert(0, Map<String, Object>.from(newProduct));
      filteredProducts = List<Map<String, dynamic>>.from(products);
    });
  }


  void handleSearch(String value) {
    setState(() {
      searchTerm = value;
      currentPage = 1;
      if (value.isNotEmpty) {
        filteredProducts = products.where((product) {
          return product['title'].toLowerCase().contains(value.toLowerCase()) ||
              product['location'].toLowerCase().contains(value.toLowerCase()) ||
              product['sellerNickname'].toLowerCase().contains(value.toLowerCase());
        }).toList();
      } else {
        filteredProducts = products;
      }
    });
  }

  void handleDeleteProduct(String id) {
    setState(() {
      products.removeWhere((item) => item['id'].toString() == id);
      filteredProducts.removeWhere((item) => item['id'].toString() == id);
    });
  }

  void handleUpdateProduct(Map<String, dynamic> updatedProduct) {
    setState(() {
      final index = products.indexWhere((item) => item['id'] == updatedProduct['id']);
      if (index != -1) {
        products[index] = updatedProduct;
        filteredProducts = products;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (filteredProducts.length / itemsPerPage).ceil();
    final start = (currentPage - 1) * itemsPerPage;
    final end = (start + itemsPerPage).clamp(0, filteredProducts.length);
    final currentItems = filteredProducts.sublist(start, end);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F8),
      appBar: AppBar(
        title: const Text('댕근마켓', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: '찾으시는 물품을 검색해보세요',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.deepPurpleAccent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.deepPurpleAccent),
                ),
              ),
              onChanged: handleSearch,
            ),
          ),
          Expanded(
            child: currentItems.isNotEmpty
                ? GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: currentItems.length,
              itemBuilder: (context, index) {
                final item = currentItems[index];
                final imagePath = item['image'];
                final isLocalFile = imagePath != null && !imagePath.startsWith('images/');

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      final currentViews = int.tryParse(item['views'].toString()) ?? 0;
                      item['views'] = currentViews + 1;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MarketItemPage(
                          product: item,
                          onUpdate: handleUpdateProduct,
                          onDelete: handleDeleteProduct,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(6),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(12)),
                            child: isLocalFile
                                ? Image.file(File(imagePath), fit: BoxFit.cover, width: double.infinity)
                                : Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 13),
                              Text('작성자: ${item['sellerNickname']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              Text('위치: ${item['location']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              Text('${item['price']}원', style: const TextStyle(fontSize: 13)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('조회수: ${item['views']}회', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                  const Icon(Icons.pets, size: 20, color: Color(0xFF3C3C3C)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
                : const Center(child: Text("검색 결과가 없습니다.")),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: currentPage > 1 ? () => setState(() => currentPage--) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('이전'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: currentPage < totalPages ? () => setState(() => currentPage++) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF8F3FF),
                    foregroundColor: Colors.deepPurple,
                    side: const BorderSide(color: Colors.deepPurple),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('다음'),
                ),
              ],
            ),
            Positioned(
              right: 0,
              child: FloatingActionButton.small(
                backgroundColor: Colors.pink,
                onPressed: () async {
                  final newProduct = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MarketWritePage(onSubmit: handleNewProduct),
                    ),
                  );
                  if (newProduct != null && newProduct is Map<String, dynamic>) {
                    newProduct['comments'] = []; // ✅ 새 글 댓글 초기화
                    handleNewProduct(newProduct);
                  }
                },
                child: const Icon(Icons.edit, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
