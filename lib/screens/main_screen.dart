import 'package:auction/screens/my/my_screen.dart';
import 'package:auction/screens/post/post_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat/chat_list_screen.dart';
import 'home/home_screen.dart';
import 'like/my_likes_screen.dart';
import 'package:auction/providers/theme_provider.dart';

class MainScreen extends StatefulWidget {
  late int pageIndex;

  MainScreen({super.key, this.pageIndex = 0});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageIndex;
  }

  final List<Widget> _pages = [
    HomeScreen(),
    PostListScreen(),
    ChatListScreen(),
    MyLikesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          'Stock Auction',
          style: TextStyle(
            color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
          ), // 다크모드에 맞춰 텍스트 색상 전환
        ),
        backgroundColor:
            themeProvider.isDarkTheme ? Colors.black : Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person,
                color: themeProvider.isDarkTheme ? Colors.white : Colors.black),
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
        index: _selectedIndex,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0), // 첫 번째 페이지에만 padding 적용
            child: _pages[0],
          ),
          ..._pages.sublist(1), // 첫 번째 페이지 제외한 나머지 페이지들
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor:
            themeProvider.isDarkTheme ? Colors.amber : Colors.red,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor:
            themeProvider.isDarkTheme ? Colors.black : Colors.white,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.gavel), label: '경매'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_rounded), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '찜 목록'),
        ],
      ),
    );
  }
}
