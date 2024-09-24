import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auction/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
  UserModel? _currentUserModel;

  AuthProvider() {
    print("AuthProvider initialized");
    _initializeAuthState();
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
  UserModel? get currentUserModel => _currentUserModel;

  // 초기화 메서드
  Future<void> _initializeAuthState() async {
    print("Initializing auth state");
    await _loadStayLoggedIn();
    await _loadUserFromLocalStorage();
    notifyListeners();
    print("Auth state initialized");
  }

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
    print("Setting stay logged in: $value");
    _stayLoggedIn = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('stayLoggedIn', value);
    notifyListeners();
  }

  Future<void> _loadStayLoggedIn() async {
    print("Loading stay logged in preference");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _stayLoggedIn = prefs.getBool('stayLoggedIn') ?? false;
    print("Stay logged in loaded: $_stayLoggedIn");

    if (!_stayLoggedIn && _auth.currentUser != null) {
      print("User not set to stay logged in, but current user exists. Keeping the session.");
      // 여기서 로그아웃하지 않고, 대신 현재 사용자 정보를 로드합니다.
      await _loadUserFromLocalStorage();
    }
  }

  Future<void> _loadUserFromLocalStorage() async {
    print("Loading user from local storage");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user_data');
    if (userJson != null) {
      print("User data found in local storage");
      Map<String, dynamic> userMap = json.decode(userJson);
      _currentUserModel = UserModel.fromMap(userMap);
      _email = _currentUserModel!.email;
      _nickname = _currentUserModel!.nickname;
      _phoneNumber = _currentUserModel!.phoneNumber;
      print("Loaded user: ${_currentUserModel!.nickname}");
    } else {
      print("No user data found in local storage");
    }
  }

  void setResetEmailSent(bool value) {
    _resetEmailSent = value;
    notifyListeners();
  }

  Future<bool> checkNickname() async {
    print("Checking nickname availability: $_nickname");
    var snapshot = await _firestore
        .collection('users')
        .where('nickname', isEqualTo: _nickname)
        .get();

    return snapshot.docs.isEmpty;
  }

  Future<void> signupWithEmailVerification() async {
    print("Attempting to sign up user");
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
    print("Sign up successful, verification email sent");
  }

  Future<bool> checkEmailVerification() async {
    print("Checking email verification");
    User? user = _auth.currentUser;
    await user?.reload();
    _isEmailVerified = user?.emailVerified ?? false;
    notifyListeners();
    print("Email verified: $_isEmailVerified");
    return _isEmailVerified;
  }

  Future<void> createUserInFirestore() async {
    print("Creating user in Firestore");
    User? user = _auth.currentUser;
    if (user != null && user.emailVerified) {
      UserModel newUser = UserModel(
        uid: user.uid,
        email: _email,
        nickname: _nickname,
        phoneNumber: _phoneNumber,
        pushToken: null,
        userProfileImage: null,
        birthDate: null,
      );

      await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
      await saveUserToLocalStorage(newUser);
      await setStayLoggedIn(true);  // 회원가입 후 stayLoggedIn을 true로 설정
      print("User created in Firestore, saved locally, and stay logged in set to true");
    } else {
      print("Failed to create user: email not verified");
      throw Exception('이메일이 인증되지 않았습니다.');
    }
  }

  Future<void> saveUserToLocalStorage(UserModel user) async {
    print("Saving user to local storage: ${user.nickname}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = json.encode(user.toMap());
    await prefs.setString('user_data', userJson);
    _currentUserModel = user;
    notifyListeners();
    print("User saved to local storage");
  }

  Future<void> login() async {
    print("Attempting login for email: $_email");
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      if (userDoc.exists) {
        UserModel user = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        await saveUserToLocalStorage(user);
        await setStayLoggedIn(true);  // 로그인 시 stayLoggedIn을 true로 설정
        print("Login successful, user saved locally and stay logged in set to true");
      } else {
        print("User document not found in Firestore");
      }

      notifyListeners();
    } catch (e) {
      print("Login failed: $e");
      throw e;
    }
  }

  Future<void> logout() async {
    print("Logging out");
    await _auth.signOut();
    await clearUserFromLocalStorage();
    _currentUserModel = null;
    notifyListeners();
    print("Logout complete");
  }

  Future<void> clearUserFromLocalStorage() async {
    print("Clearing user from local storage");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    print("User cleared from local storage");
  }

  Future<void> sendPasswordResetEmail() async {
    print("Sending password reset email to: $_email");
    await _auth.sendPasswordResetEmail(email: _email);
    setResetEmailSent(true);
    print("Password reset email sent");
  }
}