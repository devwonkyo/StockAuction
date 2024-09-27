import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auction/providers/chat_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auction/utils/permissions_util.dart';
import 'package:auction/utils/custom_alert_dialog.dart';

class BottomSheetWidget {
  final ImagePicker _picker = ImagePicker();

  void showBottomSheetMenu(BuildContext context) {
    final parentContext = context;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.gavel),
              title: Text('구매 확정 버튼'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('사진 보내기'),
              onTap: () async {
                Navigator.pop(context);

                bool hasPermission = await PermissionsUtil.requestGalleryPermission();
                if (!hasPermission) {
                  showCustomAlertDialog(
                    context: context,
                    title: "권한 필요",
                    message: "이 작업을 위해서는 갤러리 접근 권한이 필요합니다.",
                    positiveButtonText: "확인",
                  );
                  return;
                }

                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  _showConfirmationDialog(parentContext, image);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('사진 찍기'),
              onTap: () async {
                Navigator.pop(context);

                bool hasPermission = await PermissionsUtil.requestCameraPermission();
                if (!hasPermission) {
                  showCustomAlertDialog(
                    context: context,
                    title: "권한 필요",
                    message: "이 작업을 위해서는 카메라 접근 권한이 필요합니다.",
                    positiveButtonText: "확인",
                  );
                  return;
                }

                final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  _showConfirmationDialog(parentContext, image);
                }
              },
            ),
          ],
        );
      },
    );
  }

   void _showConfirmationDialog(BuildContext context, XFile image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('사진 보내기'),
          content: Image.file(File(image.path)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('아니오'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                
                // 현재 사용자의 정보 가져오기
                final chatProvider = Provider.of<ChatProvider>(context, listen: false);

                final chatId = chatProvider.currentChatId;
                final userId = chatProvider.currentUserId;
                final username = chatProvider.currentUsername;

                chatProvider.sendImageMessage(chatId, userId, image, username);
              },
              child: Text('예'),
            ),
          ],
        );
      },
    );
  }
}
