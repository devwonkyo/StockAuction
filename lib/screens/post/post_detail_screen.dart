import 'package:auction/config/color.dart';
import 'package:auction/models/comment_model.dart';
import 'package:auction/models/user_model.dart';
import 'package:auction/providers/auction_timer_provider.dart';
import 'package:auction/providers/post_provider.dart';
import 'package:auction/route.dart';
import 'package:auction/screens/post/bid_list_screen.dart';
import 'package:auction/screens/post/widgets/comment_widget.dart';
import 'package:auction/screens/post/widgets/favorite_button_widget.dart';
import 'package:auction/screens/post/widgets/timer_text_widget.dart';
import 'package:auction/utils/SharedPrefsUtil.dart';
import 'package:auction/utils/custom_alert_dialog.dart';
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
  UserModel? loginedUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _setUserData();
    await _fetchPostItem(widget.postUid);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _setUserData() async {
    final stringUserData = await SharedPrefsUtil.getUserData();
    print("stringUserData : $stringUserData");
    if (stringUserData != null) {
      setState(() {
        loginedUser = UserModel.fromMap(stringUserData);
      });
    }
  }

  Future<void> _fetchPostItem(String postUid) async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final result = await postProvider.getPostItem(postUid);

    if (!result.isSuccess || postProvider.postModel == null) {
      showCustomAlertDialog(
          context: context,
          title: "알림",
          message: result.message ?? "데이터를 가져오지 못했습니다.");
    }
  }

  // 테스트용 댓글 리스트
  final List<CommentModel> testComments = [
    CommentModel(
      uId: "YJpJbJiNdGdXVKdScC8CqVrPIl13",
      userProfileImage:
          "https://firebasestorage.googleapis.com/v0/b/auctionproject-cea5a.appspot.com/o/userProfileImages%2FdefaultImage%2Fdefault_blue.png?alt=media&token=8781d8c6-2943-4d9b-b3ea-6a70bc1617bc",
      comment: "첫 번째 테스트 댓글",
      commentTime: "2024-09-21 12:00:01",
    ),
    CommentModel(
      uId: "b07EFZ5ZT0Yb5sTWHMbFNyCurw02",
      userProfileImage:
          "https://firebasestorage.googleapis.com/v0/b/auctionproject-cea5a.appspot.com/o/userProfileImages%2FdefaultImage%2Fdefault_mint.png?alt=media&token=38ec6d81-580a-4e4c-8d97-1ea0fec6e109",
      comment: "두 번째 테스트 댓글",
      commentTime: "2024-09-21 12:05:02",
    ),
    CommentModel(
      uId: "B0zTmmVGvNhS8L37ktocNK4FZfG3",
      userProfileImage:
          "https://firebasestorage.googleapis.com/v0/b/auctionproject-cea5a.appspot.com/o/userProfileImages%2FdefaultImage%2Fdefault_red.png?alt=media&token=2c618b77-fda3-4a6f-ae00-2aa262beb1be",
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
    return Consumer<PostProvider>(builder: (context, postProvider, child) {
      if (isLoading) {
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: const Text(
            "게시물",
            style: TextStyle(fontSize: 20.0),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back), // 뒤로가기 아이콘
            onPressed: () {
              Navigator.pop(context); // 이전 페이지로 이동
            },
          ),
          actions: [
            loginedUser?.uid ==
                    postProvider.postModel?.writeUser
                        .uid // loginUserId 와 postUserId가 같을때
                ? IconButton(
                    icon: const Icon(Icons.more_vert_outlined),
                    onPressed: () {
                      _showOptionsBottomSheet(
                          context); //todo commnetProvider 연결?
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
                          return postProvider.postModel?.postImageList[index] !=
                                  null
                              ? Image.network(
                                  postProvider.postModel!.postImageList[index],
                                  fit: BoxFit.cover)
                              : const Center(
                                  child: Text(
                                    "사진을 불러오지 못했습니다",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                        },
                        itemCount:
                            postProvider.postModel?.postImageList.length ??
                                0, // 이미지 개수
                        pagination: postProvider.postModel!.postImageList.length >= 2 ? const SwiperPagination() : null
                      ),
                    ),
                    // 제품 정보 부분
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              //profile 화면 이동
                              GoRouter.of(context).push(
                                  '/other/profile/${postProvider.postModel?.writeUser.uid}');
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipOval(
                                    child: postProvider.postModel?.writeUser
                                                    .userProfileImage ==
                                                "" ||
                                            postProvider.postModel?.writeUser
                                                    .userProfileImage ==
                                                null
                                        ? Image.asset(
                                            "lib/assets/image/defaultUserProfile.png",
                                            width: 45,
                                            height: 45,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            postProvider.postModel!.writeUser
                                                .userProfileImage!,
                                            width: 45,
                                            height: 45,
                                            fit: BoxFit.cover,
                                          )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(postProvider
                                        .postModel?.writeUser.nickname ??
                                    "Unknown User"),
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: 1,
                            color: AppsColor.lightGray,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  postProvider.postModel?.postTitle ??
                                      "Unknown Title",
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                              FavoriteButtonWidget(
                                isFavorited: false,
                                padding: 8.0,
                              )
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            postProvider.postModel?.postContent ??
                                "Unknown Content",
                            style: TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          const Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          ////////////////////////////////////////////////////
                          //// 테스트용 코드
                          //Row(
                          //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //  children: [
                          //    Text(
                          //      '댓글 ${testComments.length}', // 댓글 수 표시
                          //      style: TextStyle(fontSize: 14),
                          //    ),
                          //  ],
                          //),
                          //SizedBox(height: 20),
                          //ListView.builder(
                          //  shrinkWrap: true,
                          //  physics: NeverScrollableScrollPhysics(),
                          //  itemCount: testComments.length,
                          //  itemBuilder: (context, index) {
                          //    return CommentWidget(
                          //      commentModel: testComments[index],
                          //    );
                          //  },
                          //),
                          ////////////////////////////////////////////////////
                          // 원본 코드
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '댓글 ${postProvider.postModel?.commentList.length}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showCommentBottomSheet(context);
                                },
                                child: const Text(
                                  '댓글 쓰기',
                                  style: TextStyle(fontSize: 14),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          postProvider.postModel!.commentList.isEmpty ?
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Center(child: Text("아직 작성된 댓글이 없어요.\n제일 먼저 댓글을 작성해 보세요.",textAlign: TextAlign.center,),),
                          )
                          :
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: postProvider.postModel?.commentList.length,
                            itemBuilder: (context, index) {
                              return CommentWidget(
                                  commentModel: CommentModel(
                                      uId: "userId",
                                      comment: "comment",
                                      commentTime: "time"));
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
              create: (context) => AuctionTimerProvider(20),
              //todo 시간 계산해서 넣어주기
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
                          Text(postProvider.postModel!.priceList[0],
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          GestureDetector(
                            onTap: () => context.push("/post/bidlist"),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_drop_up,
                                  color: Colors.redAccent,
                                ),
                                Text('90,000원 (+13.6%)',
                                    //todo provider에서 계산 결과 string으로 변환 후 넣기
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.redAccent)),
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
                                onPressed:
                                    auctionTimerProvider.remainingTime != 0
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
    });
  }

  //Comment Bottom Sheet
  void _showCommentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ChangeNotifierProvider(
          //provier 주입
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
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 10,
                              // number of comments
                              itemBuilder: (context, index) {
                                return CommentWidget(
                                    commentModel: CommentModel(
                                        uId: "userId",
                                        comment: "comment",
                                        commentTime: "time"));
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
                                fillColor: AppsColor.lightGray,
                                contentPadding: EdgeInsets.only(left: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          textColorProvider.isTextEmpty
                              ? const IconButton(
                                  icon: Icon(Icons.send, color: Colors.grey),
                                  onPressed: null,
                                )
                              : IconButton(
                                  icon: const Icon(Icons.send,
                                      color: AppsColor.pastelGreen),
                                  onPressed: () {
                                    // 댓글 작성 로직
                                    print(textColorProvider
                                        .commentController.text);
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
                  context.push("/post/modify"); // 수정 처리
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('삭제'),
                onTap: () {
                  Navigator.of(context).pop(); // 시트 닫기
                  _deleteItem(context); // 삭제 처리
                  context.go("/post/list");
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
