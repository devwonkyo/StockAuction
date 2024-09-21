import 'package:flutter/material.dart';

class CommentDetailScreen extends StatefulWidget {
  @override
  _CommentDetailScreenState createState() => _CommentDetailScreenState();
}

class _CommentDetailScreenState extends State<CommentDetailScreen> {
  final List<String> comments = [];
  final TextEditingController _controller = TextEditingController();
  bool _isVisible = false;

  void _toggleCommentBox() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void _addComment() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        comments.add(_controller.text);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("댓글 보기")),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(comments[index]),
              );
            },
          ),
          Positioned(
            bottom: _isVisible ? 0 : -200, // 댓글창 위치 조정
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _isVisible ? 200 : 0, // 댓글창 높이 조정
              color: Colors.grey[200],
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "댓글을 입력하세요",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          _addComment();
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _toggleCommentBox,
                    child: Text(_isVisible ? "닫기" : "댓글 작성"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleCommentBox,
        child: Icon(_isVisible ? Icons.keyboard_arrow_down : Icons.comment),
      ),
    );
  }
}