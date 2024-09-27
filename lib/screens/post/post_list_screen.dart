import 'package:auction/config/color.dart';
import 'package:auction/models/post_model.dart';
import 'package:auction/models/result_model.dart';
import 'package:auction/providers/post_provider.dart';
import 'package:auction/route.dart';
import 'package:auction/screens/post/widgets/post_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PostListScreen extends StatefulWidget {
  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPosts();
    });
  }

  Future<void> _loadPosts() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    postProvider.isLoading = true;
    postProvider.notifyListeners();

    await postProvider.getAllPostList();

    postProvider.isLoading = false;
    postProvider.notifyListeners();
  }

  Future<void> _fetchPosts() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    await postProvider.getAllPostList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {
        if (postProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: null,
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: RefreshIndicator(
                onRefresh: () => postProvider.getAllPostList(),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    mainAxisSpacing: 10, // Vertical spacing
                    crossAxisSpacing: 5, // Horizontal spacing
                    childAspectRatio: 1/2, // Adjust aspect ratio to fit your needs
                  ),
                  itemCount: postProvider.postList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return PostItemWidget(postModel: postProvider.postList[index]);
                  },
                ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              //글쓰기 화면 이동
              context.push("/post/add");
            },
            backgroundColor: AppsColor.pastelGreen,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      }
    );
  }
}
