import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class PostDetailPage extends StatefulWidget {
  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  int _selectedIndex = 0;

  // 네비게이터의 아이템 선택 시 처리 함수
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _images = [
      'lib/assets/image/pic1.png',
      'lib/assets/image/pic2.png',
      'lib/assets/image/pic3.jpeg',
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left_sharp),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이미지 스와이프 구현 부분
                  SizedBox(
                    height: 300,
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return Image.asset(
                          _images[index],
                          fit: BoxFit.cover,
                        );
                      },
                      itemCount: _images.length, // 이미지 개수
                      pagination: const SwiperPagination(),
                    ),
                  ),
                  // 제품 정보 부분
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nike x Sacai VaporWaffle Dark Iris',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '조금은 긴 글내용/Users/wonkyo/Documents/elice/Auction/aution/lib/screens/post/post_detail_screen.dart조금은 긴 글내용/Users/wonkyo/Documents/elice/Auction/aution/lib/screens/post/post_detail_screen.dart'
                          '조금은 긴 글내용/Users/wonkyo/Documents/elice/Auction/aution/lib/screens/post/post_detail_screen.dart'
                          '조금은 긴 글내용/Users/wonkyo/Documents/elice/Auction/aution/lib/screens/post/post_detail_screen.dart조금은 긴 글내용/Users/wonkyo/Documents/elice/Auction/aution/lib/screens/post/post_detail_screen.dart'
                          '조금은 긴 글내용/Users/wonkyo/Documents/elice/Auction/aution/lib/screens/post/post_detail_screen.dart'
                          '조금은 긴 글내용/Users/wonkyo/Documents/elice/Auction/aution/lib/screens/post/post_detail_screen.dart'
                          'ㅍ'
                          '조금은 긴 글내용/Users/wonkyo/Documents/elice/Auction/aution/lib/screens/post/post_detail_screen.dart',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('최근 거래가', style: TextStyle(fontSize: 16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('750,000원',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      Text('+90,000원 (+13.6%)',
                          style: TextStyle(fontSize: 18, color: Colors.red)),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextField(
                            decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '가격을 입력해주세요',
                        )),
                      ),
                      const SizedBox(width: 10,),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF65AE7E),
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                        ),
                        child: Text(
                          '입찰',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
