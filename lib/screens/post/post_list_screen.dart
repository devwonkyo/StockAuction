import 'package:auction/providers/post_provider.dart';
import 'package:auction/route.dart';
import 'package:auction/screens/post/widgets/post_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PostListScreen extends StatefulWidget {
  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RefreshIndicator(
                onRefresh: () => postProvider.refreshItems(),
                child: MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return PostItemWidget();
                  },
                ),
            ),
          )
        );
      }
    );
  }
}
