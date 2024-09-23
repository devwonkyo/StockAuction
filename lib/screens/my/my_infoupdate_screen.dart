import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위해 intl 패키지 사용

class MyInfoUpdateScreen extends StatefulWidget {
  @override
  _MyInfoUpdateScreenState createState() => _MyInfoUpdateScreenState();
}

class _MyInfoUpdateScreenState extends State<MyInfoUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  String _gender = '남성'; // 초기 성별 설정
  String _currentDate =
      DateFormat('yyyy-MM-dd').format(DateTime.now()); // 현재 날짜 가져오기

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원정보수정'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 설정 버튼 액션 추가 가능
            },
          ),
        ],
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
              _buildInfoTile('아이디', 'ID_EXAMPLE', readOnly: true),
              _buildInfoTile('이름', '이름을 입력하세요'),
              _buildInfoTile('전화번호', '전화번호를 입력하세요'),
              _buildInfoTile('이메일', '이메일을 입력하세요'),
              _buildInfoTile('생년월일', 'YYYY-MM-DD 형식으로 입력하세요'),

              // 성별 라디오 버튼
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

              // 본인 인증
              const SizedBox(height: 20),
              _buildInfoTile('본인인증', '$_currentDate 본인인증이 완료되었습니다',
                  readOnly: true),

              const SizedBox(height: 20),
              // 저장 버튼
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // 폼이 유효할 경우 저장 처리
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('저장되었습니다')),
                    );
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

  // 기본 정보 입력 필드 빌드 메소드
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
