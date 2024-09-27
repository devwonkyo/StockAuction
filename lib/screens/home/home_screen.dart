import 'dart:async';
import 'package:auction/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auction/providers/theme_provider.dart';
import 'package:auction/providers/post_provider.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _images = [
    'lib/assets/image/pic1.png',
    'lib/assets/image/pic2.png',
    'lib/assets/image/pic3.png',
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });

    // 포스트 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final postProvider = Provider.of<PostProvider>(context, listen: false);
      postProvider.getAllPostList(); // 모든 포스트 로드
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  _images[index],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(5),
            width: double.infinity,
            child: Text(
              '방금 시작된 경매',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.headlineLarge!.color,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Consumer<PostProvider>(
              builder: (context, postProvider, child) {
                if (postProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (postProvider.hasError) {
                  return Center(child: Text('포스트를 불러오는 데 오류가 발생했습니다.'));
                }

                // 전체 postList에서 최근 10개만 사용
                final recentPosts = postProvider.postList.take(10).toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: recentPosts.map((post) {
                      return Container(
                        width: 160, // 각 아이템의 너비 설정
                        child: auctionItem(theme, post),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget auctionItem(ThemeData theme, PostModel post) {
    // 기기의 세로 길이를 MediaQuery로 얻음
    final screenHeight = MediaQuery.of(context).size.height;

    // 화면 높이에 따라 maxLines 값을 조정
    int calculateMaxLines(double height) {
      if (height > 800) {
        return 3; // 큰 화면일 경우 더 많은 줄 수 허용
      } else if (height > 600) {
        return 2; // 중간 크기 화면
      } else {
        return 1; // 작은 화면일 경우 줄 수를 줄임
      }
    }

    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push('/post/detail', extra: post.postUid);
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        color: theme.cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              post.postImageList.isNotEmpty
                  ? post.postImageList[0]
                  : 'default_image_url',
              fit: BoxFit.cover,
              width: 120,
              height: 100,
            ),
            SizedBox(height: 5),
            Text(
              post.postTitle,
              style: TextStyle(
                fontSize: 18,
                color: theme.textTheme.bodyLarge!.color,
              ),
            ),
            SizedBox(height: 3),
            // 본문 내용 길이를 제한하고 줄바꿈 처리
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 140, // 너비 제한 설정 (줄바꿈이 될 지점)
              ),
              child: Text(
                post.postContent,
                maxLines: calculateMaxLines(screenHeight), // 화면 높이에 따른 줄 수 설정
                overflow: TextOverflow.ellipsis, // 설정된 줄 수 이상일 경우 '...' 처리
                softWrap: true, // 내용이 길면 줄바꿈 처리
                style: TextStyle(
                  color: theme.textTheme.bodyMedium!.color,
                ),
              ),
            ),
            SizedBox(height: 5),
            // 가격 정보는 항상 보여야 함
            Text(
              '${post.priceList.isNotEmpty ? post.priceList.last : '가격 정보 없음'}',
              style: TextStyle(
                fontSize: 16, // 글씨 크기 조정
                fontWeight: FontWeight.bold, // 글씨 두껍게
                color: theme.textTheme.bodyMedium!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
