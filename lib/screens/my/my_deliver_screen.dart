import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyDeliverScreen extends StatefulWidget {
  const MyDeliverScreen({Key? key}) : super(key: key);

  @override
  _MyDeliverScreenState createState() => _MyDeliverScreenState();
}

class _MyDeliverScreenState extends State<MyDeliverScreen> {
  List<Map<String, dynamic>> addresses = [
    {'address': '서울시 강남구 테헤란로 123', 'isDefault': true},
    {'address': '서울시 마포구 월드컵북로 456', 'isDefault': false},
  ];

  // 배송지 추가 함수
  void _addNewAddress(String newAddress) {
    setState(() {
      addresses.add({'address': newAddress, 'isDefault': false});
    });
  }

  // 기본 배송지 설정 함수
  void _setDefaultAddress(int index) {
    setState(() {
      for (var i = 0; i < addresses.length; i++) {
        addresses[i]['isDefault'] = i == index;
      }
    });
  }

  // 배송지 추가 다이얼로그
  Future<void> _showAddAddressDialog() async {
    String newAddress = '';
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('새 배송지 추가'),
          content: TextField(
            onChanged: (value) {
              newAddress = value;
            },
            decoration: const InputDecoration(hintText: "새로운 배송지를 입력하세요"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('추가'),
              onPressed: () {
                if (newAddress.isNotEmpty) {
                  _addNewAddress(newAddress);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('배송지 관리'),
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
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ListTile(
            title: const Text(
              '기본 배송지',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(addresses[index]['address']),
                trailing: addresses[index]['isDefault']
                    ? const Text('기본', style: TextStyle(color: Colors.blue))
                    : TextButton(
                        onPressed: () => _setDefaultAddress(index),
                        child: const Text('기본 설정'),
                      ),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('배송지 추가'),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: _showAddAddressDialog, // 배송지 추가 다이얼로그 열기
            ),
          ),
        ],
      ),
    );
  }
}
