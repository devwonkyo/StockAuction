import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MySoldScreen extends StatefulWidget {
  const MySoldScreen({Key? key}) : super(key: key);

  @override
  _MySoldScreenState createState() => _MySoldScreenState();
}

class _MySoldScreenState extends State<MySoldScreen> {
  // 판매 상태를 구분하는 bool 값 (true = 판매중, false = 판매완료)
  bool _isSelling = true;

  // 임시로 사용할 판매중 및 판매완료 리스트 데이터
  final List<Map<String, dynamic>> sellingItems = [
    {'title': '상품 1', 'price': 30000, 'image': 'lib/images/item1.png'},
    {'title': '상품 2', 'price': 45000, 'image': 'lib/images/item2.png'},
  ];

  final List<Map<String, dynamic>> soldItems = [
    {'title': '상품 3', 'price': 25000, 'image': 'lib/images/item3.png'},
    {'title': '상품 4', 'price': 60000, 'image': 'lib/images/item4.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              context.pop(); // 스택에 남아있는 페이지가 있을 때만 pop
            } else {
              context.go('/my'); // 스택에 더 이상 페이지가 없다면 메인 화면으로 이동
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 설정 페이지로 이동
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '나의 판매내역',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // 판매중 / 판매완료 토글 버튼
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isSelling = true;
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: _isSelling ? Colors.grey : Colors.white,
                  ),
                  child: const Text('판매중'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isSelling = false;
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: !_isSelling ? Colors.grey : Colors.white,
                  ),
                  child: const Text('판매완료'),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _isSelling ? sellingItems.length : soldItems.length,
              itemBuilder: (context, index) {
                final item =
                    _isSelling ? sellingItems[index] : soldItems[index];
                return ListTile(
                  leading: Image.asset(
                    item['image'], // 상품 이미지
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(item['title']),
                  subtitle: Text('${item['price']}원'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
