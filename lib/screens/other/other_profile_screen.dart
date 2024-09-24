import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auction/providers/auth_provider.dart';
import 'package:auction/providers/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OtherProfileScreen extends StatefulWidget {
  final String userId;

  const OtherProfileScreen({super.key, required this.userId});

  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).fetchUser(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final isCurrentUser = authProvider.currentUser?.uid == widget.userId;

    return Scaffold(
      body: Center(
        child: userProvider.user == null
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 해당 유저의 프로필 이미지 표시
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: userProvider.user!.userProfileImage != null && userProvider.user!.userProfileImage!.isNotEmpty
                        ? CachedNetworkImageProvider(userProvider.user!.userProfileImage!)
                        : AssetImage("lib/assets/image/defaultUserProfile.png") as ImageProvider,
                  ),
                  SizedBox(height: 16),
                  // 해당 유저 닉네임 표시
                  Text(
                    userProvider.user!.nickname,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  // 해당 유저 아이디 표시
                  Text(
                    'ID: ${userProvider.user!.uid}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  // 본인이 아닌 다른 사람 프로필 눌렀을때만 뜨는 아이콘 버튼 ↓↓↓
                  if (!isCurrentUser)
                    IconButton(
                      icon: Icon(Icons.chat),
                      iconSize: 30.0,
                      color: Colors.blue,
                      onPressed: () {
                        // 채팅 화면으로 이동
                        GoRouter.of(context).push('/chat/${widget.userId}');
                      },
                    ),
                ],
              ),
      ),
    );
  }
}