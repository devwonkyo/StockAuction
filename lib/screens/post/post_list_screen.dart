import 'package:auction/config/color.dart';
import 'package:auction/models/post_model.dart';
import 'package:auction/models/result_model.dart';
import 'package:auction/providers/post_provider.dart';
import 'package:auction/route.dart';
import 'package:auction/screens/post/widgets/post_item_widget.dart';
import 'package:auction/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PostListScreen extends StatefulWidget {
  @override
  State<PostListScreen> createState() => _PostListScreenState();
}


class _PostListScreenState extends State<PostListScreen> {
  late final result;
  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    result = await postProvider.getAllPostList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {
        return Scaffold(
          appBar: null,
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: RefreshIndicator(
                onRefresh: () => postProvider.getAllPostList(),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    mainAxisSpacing: 20, // Vertical spacing
                    crossAxisSpacing: 10, // Horizontal spacing
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
