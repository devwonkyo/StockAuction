import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BidItemWidget extends StatelessWidget {
  final String bidUserName;
  final String bidPrice;
  final DateTime bidTime;

  const BidItemWidget({
    Key? key,
    required this.bidUserName,
    required this.bidPrice,
    required this.bidTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(bidUserName, style: const TextStyle(fontSize: 14)),
          ),
          Expanded(
            flex: 1,
            child: Center(child: Text(bidPrice, style: const TextStyle(fontSize: 14))),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                _formatDate(bidTime),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MM/dd HH:mm').format(date);
  }
}