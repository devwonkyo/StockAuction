import 'package:flutter/material.dart';

class BidItemWidget extends StatelessWidget {
  const BidItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 3,
              child: Text("userId")),
          Expanded(
              flex: 1,
              child: Center(child: Text("999,999"))),
          SizedBox(width: 20,),
          Expanded(
              flex: 1,
              child: Center(child: Text("2024/09/22")))
        ],
      ),
    );
  }
}
