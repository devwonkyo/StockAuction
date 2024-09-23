import 'package:auction/config/color.dart';
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
  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {
        return Scaffold(
          appBar: const DefaultAppbar(title: "물품 리스트", existIcon: false,),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: RefreshIndicator(
                onRefresh: () => postProvider.refreshItems(),
                child: MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 10,
                  itemCount: 9,
                  itemBuilder: (BuildContext context, int index) {
                    return PostItemWidget();
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
