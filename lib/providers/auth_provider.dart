import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auction/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _nickname = '';
  String _phoneNumber = '';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _passwordsMatch = true;
  bool _stayLoggedIn = false;
  bool _resetEmailSent = false;
  bool _isEmailVerified = false;

  AuthProvider() {
    _loadStayLoggedIn();
  }

  // Getters
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  String get nickname => _nickname;
  String get phoneNumber => _phoneNumber;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  bool get passwordsMatch => _passwordsMatch;
  bool get stayLoggedIn => _stayLoggedIn;
  bool get resetEmailSent => _resetEmailSent;
  bool get isEmailVerified => _isEmailVerified;
  User? get currentUser => _auth.currentUser;

  // Setters
  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    checkPasswordsMatch();
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    checkPasswordsMatch();
    notifyListeners();
  }

  void setNickname(String value) {
    _nickname = value;
    notifyListeners();
  }

  void setPhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  void checkPasswordsMatch() {
    _passwordsMatch = _password == _confirmPassword;
    notifyListeners();
  }

  Future<void> setStayLoggedIn(bool value) async {
    _stayLoggedIn = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('stayLoggedIn', value);
    notifyListeners();
  }

  Future<void> _loadStayLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _stayLoggedIn = prefs.getBool('stayLoggedIn') ?? false;
    notifyListeners();

    // 자동 로그인을 원하지 않으면 로그아웃
    if (!_stayLoggedIn && _auth.currentUser != null) {
      await logout();
    }
  }

  void setResetEmailSent(bool value) {
    _resetEmailSent = value;
    notifyListeners();
  }

  Future<bool> checkNickname() async {
    var snapshot = await _firestore
        .collection('users')
        .where('nickname', isEqualTo: _nickname)
        .get();

    return snapshot.docs.isEmpty;
  }

  Future<void> signupWithEmailVerification() async {
    if (_password != _confirmPassword) {
      throw Exception('비밀번호가 일치하지 않습니다.');
    }

    if (_password.length < 6) {
      throw Exception('비밀번호는 최소 6자리 이상이어야 합니다.');
    }

    bool isNicknameAvailable = await checkNickname();
    if (!isNicknameAvailable) {
      throw Exception('이미 사용 중인 닉네임입니다.');
    }

    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: _email,
      password: _password,
    );

    await userCredential.user!.sendEmailVerification();
    _isEmailVerified = false;
    notifyListeners();
  }

  Future<bool> checkEmailVerification() async {
    User? user = _auth.currentUser;
    await user?.reload();
    _isEmailVerified = user?.emailVerified ?? false;
    notifyListeners();
    return _isEmailVerified;
  }

  Future<void> createUserInFirestore() async {
    User? user = _auth.currentUser;
    if (user != null && user.emailVerified) {
      UserModel newUser = UserModel(
        uid: user.uid,
        email: _email,
        nickname: _nickname,
        phoneNumber: _phoneNumber,
        pushToken: null,
        userProfileImage: "https://via.placeholder.com/150",
        birthDate: null, // 기본값으로 null 설정
      );

      await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
    } else {
      throw Exception('이메일이 인증되지 않았습니다.');
    }
  }

  Future<void> login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<void> sendPasswordResetEmail() async {
    await _auth.sendPasswordResetEmail(email: _email);
    setResetEmailSent(true);
  }
}