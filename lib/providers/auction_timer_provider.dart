import 'dart:async';
import 'package:flutter/cupertino.dart';

class AuctionTimerProvider with ChangeNotifier{
  late int remainingTime;
  late Timer _timer;

  AuctionTimerProvider(this.remainingTime){
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
        notifyListeners();
      } else {
        _timer.cancel();
      }
    });
  }

  String get formattedTime {
    final minutes = (remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingTime % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}