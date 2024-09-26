import 'dart:async';
import 'package:auction/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auction/providers/theme_provider.dart';
import 'package:auction/providers/post_provider.dart';

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
    'lib/assets/image/pic3.jpeg',
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
      postProvider.getAllPostList(); // 포스트 로드
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

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: postProvider.postList.map((post) {
                      return auctionItem(theme, post);
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
    return Container(
      margin: EdgeInsets.only(right: 10),
      color: theme.cardColor,
      width: 150, // 원하는 너비 설정
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 게시물 이미지 표시
          Image.network(
            post.postImageList.isNotEmpty ? post.postImageList[0] : '',
            height: 100, // 이미지 높이 설정
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300], // 이미지 로딩 실패 시 회색 배경 표시
                height: 100,
                child: Center(child: Icon(Icons.error, color: Colors.red)),
              );
            },
          ),
          SizedBox(height: 5), // 이미지와 제목 간격
          Text(
            post.postTitle,
            style: TextStyle(
              fontSize: 18,
              color: theme.textTheme.bodyLarge!.color,
            ),
            overflow: TextOverflow.ellipsis, // 넘칠 경우 ...로 표시
            maxLines: 1, // 최대 줄 수
          ),
          SizedBox(height: 3), // 제목과 내용 간격
          Text(
            post.postContent,
            style: TextStyle(
              color: theme.textTheme.bodyMedium!.color,
            ),
            overflow: TextOverflow.ellipsis, // 넘칠 경우 ...로 표시
            maxLines: 2, // 최대 줄 수
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
