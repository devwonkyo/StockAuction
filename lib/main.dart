import 'package:flutter/material.dart';
import 'package:auction/screens/auth/login_screen.dart';
import 'package:auction/screens/auth/settings_screen.dart';
import 'package:auction/screens/auth/my_screen.dart';
import 'package:auction/screens/chat/chat_list_screen.dart';
import 'package:auction/screens/post/post_list_screen.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0; // 선택된 페이지의 인덱스

  // 각 페이지에 대한 위젯을 리스트로 생성
  final List<Widget> _pages = [
    HomePage(),
    SelllistPage(),
    ChatlistPage(),
    settingsPage(),
  ];

  // 네비게이션 탭을 클릭했을 때의 동작 정의
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // 선택된 인덱스를 업데이트하여 페이지 전환
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('앱 이름'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // 뒤로가기 아이콘
          onPressed: () {
            Navigator.pop(context); // 이전 페이지로 이동
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => myPage()),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex, // 선택된 페이지를 표시
        children: _pages, // 모든 페이지를 스택에 포함
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // 선택된 인덱스
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        onTap: _onItemTapped, // 탭을 눌렀을 때 호출
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_sharp), label: 'Sellbook'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_rounded), label: 'Community'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

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
                    auctionBookItem(),
                    auctionBookItem(),
                    auctionBookItem(),
                    auctionBookItem(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget auctionBookItem() {
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
