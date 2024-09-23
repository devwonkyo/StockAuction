import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyBoughtScreen extends StatefulWidget {
  const MyBoughtScreen({Key? key}) : super(key: key);

  @override
  _MyBoughtScreenState createState() => _MyBoughtScreenState();
}

class _MyBoughtScreenState extends State<MyBoughtScreen> {
  // 구매 기간 검색을 위한 변수
  DateTime? _startDate;
  DateTime? _endDate;

  // 임시로 사용할 구매 리스트 데이터
  final List<Map<String, dynamic>> boughtItems = [
    {'title': '상품 1', 'price': 30000, 'image': 'lib/images/item1.png'},
    {'title': '상품 2', 'price': 45000, 'image': 'lib/images/item2.png'},
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
              context.pop();
            } else {
              context.go('/my');
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
              '나의 구매내역',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // 구매 기간 검색을 위한 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _startDate) {
                    setState(() {
                      _startDate = picked;
                    });
                  }
                },
                child: Text(
                  _startDate == null
                      ? '시작일 선택'
                      : '시작일: ${_startDate!.toLocal()}'.split(' ')[0],
                ),
              ),
              TextButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _endDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _endDate) {
                    setState(() {
                      _endDate = picked;
                    });
                  }
                },
                child: Text(
                  _endDate == null
                      ? '종료일 선택'
                      : '종료일: ${_endDate!.toLocal()}'.split(' ')[0],
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: boughtItems.length,
              itemBuilder: (context, index) {
                final item = boughtItems[index];
                return ListTile(
                  leading: Image.asset(
                    item['image'],
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
