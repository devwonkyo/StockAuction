import 'package:auction/config/color.dart';
import 'package:auction/models/comment_model.dart';
import 'package:auction/providers/auction_timer_provider.dart';
import 'package:auction/screens/post/bid_list_screen.dart';
import 'package:auction/screens/post/widgets/comment_widget.dart';
import 'package:auction/screens/post/widgets/favorite_button_widget.dart';
import 'package:auction/screens/post/widgets/timer_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:provider/provider.dart';
import '../../providers/text_provider.dart';

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
        title: Text("게시물",style: TextStyle(fontSize: 20.0),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // 뒤로가기 아이콘
          onPressed: () {
            Navigator.pop(context); // 이전 페이지로 이동
          },
        ),
        actions: [
          "userId" == "userId"
              ? //todo postUserId와 같을때
              IconButton(
                  icon: const Icon(Icons.more_vert_outlined),
                  onPressed: () {
                    _showOptionsBottomSheet(context);
                  },
                )
              : const SizedBox.shrink(),
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
                                'Nike x Sacai VaporWaffle Dark',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                            FavoriteButtonWidget(
                              isFavorited: false,
                            )
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
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '댓글 3', //Todo 댓글 수 추가
                              style: TextStyle(fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showCommentBottomSheet(context);
                              },
                              child: Text(
                                '댓글 쓰기',
                                style: TextStyle(fontSize: 14),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return CommentWidget(
                                commentModel: CommentModel(
                                    userId: "userId",
                                    comment: "comment",
                                    time: "time"));
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => AuctionTimerProvider(20), //todo 시간 계산해서 넣어주기
            child: Align(
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
                        const TimerTextWidget(
                          time: 30,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('750,000원',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => BidListScreen())),
                          child: Row(
                            children: [
                              Icon(Icons.arrow_drop_up,color: Colors.redAccent,),
                              Text('90,000원 (+13.6%)',
                                  //todo provider에서 계산 결과 string으로 변환 후 넣기
                                  style: TextStyle(fontSize: 18, color: Colors.redAccent)),
                            ],
                          ),
                        ),
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
                        const SizedBox(
                          width: 20,
                        ),
                        Consumer<AuctionTimerProvider>(
                          builder: (context, auctionTimerProvider, child) {
                            return ElevatedButton(
                              onPressed: auctionTimerProvider.remainingTime != 0
                                  ? () {
                                      //pressed
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    auctionTimerProvider.remainingTime != 0
                                        ? Color(0xFF65AE7E)
                                        : Colors.grey,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                              ),
                              child: Text(
                                '입찰하기',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  //Comment Bottom Sheet
  void _showCommentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ChangeNotifierProvider(   //provier 주입
          create: (context) => TextProvider(),
          child: DraggableScrollableSheet(
            expand: true,
            snapAnimationDuration: const Duration(milliseconds: 400),
            initialChildSize: 0.95,
            minChildSize: 0.95,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              final textColorProvider = Provider.of<TextProvider>(context);
              return Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    // Drag handle
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text("댓글"),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 10, // number of comments
                              itemBuilder: (context, index) {
                                return CommentWidget(
                                    commentModel: CommentModel(
                                        userId: "userId",
                                        comment: "comment",
                                        time: "time"));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      // MediaQuery를 사용하여 키보드가 올라올 때 Padding 조정
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context)
                            .viewInsets
                            .bottom, // 키보드 높이만큼 패딩
                        top: 10.0,
                        left: 8.0,
                        right: 8.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: textColorProvider.commentController,
                              decoration: InputDecoration(
                                hintText: '댓글 추가...',
                                hintStyle: const TextStyle(color: Colors.grey),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          textColorProvider.isTextEmpty ?
                          const IconButton(
                            icon: Icon(Icons.send, color: Colors.grey),
                            onPressed: null,
                          )
                          :
                          IconButton(
                            icon: const Icon(Icons.send, color: AppsColor.pastelGreen),
                            onPressed: () {
                              // 댓글 작성 로직
                              print(textColorProvider.commentController.text);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  //삭제 수정 옵션 BottomSheet
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
