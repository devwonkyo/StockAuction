import 'dart:io';

import 'package:auction/config/color.dart';
import 'package:auction/providers/post_provider.dart';
import 'package:auction/route.dart';
import 'package:auction/screens/post/widgets/post_Image_item.dart';
import 'package:auction/screens/post/widgets/post_item_widget.dart';
import 'package:auction/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/post_image_provider.dart';

class PostAddScreen extends StatefulWidget {
  const PostAddScreen({super.key});

  @override
  State<PostAddScreen> createState() => _PostAddScreenState();
}

class _PostAddScreenState extends State<PostAddScreen> {
  final _priceController = TextEditingController();
  bool _isPriceFocused = false;

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    return ChangeNotifierProvider(
      create: (context) => PostImageProvider(),
      child: Scaffold(
        appBar: const DefaultAppbar(title: "물품 올리기"),
        body: Consumer<PostImageProvider>(
          builder: (context, postImageProvider, child) {
            return Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      postImageProvider.pickImage();
                                    },
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.camera_alt,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 100,
                                    child: ListView.separated(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: postImageProvider.imageList.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return PostImageItem(
                                            imageUrl:
                                            postImageProvider.imageList[index],
                                            index: index,
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                            SizedBox(
                                              width: 5,
                                            )),
                                  ),
                                ),
                              ],
                            ),
                            const Text('제목',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            const TextField(
                              decoration: InputDecoration(
                                  hintText: '제목',
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1,color: AppsColor.pastelGreen)),),
                            ),
                            const SizedBox(height: 20),
                            const Text('초기 입찰가',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Focus(
                              onFocusChange: (hasFocus) {
                                setState(() {
                                  _isPriceFocused = hasFocus;
                                });
                              },
                              child: TextField(
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '가격을 입력해주세요.',
                                  prefixIcon: Icon(
                                    Icons.attach_money,
                                    color: _isPriceFocused ? AppsColor.pastelGreen : Colors.grey,
                                  ),
                                  enabledBorder: const OutlineInputBorder(),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: AppsColor.pastelGreen,)
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text('자세한 설명',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,)),
                            const SizedBox(height: 5),
                            const TextField(
                              maxLines: 5,
                              decoration: InputDecoration(
                                  hintText:
                                  '올릴 게시글 내용을 작성해 주세요. (판매 금지 물품은 게시가 제한될 수 있어요.)\n\n신뢰할 수 있는 거래를 위해 자세히 적어주세요.\n과학기술정보통신부, 한국 인터넷진흥원과 함께 해요.',
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.0, color: AppsColor.pastelGreen),
                                  )),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: 70,
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                            onPressed: () {
                              postProvider.addPostItem();
                              print('작성 완료');
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppsColor.pastelGreen,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            child: Text(
                              "작성 완료",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ))),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }
}
