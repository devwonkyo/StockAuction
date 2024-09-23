import 'package:auction/config/color.dart';
import 'package:auction/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class PostItemWidget extends StatelessWidget {
  const PostItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.push("/post/detail");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network("https://via.placeholder.com/60",
              width: double.infinity,
              fit: BoxFit.cover,),
          ),
          SizedBox(height: 10,),
          Text("Title",style: TextStyle(fontSize: 16,
              fontWeight: FontWeight.bold),),
          SizedBox(height: 10),
          Text("discriptiondiscriptiondiscriptiondiscriptiondiscriptiondiscription",
            style: TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,),
          SizedBox(height: 20,),
          Text("999,999원",style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold),),
          Text("현재 입찰가",style: TextStyle(fontSize: 12,color: AppsColor.lightGray),),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.article_outlined,size: 14,),
              Text("1200",style: TextStyle(fontSize: 14),)
            ],
          )
        ],
      ),
    );
  }
}
