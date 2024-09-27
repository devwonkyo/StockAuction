import 'package:auction/models/bid_model.dart';
import 'package:auction/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:auction/config/color.dart';
import 'package:auction/models/comment_model.dart';
import 'package:auction/models/user_model.dart';
import 'package:auction/providers/auction_timer_provider.dart';
import 'package:auction/providers/post_provider.dart';
import 'package:auction/providers/auth_provider.dart';
import 'package:auction/screens/post/widgets/comment_widget.dart';
import 'package:auction/screens/post/widgets/favorite_button_widget.dart';
import 'package:auction/screens/post/widgets/timer_text_widget.dart';
import 'package:auction/utils/SharedPrefsUtil.dart';
import 'package:auction/utils/custom_alert_dialog.dart';
import 'package:auction/providers/text_provider.dart';

class PostDetailScreen extends StatefulWidget {
  final String postUid;

  const PostDetailScreen({Key? key, required this.postUid}) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late TextEditingController _priceTextController;
  UserModel? loginedUser;
  bool isLoading = true;
  bool _isPriceFocused = false;
  final _priceFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _priceTextController = TextEditingController();
    _priceFocusNode.addListener(_onFocusChange);

    _loadData();
  }

  void _onFocusChange() {
    setState(() {
      _isPriceFocused = _priceFocusNode.hasFocus;
    });
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
    if (stringUserData != null) {
      setState(() {
        loginedUser = UserModel.fromMap(stringUserData);
      });
    }
  }

  // Future<void> _loadFavoriteStatus() async {
  //   final postProvider = Provider.of<PostProvider>(context, listen: false);
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   final currentUser = await authProvider.getCurrentUser();
  //   if (currentUser != null) {
  //     bool favorited = await postProvider.isPostFavorited(widget.postUid, currentUser.uid);
  //     setState(() {
  //       isFavorited = favorited;
  //     });
  //   }
  // }

  Future<void> _fetchPostItem(String postUid) async {
    /*final postProvider = Provider.of<PostProvider>(context, listen: false);
    final result = await postProvider.getPostItem(postUid);

    if (!result.isSuccess || postProvider.postModel == null) {
      showCustomAlertDialog(
        context: context,
        title: "알림",
        message: result.message ?? "데이터를 가져오지 못했습니다.",
      );
    }*/
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    postProvider.listenToPost(widget.postUid);

    // showCustomAlertDialog(context: context, title: "알림", message: "경매 데이터를 불러오지 못했습니다.",onClick: () => context.go("/main/post"));
  }

  void _toggleFavorite(PostProvider postProvider, UserModel currentUser) async {
    await postProvider.toggleFavorite(widget.postUid, currentUser);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {
        if (isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (postProvider.postModel == null) {
          return const Scaffold(
            body: Center(child: Text("경매 데이터를 불러오지 못했습니다.")),
          );
        }

        return Scaffold(
          appBar: _buildAppBar(postProvider),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageSwiper(postProvider),
                      _buildPostContent(postProvider),
                      _buildCommentSection(postProvider),
                    ],
                  ),
                ),
              ),
              _buildBottomSection(postProvider),
            ],
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(PostProvider postProvider) {
    return AppBar(
      scrolledUnderElevation: 0,
      title: const Text("게시물", style: TextStyle(fontSize: 20.0)),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        if (loginedUser?.uid == postProvider.postModel?.writeUser.uid)
          IconButton(
            icon: const Icon(Icons.more_vert_outlined),
            onPressed: () => _showOptionsBottomSheet(context),
          ),
      ],
    );
  }

  Widget _buildImageSwiper(PostProvider postProvider) {
    return SizedBox(
      height: 300,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return postProvider.postModel?.postImageList[index] != null
              ? Image.network(
                  postProvider.postModel!.postImageList[index],
                  fit: BoxFit.cover,
                )
              : const Center(
                  child: Text(
                    "사진을 불러오지 못했습니다",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                );
        },
        itemCount: postProvider.postModel?.postImageList.length ?? 0,
        pagination: postProvider.postModel!.postImageList.length >= 2
            ? const SwiperPagination()
            : null,
      ),
    );
  }

  Widget _buildPostContent(PostProvider postProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(postProvider),
          const Divider(thickness: 1, color: AppsColor.lightGray),
          _buildPostTitle(postProvider),
          const SizedBox(height: 15),
          Text(
            postProvider.postModel?.postContent ?? "Unknown Content",
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 30.0),
          const Divider(height: 1, color: Colors.grey),
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }

  Widget _buildUserInfo(PostProvider postProvider) {
    return GestureDetector(
      onTap: () => GoRouter.of(context).push(
        '/other/profile/${postProvider.postModel?.writeUser.uid}',
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipOval(
            child: postProvider.postModel?.writeUser.userProfileImage == "" ||
                    postProvider.postModel?.writeUser.userProfileImage == null
                ? Image.asset(
                    "lib/assets/image/defaultUserProfile.png",
                    width: 45,
                    height: 45,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    postProvider.postModel!.writeUser.userProfileImage!,
                    width: 45,
                    height: 45,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 10),
          Text(postProvider.postModel?.writeUser.nickname ?? "Unknown User"),
        ],
      ),
    );
  }
  //포스트 상세화면 제목 내용
  Widget _buildPostTitle(PostProvider postProvider) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final currentUser = authProvider.currentUserModel;
        final postTitle = postProvider.postModel?.postTitle ?? "Unknown Title";
        final isLiked = postProvider.isPostLiked(widget.postUid);

        return Row(
          children: [
            Expanded(
              child: Text(
                postTitle,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            if (currentUser != null)
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : null,
                ),
                onPressed: () => postProvider.toggleFavorite(widget.postUid, currentUser),
              ),
          ],
        );
      },
    );
  }
  //댓글 창
  Widget _buildCommentSection(PostProvider postProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '댓글 ${postProvider.postModel?.commentList.length}',
                style: const TextStyle(fontSize: 14),
              ),
              GestureDetector(
                onTap: () => _showCommentBottomSheet(context),
                child: const Text(
                  '댓글 쓰기',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        postProvider.postModel!.commentList.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Text(
                    "아직 작성된 댓글이 없어요.\n제일 먼저 댓글을 작성해 보세요.",
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: postProvider.postModel?.commentList.length,
                itemBuilder: (context, index) {
                  return CommentWidget(
                    commentModel: CommentModel(
                      uId: "userId",
                      comment: "comment",
                      commentTime: "time",
                    ),
                  );
                },
              ),
      ],
    );
  }
  //포스트 상세 화면 바텀 바
  Widget _buildBottomSection(PostProvider postProvider) {
    return ChangeNotifierProvider(
      create: (context) => AuctionTimerProvider(postProvider.postAuctionEndTime ?? 0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPriceAndTimer(),
              const SizedBox(height: 16),
              _buildBidInputAndButton(postProvider),
            ],
          ),
        ),
      ),
    );
  }
  //입찰 정보
  Widget _buildPriceAndTimer() {
    return Consumer<PostProvider>(
      builder: (context, postProvider, _) {
        return Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('현재 입찰가', style: TextStyle(fontSize: 16)),
                TimerTextWidget(time: 30),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      postProvider.postModel!.bidList.last.bidPrice,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                postProvider.priceDifferenceAndPercentage != null ?
                Flexible(
                  flex: 1, // 오른쪽 부분에도 1의 가중치 부여
                  child: GestureDetector(
                    onTap: () => context.push("/post/bidlist"),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(Icons.arrow_drop_up,
                              color: Colors.redAccent),
                          Text(
                            postProvider.priceDifferenceAndPercentage ?? "",
                            style: const TextStyle(
                                fontSize: 18, color: Colors.redAccent),
                          ),
                        ],
                      )
                    ),
                  ),
                ) : const SizedBox.shrink()
              ],
            ),
          ],
        );
      },
    );
  }
  //입찰 가격 버튼
  Widget _buildBidInputAndButton(PostProvider postProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: TextField(
            controller: _priceTextController,
            keyboardType: TextInputType.number,
            autofocus: false,
            focusNode: _priceFocusNode,
            onChanged: (value) {
              final formattedValue = formatPrice(value);
              _priceTextController.value = TextEditingValue(
                text: formattedValue,
                selection:
                    TextSelection.collapsed(offset: formattedValue.length),
              );
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '가격을 입력해주세요',
            ),
          ),
        ),
        const SizedBox(width: 20),
        Consumer<AuctionTimerProvider>(
          builder: (context, auctionTimerProvider, child) {
            return ElevatedButton(
              onPressed: auctionTimerProvider.remainingTime != 0
                  ? () {
                bidStart(postProvider);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: auctionTimerProvider.remainingTime != 0
                    ? AppsColor.pastelGreen
                    : Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('입찰하기', style: TextStyle(color: Colors.white)),
            );
          },
        ),
      ],
    );
  }

  void _showCommentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ChangeNotifierProvider(
          create: (context) => TextProvider(),
          child: DraggableScrollableSheet(
            expand: true,
            snapAnimationDuration: const Duration(milliseconds: 400),
            initialChildSize: 0.95,
            minChildSize: 0.95,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return _buildCommentBottomSheetContent(context, scrollController);
            },
          ),
        );
      },
    );
  }

  //댓글 입력 상세 화면
  Widget _buildCommentBottomSheetContent(
      BuildContext context, ScrollController scrollController) {
    final textColorProvider = Provider.of<TextProvider>(context);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return CommentWidget(
                        commentModel: CommentModel(
                          uId: "userId",
                          comment: "comment",
                          commentTime: "time",
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
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
                      contentPadding: const EdgeInsets.only(left: 20),
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
                          print(textColorProvider.commentController.text);
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('수정'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push("/post/modify");
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('삭제'),
                onTap: () {
                  Navigator.of(context).pop();
                  _deleteItem(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('취소'),
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
    // 삭제 로직 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('삭제 기능이 호출되었습니다.')),
    );
    context.go("/post/list");
  }

  //입찰 로직
  void bidStart(PostProvider postProvider) {
    if(_priceTextController.text.isEmpty){
      showCustomAlertDialog(context: context, title: "알림", message: "가격을 입력해주세요.");
      return;
    }else if(parseIntPrice(_priceTextController.text) - parseIntPrice(postProvider.postModel!.bidList.last.bidPrice) <=0 ){
      showCustomAlertDialog(context: context, title: "알림", message: "현재 입찰가보다 높은 금액을 입력해주세요.");
      return;
    }
    showCustomAlertDialog(context: context, title: "알림", message: "입찰 하시겠습니까?",
        positiveButtonText: "예" ,
        onPositiveClick: () async {
          context.pop();
          final bidData = BidModel(bidUser: loginedUser!,
              bidTime: DateTime.now.toString(),
              bidPrice: "${_priceTextController.text}원");

          final result = await postProvider.addBidToPost(postProvider.postModel!.postUid, bidData);


          if(result.isSuccess){
            print("isSuccess");
            setState(() {
              _priceTextController.clear(); // 텍스트 지우기
              _priceFocusNode.unfocus();
            });
            showCustomAlertDialog(context: context, title: "알림", message: result.message ?? "입찰 되었습니다.",positiveButtonText: "확인");

          }else{
            showCustomAlertDialog(context: context, title: "알림", message: result.message ?? "입찰에 실패했습니다.");
          }

        },
        negativeButtonText: "아니요",
        onNegativeClick: null,
    );
  }

  @override
  void dispose() {
    _priceTextController.dispose();
    _priceFocusNode.removeListener(_onFocusChange);
    _priceFocusNode.dispose();
    super.dispose();
  }
}
