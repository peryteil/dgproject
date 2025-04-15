import 'package:flutter/material.dart';
import 'market_write_page.dart';
import 'market_item_page.dart';
import 'dart:io'; // ✅ File 사용하려면 필요

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
      return {
        'id': index,
        'title': productTitles[index],
        'price': (index + 1) * 1000,
        'location': locations[index % locations.length],
        'sellerNickname': sellerNames[index],
        'views': index * 5,
        'description': '${productTitles[index]}',
        'createdAt': DateTime.now().subtract(Duration(days: index)).toString(),
        'image': 'images/product$imgNum.PNG',
      };
    });

    setState(() {
      products = dummy;
      filteredProducts = dummy;
    });
  }

  void handleNewProduct(Map<String, dynamic> newProduct) {
    setState(() {
      products.insert(0, newProduct);
      filteredProducts = products;
    });
  }

  void handleSearch(String value) {
    setState(() {
      searchTerm = value;
      currentPage = 1;
      if (value.isNotEmpty) {
        filteredProducts = products
            .where((product) =>
        product['title'].toLowerCase().contains(value.toLowerCase()) ||
            product['location'].toLowerCase().contains(value.toLowerCase()) ||
            product['sellerNickname'].toLowerCase().contains(value.toLowerCase()))
            .toList();
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

  // 상품 수정 후 갱신
  void handleUpdateProduct(Map<String, dynamic> updatedProduct) {
    setState(() {
      final index = products.indexWhere((item) => item['id'] == updatedProduct['id']);
      if (index != -1) {
        products[index] = updatedProduct;
        filteredProducts = products;  // 필터링된 제품 목록도 업데이트
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
      appBar: AppBar(
        title: Text('댕근마켓'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MarketWritePage(onSubmit: handleNewProduct),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: '찾으시는 물품을 검색해보세요',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: handleSearch,
            ),
          ),
          Expanded(
            child: currentItems.isNotEmpty
                ? GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MarketItemPage(
                          product: item,
                          onUpdate: handleUpdateProduct,  // 수정 후 갱신 처리
                          onDelete: handleDeleteProduct,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: isLocalFile
                              ? Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                              : Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '작성자: ${item['sellerNickname']}',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              SizedBox(height: 4),
                              Text('${item['price']}원'),
                              Text('위치: ${item['location']}'),
                              Text('조회수: ${item['views']}회'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
                : Center(child: Text("검색 결과가 없습니다.")),
          ),
          if (totalPages > 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: currentPage > 1
                        ? () {
                      setState(() {
                        currentPage--;
                      });
                    }
                        : null,
                    child: Text('이전'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: currentPage < totalPages
                        ? () {
                      setState(() {
                        currentPage++;
                      });
                    }
                        : null,
                    child: Text('다음'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
