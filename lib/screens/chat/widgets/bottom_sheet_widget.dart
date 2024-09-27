import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auction/providers/chat_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auction/utils/permissions_util.dart';
import 'package:auction/utils/custom_alert_dialog.dart';

class BottomSheetWidget {
  final ImagePicker _picker = ImagePicker();

  void showBottomSheetMenu({
    required BuildContext parentContext,
    required String chatId,
    required String userId,
    required String otherUserId,
    required String currentUserProfileImage,
    required String username,
  }) {

    showModalBottomSheet(
      context: parentContext,
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
              leading: Icon(Icons.image),
              title: Text('갤러리에서 사진 보내기'),
              onTap: () async {
                Navigator.pop(context);

                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  _showConfirmationDialog(parentContext, image, chatId, userId, otherUserId, currentUserProfileImage, username);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('카메라로 사진 찍고 보내기'),
              onTap: () async {
                Navigator.pop(context);

                bool hasPermission = await PermissionsUtil.requestCameraPermission();
                if (!hasPermission) {
                  showCustomAlertDialog(
                    context: parentContext,
                    title: "권한 필요",
                    message: "이 작업을 위해서는 카메라 접근 권한이 필요합니다.",
                    positiveButtonText: "확인",
                  );
                  return;
                }

                final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  _showConfirmationDialog(parentContext, image, chatId, userId, otherUserId, currentUserProfileImage, username);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(
    BuildContext context,
    XFile image,
    String chatId,
    String userId,
    String otherUserId,
    String currentUserProfileImage,
    String username,
  ) {
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

                // 이미지를 전송하는 함수 호출
                chatProvider.sendImageMessage(
                  chatId,
                  userId,
                  image,
                  username,
                  otherUserId,
                  currentUserProfileImage,
                );
              },
              child: Text('예'),
            ),
          ],
        );
      },
    );
  }
}
