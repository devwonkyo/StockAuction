import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth import
import 'package:auction/providers/my_provider.dart';

class MyInfoUpdateScreen extends StatefulWidget {
  @override
  _MyInfoUpdateScreenState createState() => _MyInfoUpdateScreenState();
}

class _MyInfoUpdateScreenState extends State<MyInfoUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  String _gender = '남성';
  String _currentDate = '';
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _birthController;

  @override
  void initState() {
    super.initState();
    _currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _birthController = TextEditingController();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _nameController.text = userDoc['nickname'] ?? '닉네임이 없습니다';
          _phoneController.text = userDoc['phoneNumber'] ?? '전화번호가 없습니다';
          _emailController.text = userDoc['email'] ?? '이메일이 없습니다';
          _birthController.text = userDoc['birthDate'] ?? '생년월일이 없습니다';
          _gender = userDoc['gender'] ?? '남성';
        });
      } else {
        print('사용자 문서가 존재하지 않습니다.');
      }
    } else {
      print('로그인된 사용자가 없습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원정보수정'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                '기본정보',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              _buildTextField('이름', _nameController),
              _buildTextField('전화번호', _phoneController),
              _buildTextField('이메일', _emailController),
              _buildTextField('생년월일', _birthController),
              const SizedBox(height: 20),
              const Text(
                '성별',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  Radio<String>(
                    value: '남성',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                  const Text('남성'),
                  Radio<String>(
                    value: '여성',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                  const Text('여성'),
                ],
              ),
              const SizedBox(height: 20),
              _buildInfoTile('본인인증', '$_currentDate 본인인증이 완료되었습니다',
                  readOnly: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedInfo = {
                      'nickname': _nameController.text,
                      'phoneNumber': _phoneController.text,
                      'email': _emailController.text,
                      'birthDate': _birthController.text,
                      'gender': _gender,
                    };
                    context.read<MyProvider>().updateUserInfo(updatedInfo);
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update(updatedInfo)
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('저장되었습니다')),
                      );
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('저장 실패: $error')),
                      );
                    });
                  }
                },
                child: const Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: '입력하세요',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label을 입력하세요';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildInfoTile(String label, String hint, {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (!readOnly && (value == null || value.isEmpty)) {
            return '$label을 입력하세요';
          }
          return null;
        },
      ),
    );
  }
}
