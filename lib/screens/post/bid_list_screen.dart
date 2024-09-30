import 'package:auction/models/post_model.dart';
import 'package:auction/providers/post_provider.dart';
import 'package:auction/screens/post/widgets/bid_item_widget.dart';
import 'package:auction/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/color.dart';

class BidListScreen extends StatefulWidget {
  final String postUid;

  const BidListScreen({Key? key, required this.postUid}) : super(key: key);

  @override
  State<BidListScreen> createState() => _BidListScreenState();
}

class _BidListScreenState extends State<BidListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppbar(title: "시세"),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          final PostModel? post = postProvider.postModel;
          if (post == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // 입찰 목록을 날짜 기준으로 내림차순 정렬
          final sortedBids = List.from(post.bidList)
            ..sort((a, b) => b.bidTime.compareTo(a.bidTime));

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        post.postImageList.isNotEmpty ? post.postImageList[0] : "https://via.placeholder.com/60",
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.postTitle,
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            post.postContent,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Divider(thickness: 1, color: AppsColor.lightGray),
              const Padding(
                padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text("입찰하신 분", style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(
                            flex: 1,
                            child: Center(child: Text("입찰 가격", style: TextStyle(fontWeight: FontWeight.bold)))),
                        SizedBox(width: 20),
                        Expanded(
                            flex: 1,
                            child: Center(child: Text("입찰 일자", style: TextStyle(fontWeight: FontWeight.bold))))
                      ],
                    ),
                    SizedBox(height: 8),
                    Divider(thickness: 2, color: AppsColor.lightGray),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  itemBuilder: (context, index) {
                    final bid = sortedBids[index];
                    return BidItemWidget(
                      bidUserName: bid.bidUser.nickname,
                      bidPrice: bid.bidPrice,
                      bidTime: bid.bidTime,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(thickness: 1, color: AppsColor.lightGray);
                  },
                  itemCount: sortedBids.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}