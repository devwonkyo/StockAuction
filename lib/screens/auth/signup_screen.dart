import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _nickname = '';
  String _phoneNumber = '';

  // Future<void> _checkNickname() async {
  //   var snapshot = await FirebaseFirestore.instance
  //       .collection('users') // 사용자 정보를 저장하는 컬렉션 이름
  //       .where('nickname', isEqualTo: _nickname)
  //       .get();
  //
  //   return snapshot.docs.isEmpty; // 중복되지 않으면 true 반환
  // }

  // void _signup() async {
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();
  //
  //     // 닉네임 중복 확인
  //     bool isNicknameAvailable = await _checkNickname();
  //     if (!isNicknameAvailable) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('이미 사용 중인 닉네임입니다.')),
  //       );
  //       return; // 닉네임이 중복되면 가입 진행 중단
  //     }
  //
  //     try {
  //       UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         email: _email,
  //         password: _password,
  //       );
  //
  //       // Firestore에 사용자 정보 저장
  //       await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
  //         'nickname': _nickname,
  //         'phoneNumber': _phoneNumber,
  //         // 필요시 다른 정보 추가
  //       });
  //
  //       // 가입 성공 후 화면 전환 또는 메시지 표시
  //       Navigator.pop(context); // 예: 이전 화면으로 돌아가기
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('회원가입에 실패했습니다: $e')),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: '이메일 주소를 입력해주세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                validator: (value) => value!.isEmpty ? '이메일을 입력해주세요' : null,
                onSaved: (value) => _email = value!,
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: '닉네임',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? '닉네임을 입력해주세요' : null,
                    onSaved: (value) => _nickname = value!,
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                obscureText: true,
                validator: (value) => value!.isEmpty ? '비밀번호를 입력해주세요' : null,
                onSaved: (value) => _password = value!,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '비밀번호 확인',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                obscureText: true,
                validator: (value) =>
                value != _password ? '비밀번호가 일치하지 않습니다' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '전화번호',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                validator: (value) => value!.isEmpty ? '전화번호를 입력해주세요' : null,
                onSaved: (value) => _phoneNumber = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('회원가입 하기'),
                onPressed: (){},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
