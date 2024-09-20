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
              TextFormField(
                decoration: InputDecoration(labelText: 'email 입력해 주세요'),
                validator: (value) => value!.isEmpty ? 'Email을 입력해주세요' : null,
                onSaved: (value) => _email = value!,
              ),
              ElevatedButton(
                child: Text('인증번호 전송하기'),
                onPressed: _resetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}