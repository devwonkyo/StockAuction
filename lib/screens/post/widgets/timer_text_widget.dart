import 'dart:async';

import 'package:flutter/material.dart';

class TimerTextWidget extends StatefulWidget {
  final int time;

  const TimerTextWidget({super.key, required this.time});

  @override
  State<TimerTextWidget> createState() => _TimerTextWidgetState();
}

class _TimerTextWidgetState extends State<TimerTextWidget> {
  late Timer _timer;
  late int _remainingTime;
  @override
  void initState() {
    super.initState();
    //todo time받아서 남은시간으로 계산
    _remainingTime = widget.time;
    _startTimer();
  }
  @override
  Widget build(BuildContext context) {
    return Text(
      "남은 시간 : $formattedTime",
      style: TextStyle(fontSize: 16),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--; // 남은 시간 감소
        });
      } else {
        _timer.cancel(); // 시간이 다 되면 타이머 종료
      }
    });
  }
  String get formattedTime {
    final minutes = (_remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds"; // 포맷팅된 시간 반환
  }

  @override
  void dispose() {
    _timer.cancel(); // 위젯이 사라질 때 타이머 정리
    super.dispose();
  }

}
