import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auction/models/user_model.dart';

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

  void setStayLoggedIn(bool value) {
    _stayLoggedIn = value;
    notifyListeners();
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
        userProfileImage: null,
      );

      await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
    } else {
      throw Exception('이메일이 인증되지 않았습니다.');
    }
  }

  Future<void> login() async {
    await _auth.signInWithEmailAndPassword(
      email: _email,
      password: _password,
    );
  }

  Future<void> sendPasswordResetEmail() async {
    await _auth.sendPasswordResetEmail(email: _email);
    setResetEmailSent(true);
  }
}