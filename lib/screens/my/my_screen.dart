import 'package:flutter/material.dart';
import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart'; // 권한 요청 패키지

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyScreen> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String _nickname = '';
  String _profileImageUrl = ''; // 프로필 이미지 URL 변수 추가

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _requestPermission();
  }

  // Firestore에서 사용자 데이터를 가져오는 함수
  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자 가져오기

    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          var userData = userDoc.data() as Map<String, dynamic>;
          setState(() {
            _nickname = userData['nickname'] ?? ''; // 닉네임이 없으면 빈 문자열 할당
            _profileImageUrl =
                userData['userProfileImage'] ?? ''; // 이미지 URL이 없으면 빈 문자열
            // gender 필드가 있을 경우에만 가져오기
            if (userData.containsKey('gender')) {
              String gender = userData['gender'];
            } else {
              // gender 필드가 없을 경우 기본값 설정
              String gender = 'Not specified';
            }
          });
        } else {
          print('사용자 문서가 존재하지 않거나 데이터가 없습니다.');
        }
      } catch (e) {
        print('오류 발생: $e');
      }
    } else {
      print('로그인된 사용자가 없습니다.');
    }
  }

  // 파일 접근 권한 요청 함수
  Future<bool> _requestPermission() async {
    var status = await Permission.photos.request(); // 갤러리 접근 권한 요청
    if (status.isGranted) {
      return true; // 권한이 허용되었을 경우
    } else {
      return false; // 권한이 허용되지 않았을 경우
    }
  }

  // 이미지를 선택하는 함수
  Future<void> _pickImage() async {
    bool hasPermission = await _requestPermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사진 접근 권한이 필요합니다.')),
      );
      return;
    }

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
      await _uploadImage(File(pickedFile.path)); // Firebase Storage에 이미지 업로드
    }
  }

  // Firebase Storage에 이미지 업로드 함수
  Future<void> _uploadImage(File image) async {
    User? user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자

    if (user != null) {
      try {
        // Firebase Storage 경로 설정
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('userProfileImages/${user.uid}.jpg');

        // 파일 업로드
        UploadTask uploadTask = storageRef.putFile(image);
        TaskSnapshot snapshot = await uploadTask;

        // 업로드 완료 후 다운로드 URL 가져오기
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Firestore에 이미지 URL 저장
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'userProfileImage': downloadUrl});

        // 상태 업데이트하여 프로필 이미지 표시
        setState(() {
          _profileImageUrl = downloadUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('프로필 이미지가 변경되었습니다.')),
        );
      } catch (e) {
        print('이미지 업로드 중 오류 발생: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미지 업로드에 실패했습니다.')),
        );
      }
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
            if (GoRouter.of(context).canPop()) {
              context.pop();
            } else {
              context.go('/my');
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage, // 이미지 선택 함수 호출
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile == null
                    ? (_profileImageUrl.isEmpty
                        ? const AssetImage('lib/images/pic1.png') // 기본 이미지
                        : NetworkImage(_profileImageUrl)) // 프로필 이미지
                    : FileImage(File(_imageFile!.path)) as ImageProvider,
                child: _imageFile == null && _profileImageUrl.isEmpty
                    ? const Icon(Icons.camera_alt, size: 40)
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _nickname.isNotEmpty ? _nickname : '닉네임을 불러올 수 없습니다.', // 닉네임 표시
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('회원 정보 수정'),
              onTap: () {
                context.go('/infoupdate');
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('계정 설정'),
              onTap: () {
                context.go('/account');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('나의 판매'),
              onTap: () {
                context.go('/sold');
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('나의 구매'),
              onTap: () {
                context.go('/bought');
              },
            ),
          ],
        ),
      ),
    );
  }
}
