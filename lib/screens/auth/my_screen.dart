import 'package:flutter/material.dart';

class myPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('my Page')),
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
    );
  }
}
