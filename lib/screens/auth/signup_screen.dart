import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:auction/providers/auth_provider.dart';

class SignupScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    void _signup() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        try {
          await authProvider.signupWithEmailVerification();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('인증 이메일을 보냈습니다. 이메일을 확인해주세요.')),
          );
          _showEmailVerificationDialog(context, authProvider);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('회원가입에 실패했습니다: $e')),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: SingleChildScrollView(
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
                onSaved: (value) => authProvider.setEmail(value!),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '닉네임',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                validator: (value) => value!.isEmpty ? '닉네임을 입력해주세요' : null,
                onSaved: (value) => authProvider.setNickname(value!),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      authProvider.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: authProvider.togglePasswordVisibility,
                  ),
                ),
                obscureText: !authProvider.isPasswordVisible,
                validator: (value) => value!.isEmpty ? '비밀번호를 입력해주세요' : null,
                onChanged: authProvider.setPassword,
                onSaved: (value) => authProvider.setPassword(value!),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '비밀번호 확인',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      authProvider.isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: authProvider.toggleConfirmPasswordVisibility,
                  ),
                  errorText: !authProvider.passwordsMatch ? '비밀번호가 일치하지 않습니다' : null,
                ),
                obscureText: !authProvider.isConfirmPasswordVisible,
                validator: (value) => value!.isEmpty ? '비밀번호를 다시 입력해주세요' : null,
                onChanged: authProvider.setConfirmPassword,
                onSaved: (value) => authProvider.setConfirmPassword(value!),
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
                onSaved: (value) => authProvider.setPhoneNumber(value!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signup,
                child: Text('회원가입'),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 150, vertical: 15),
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

  void _showEmailVerificationDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('이메일 인증'),
          content: Text('이메일을 확인하고 인증 링크를 클릭해주세요. 인증이 완료되면 확인 버튼을 눌러주세요.'),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () async {
                bool isVerified = await authProvider.checkEmailVerification();
                if (isVerified) {
                  try {
                    await authProvider.createUserInFirestore();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('회원가입이 완료되었습니다.')),
                    );
                    context.go('/login');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('오류가 발생했습니다: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('이메일이 아직 인증되지 않았습니다. 다시 시도해주세요.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}