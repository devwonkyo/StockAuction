import 'package:flutter/material.dart';
import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart'; // 사진 변경을 위해 Image Picker 패키지 사용

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyScreen> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // 이미지를 선택하는 함수
  Future<void> _pickImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery); // 갤러리에서 사진 선택
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile; // 선택된 파일을 저장하고 상태를 업데이트합니다.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MY'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기 기능
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              context.go('/mypage');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage, // 이미지를 누르면 이미지 선택 창이 열립니다.
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile == null
                    ? const AssetImage('lib/images/pic1.png') // 기본 이미지
                    : FileImage(File(_imageFile!.path))
                        as ImageProvider, // 선택된 이미지
                child: _imageFile == null
                    ? const Icon(Icons.camera_alt, size: 40)
                    : null, // 기본 아이콘 (이미지가 없을 때 표시)
              ),
            ),
            const SizedBox(height: 10),
            const Text('ID_EXAMPLE',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Divider(), // 구분선
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('회원 정보 수정'),
              onTap: () {
                context.go('/infoupdate'); // 회원 정보 수정으로 이동
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('계정 설정'),
              onTap: () {
                context.go('/account'); // 계정 설정으로 이동
              },
            ),
            const Divider(), // 두 번째 구분선
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('나의 판매'),
              onTap: () {
                context.go('/sold'); // 나의 판매로 이동
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('나의 구매'),
              onTap: () {
                context.go('/bought'); // 나의 구매로 이동
              },
            ),
          ],
        ),
      ),
    );
  }
}
