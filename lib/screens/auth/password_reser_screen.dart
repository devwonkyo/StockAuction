import 'package:auction/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordResetScreen extends StatefulWidget {
  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
        // Show success message
      } catch (e) {
        // Show error message
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('암호찾기')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '가입한 아이디를 입력해주세요.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'email 입력해 주세요',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Email을 입력해주세요' : null,
                      onSaved: (value) => _email = value!,
                    ),
                  ),
                  SizedBox(width: 10), // 텍스트 필드와 버튼 사이에 간격 추가
                  ElevatedButton(
                    onPressed: _resetPassword,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('인증번호', style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.w600)),
                        Text('전송', style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.w600)),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8), // 버튼 크기 조정
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      backgroundColor: Color(0XFFEBCDFC),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'email로 전송된 번호 4자리를 입력해 주세요.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'email 입력해 주세요',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Email을 입력해주세요' : null,
                      onSaved: (value) => _email = value!,
                    ),
                  ),
                  SizedBox(width: 10), // 텍스트 필드와 버튼 사이에 간격 추가
                  ElevatedButton(
                    onPressed: _resetPassword,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '인증번호',
                          style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.w600),
                        ),
                        Text('확인', style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.w600)),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8), // 버튼 크기 조정
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      backgroundColor: Color(0XFFEBCDFC),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '새 비밀번호',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '새 비밀번호',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '새 비밀번호 확인',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '새 비밀번호 확인',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },햣
                child: Text('비밀번호 변경하기', style: TextStyle(fontWeight: FontWeight.w600),),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                    fontSize: 20.0,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  // 버튼 크기 조정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  backgroundColor: Color(0XFFEBCDFC),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
