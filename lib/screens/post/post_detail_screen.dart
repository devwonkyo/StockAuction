import 'package:auction/screens/post/widgets/favorite_button_widget.dart';
import 'package:auction/screens/post/widgets/timer_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:provider/provider.dart';


class PostDetailScreen extends StatefulWidget {
  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_outlined),
            onPressed: () {
              _showOptionsBottomSheet(context);
            },
          ),
        ],
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
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Nike x Sacai VaporWaffle Dark Iris',
                                style: TextStyle(
                                    fontSize: 24),
                              ),
                            ),
                            FavoriteButtonWidget(isFavorited: false,)
                          ],
                        ),
                        SizedBox(height: 15),
                        Text(
                          '조금은 긴 글내용/Users/wonkyo/Documents/elice/Auction/aution/lib/screens/post/post_detail_screen.dart조금은 긴 글내용/Users/wonkyo/Documents/elice/Auction/aution/lib/screens/post/post_detail_screen.dart'
                          '조금은 긴 글내용/Users/wonkyo/Documents/elice/Auction/aution/lib/screens/post/post_detail_screen.dart'
                          '조금은 긴 글내용/Users/wonkyo/Documents/elice/Auction/aution/lib/screens/post/post_detail_screen.dart조금은 긴 글내용/Users/wonkyo/Documents/elice/Auction/aution/lib/screens/post/post_detail_screen.dart'
                          '조금은 긴 글내용/Users/wonkyo/Documents/elice/Auction/aution/lib/screens/post/post_detail_screen.dart'
                          '조금은 긴 글내용/Users/wonkyo/Documents/elice/Auction/aution/lib/screens/post/post_detail_screen.dart'
                          'ㅍ'
                          '조금은 긴 글내용/Users/wonkyo/Documents/elice/Auction/aution/lib/screens/post/post_detail_screen.dart',
                          style: TextStyle(
                              fontSize: 15),
                        ),
                        SizedBox(height: 30.0,),
                        Divider(height: 1, color: Colors.grey,),
                        SizedBox(height: 30.0,),
                        Text(
                          '댓글 3',
                          style: TextStyle(
                              fontSize: 14),
                        ),
                        ListView.builder(
                          itemCount: 3,
                          itemBuilder:(context, index){
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                              ],
                            );
                          },
                        )
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('현재 입찰가', style: TextStyle(fontSize: 16)),
                      TimerTextWidget(time: 530,),
                    ],
                  ),
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
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '가격을 입력해주세요',
                        )),
                      ),
                      const SizedBox(width: 20,),
                      ElevatedButton(
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF65AE7E),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        child: Text(
                          '입찰하기',
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

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('수정'),
                onTap: () {
                  Navigator.of(context).pop(); // 시트 닫기
                  _editItem(context); // 수정 처리
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('삭제'),
                onTap: () {
                  Navigator.of(context).pop(); // 시트 닫기
                  _deleteItem(context); // 삭제 처리
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text('취소'),
                onTap: () {
                  Navigator.of(context).pop(); // 시트 닫기
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editItem(BuildContext context) {
    // 수정 처리 로직
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('수정 기능이 호출되었습니다.')),
    );
  }

  void _deleteItem(BuildContext context) {
    // 삭제 처리 로직
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('삭제 기능이 호출되었습니다.')),
    );
  }
}


