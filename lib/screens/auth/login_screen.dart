import 'package:auction/screens/auth/password_reser_screen.dart';
import 'package:auction/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _stayLoggedIn = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        // Navigate to home screen or show success message
      } catch (e) {
        // Show error message
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 200, 20, 0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '환영합니다.',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              SizedBox(
                height: 100,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '아이디를 입력해 주세요.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                validator: (value) => value!.isEmpty ? '아이디를 입력해주세요.' : null,
                onSaved: (value) => _email = value!,
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '비밀번호를 입력해 주세요.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                obscureText: true,
                validator: (value) => value!.isEmpty ? '비밀번호를 입력해주세요.' : null,
                onSaved: (value) => _password = value!,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PasswordResetScreen()),
                      );
                    },
                    child: Text(
                      '암호를 잊어버렸습니다.',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                child: Text(
                  '로그인',
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
                ),
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0XFFEBCDFC),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0), // 둥근 모서리 설정
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _stayLoggedIn = !_stayLoggedIn; // 스위치 상태 변경
                      });
                    },
                    child: Text('로그인 상태 유지'),
                  ),
                  Switch(
                    value: _stayLoggedIn,
                    onChanged: (bool value) {
                      setState(() {
                        _stayLoggedIn = value;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('계정이 없습니다.'),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
