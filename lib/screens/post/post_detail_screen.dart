import 'package:auction/config/color.dart';
import 'package:auction/models/comment_model.dart';
import 'package:auction/providers/auction_timer_provider.dart';
import 'package:auction/providers/post_provider.dart';
import 'package:auction/providers/auth_provider.dart';
import 'package:auction/route.dart';
import 'package:auction/screens/post/bid_list_screen.dart';
import 'package:auction/screens/post/widgets/comment_widget.dart';
import 'package:auction/screens/post/widgets/favorite_button_widget.dart';
import 'package:auction/screens/post/widgets/timer_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/text_provider.dart';

class PostDetailScreen extends StatefulWidget {
  final String postUid;

  const PostDetailScreen({super.key, required this.postUid});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  bool isFavorited = false; // 좋아요 상태를 저장할 변수

  @override
  void initState() {
    super.initState();
    print("PostUid: ${widget.postUid}");
    // 여기서 초기 좋아요 상태를 불러올 수 있습니다.
    _loadFavoriteStatus();
  }

  void _loadFavoriteStatus() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = await authProvider.getCurrentUser();
    if (currentUser != null) {
      // PostProvider에 해당 포스트의 좋아요 상태를 확인하는 메서드를 추가해야 합니다.
      bool favorited = await postProvider.isPostFavorited(widget.postUid, currentUser.uid);
      setState(() {
        isFavorited = favorited;
      });
    }
  }

  void _toggleFavorite() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = await authProvider.getCurrentUser();
    if (currentUser != null) {
      await postProvider.toggleFavorite(widget.postUid, currentUser);
      setState(() {
        isFavorited = !isFavorited;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인이 필요합니다.')),
      );
    }
  }

  // 테스트용 댓글 리스트
  final List<CommentModel> testComments = [
    CommentModel(
      uId: "YJpJbJiNdGdXVKdScC8CqVrPIl13",
      userProfileImage: "https://firebasestorage.googleapis.com/v0/b/auctionproject-cea5a.appspot.com/o/userProfileImages%2FdefaultImage%2Fdefault_blue.png?alt=media&token=8781d8c6-2943-4d9b-b3ea-6a70bc1617bc",
      comment: "첫 번째 테스트 댓글",
      commentTime: "2024-09-21 12:00:01",
    ),
    CommentModel(
      uId: "b07EFZ5ZT0Yb5sTWHMbFNyCurw02",
      userProfileImage: "https://firebasestorage.googleapis.com/v0/b/auctionproject-cea5a.appspot.com/o/userProfileImages%2FdefaultImage%2Fdefault_mint.png?alt=media&token=38ec6d81-580a-4e4c-8d97-1ea0fec6e109",
      comment: "두 번째 테스트 댓글",
      commentTime: "2024-09-21 12:05:02",
    ),
    CommentModel(
      uId: "B0zTmmVGvNhS8L37ktocNK4FZfG3",
      userProfileImage: "https://firebasestorage.googleapis.com/v0/b/auctionproject-cea5a.appspot.com/o/userProfileImages%2FdefaultImage%2Fdefault_red.png?alt=media&token=2c618b77-fda3-4a6f-ae00-2aa262beb1be",
      comment: "세 번째 테스트 댓글",
      commentTime: "2024-09-21 12:10:03",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<String> _images = [
      'lib/assets/image/pic1.png',
      'lib/assets/image/pic2.png',
      'lib/assets/image/pic3.jpeg',
    ];
    return Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          return Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              title: Text("게시물", style: TextStyle(fontSize: 20.0),),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                "userId" == "userId"
                    ? IconButton(
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
                        SizedBox(
                          height: 300,
                          child: Swiper(
                            itemBuilder: (BuildContext context, int index) {
                              return Image.asset(
                                _images[index],
                                fit: BoxFit.cover,
                              );
                            },
                            itemCount: _images.length,
                            pagination: const SwiperPagination(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("profile 화면 이동");
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipOval(
                                      child: Image.asset(
                                        "lib/assets/image/defaultUserProfile.png",
                                        width: 45,
                                        height: 45,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Text("UserName"),
                                  ],
                                ),
                              ),
                              Divider(thickness: 1, color: AppsColor.lightGray,),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Nike x Sacai VaporWaffle Dark',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  ),
                                  FavoriteButtonWidget(
                                    isFavorited: isFavorited,
                                    onPressed: _toggleFavorite,
                                  )
                                ],
                              ),
                              SizedBox(height: 15),
                              Text(
                                '조금은 긴 글내용...',
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(height: 30.0,),
                              Divider(height: 1, color: Colors.grey,),
                              SizedBox(height: 30.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '댓글 ${testComments.length}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: testComments.length,
                                itemBuilder: (context, index) {
                                  return CommentWidget(
                                    commentModel: testComments[index],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ChangeNotifierProvider(
                  create: (context) => AuctionTimerProvider(20),
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
                              const TimerTextWidget(time: 30,),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('750,000원',
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              GestureDetector(
                                onTap: () => context.push("/post/bidlist"),
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_drop_up, color: Colors.redAccent,),
                                    Text('90,000원 (+13.6%)',
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
                                    )
                                ),
                              ),
                              const SizedBox(width: 20,),
                              Consumer<AuctionTimerProvider>(
                                builder: (context, auctionTimerProvider, child) {
                                  return ElevatedButton(
                                    onPressed: auctionTimerProvider.remainingTime != 0
                                        ? () {
                                      //pressed
                                    }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: auctionTimerProvider.remainingTime != 0
                                          ? Color(0xFF65AE7E)
                                          : Colors.grey,
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
    );
  }

  void _showCommentBottomSheet(BuildContext context) {
    // 댓글 바텀 시트 구현
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
                  Navigator.of(context).pop();
                  context.push("/post/modify");
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('삭제'),
                onTap: () {
                  Navigator.of(context).pop();
                  _deleteItem(context);
                  context.go("/post/list");
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text('취소'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteItem(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('삭제 기능이 호출되었습니다.')),
    );
  }
}