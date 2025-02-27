import 'package:auction/screens/my/my_screen.dart';
import 'package:auction/screens/post/post_list_screen.dart';
import 'package:flutter/material.dart';
import 'chat/chat_list_screen.dart';
import 'home/home_screen.dart';
import 'like/my_likes_screen.dart';

class MainScreen extends StatefulWidget {
  late int pageIndex;

  MainScreen({super.key, this.pageIndex = 0});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex; // 선택된 페이지의 인덱스

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageIndex;
  }

  // 각 페이지에 대한 위젯을 리스트로 생성
  final List<Widget> _pages = [
    HomeScreen(),
    PostListScreen(),
    ChatListScreen(),
    MyLikesScreen(),
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
        title: Text('Stock Auction'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyScreen()),
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
              icon: Icon(Icons.menu_book_sharp), label: 'Selllist'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_rounded), label: 'Chatlist'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'likelist'),
        ],
      ),
    );
  }
}