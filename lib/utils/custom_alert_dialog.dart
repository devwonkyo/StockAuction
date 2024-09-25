import 'package:auction/route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showCustomAlertDialog({required BuildContext context, required String title, required String message, String? positiveButtonText, Function? onClick}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text(positiveButtonText ?? "확인"),
            onPressed: () {
              if(onClick != null){
                onClick();
              }else{
                context.pop();
              }
            },
          ),
        ],
      );
    },
  );
}