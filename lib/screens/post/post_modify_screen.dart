import 'package:auction/config/color.dart';
import 'package:auction/providers/post_image_provider.dart';
import 'package:auction/providers/post_provider.dart';
import 'package:auction/screens/post/widgets/post_Image_item.dart';
import 'package:auction/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostModifyScreen extends StatefulWidget {
  const PostModifyScreen({super.key});

  @override
  State<PostModifyScreen> createState() => _PostModifyScreenState();
}

class _PostModifyScreenState extends State<PostModifyScreen> {
  late bool _isPriceFocused;

  @override
  void initState() {
    super.initState();
    _isPriceFocused = false;
    //정보 가져와서 초기화

  }
  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    return ChangeNotifierProvider(
      create: (context) => PostImageProvider(), //이미지 넣기
      child: Scaffold(
        appBar: const DefaultAppbar(title: "물품 수정"),
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
                            TextField(
                              decoration: InputDecoration(
                                  hintText: '초기 입찰가는 변경할 수 없습니다.',
                                  prefixIcon: Icon(
                                    Icons.attach_money,
                                    color:Colors.grey,
                                  ),
                                  enabledBorder: const OutlineInputBorder(),
                                  disabledBorder: const OutlineInputBorder(),
                                  enabled: false,
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
                              "수정 완료",
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

}
