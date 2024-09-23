import 'package:auction/screens/post/widgets/bid_item_widget.dart';
import 'package:flutter/material.dart';

import '../../config/color.dart';

class BidListScreen extends StatefulWidget {
  const BidListScreen({super.key});

  @override
  State<BidListScreen> createState() => _BidListScreenState();
}

class _BidListScreenState extends State<BidListScreen> {
  //todo provider 입히고 데이터 추가
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('시세'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // 뒤로가기 아이콘
          onPressed: () {
            Navigator.pop(context); // 이전 페이지로 이동
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network("https://via.placeholder.com/60", width: 70, height: 70, fit: BoxFit.cover,),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Title", style: TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,),
                      SizedBox(height: 5,),
                      Text("Product discriptioProduct discriptionProduct discriptionProduct discriptionProduct discriptionProduct discriptionProduct discriptionProduct discriptionProduct discriptionProduct discriptionProduct discriptionProduct discriptionProduct discriptionProduct discriptionProduct discriptionn",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,)
                    ],
                  ),
                )
              ],
            ),
          ),
          const Divider(thickness: 1,color: AppsColor.lightGray,),
          const Padding(
            padding: EdgeInsets.fromLTRB(15.0,15.0,15.0,0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 3,
                        child: Text("입찰하신 분",style: TextStyle(fontWeight: FontWeight.bold),)),
                    Expanded(
                        flex: 1,
                        child: Center(child: Text("입찰 가격",style: TextStyle(fontWeight: FontWeight.bold),))),
                    SizedBox(width: 20,),
                    Expanded(
                        flex: 1,
                        child: Center(child: Text("입찰 일자",style: TextStyle(fontWeight: FontWeight.bold),)))
                  ],
                ),
                SizedBox(height: 8,),

                Divider(thickness: 2, color: AppsColor.lightGray,),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                itemBuilder: (context, index){
                  return const BidItemWidget();
                },
                separatorBuilder:(context, index){
                  return const Divider(thickness: 1, color: AppsColor.lightGray);
                },
                itemCount: 20),
          ),
        ],
      ),
    );
  }
}
