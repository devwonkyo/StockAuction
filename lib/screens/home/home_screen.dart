import 'dart:async';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    // Timer 설정: 3초마다 페이지 변경
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0; // 마지막 페이지에서 처음으로 돌아감
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            color: Colors.white70,
            width: double.infinity,
            child: Text(
              '방금 시작된 경매',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    auctionItem(),
                    auctionItem(),
                    auctionItem(),
                    auctionItem(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget auctionItem() {
    return Container(
      margin: EdgeInsets.only(right: 10), // 항목 사이 간격
      color: Colors.white70,
      child: Column(
        children: [
          Icon(Icons.book_outlined, size: 100),
          Text(
            '경매도서이름',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Text('경매도서설명어쩌구'),
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