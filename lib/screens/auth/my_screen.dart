import 'package:flutter/material.dart';

class myScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('my Page')),
      appBar: AppBar(
        title: Text('앱 이름'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => myScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
