import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  String? _userName;
  String? _userEmail;
  String? _userPhotoURL;
  String? _userId;
  bool _hasCompletedOnboarding = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get user => _user;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userPhotoURL => _userPhotoURL;
  String? get userId => _userId;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    if (googleSignInAccount == null) {
      return;
    }
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final UserCredential authResult = await _auth.signInWithCredential(credential);
    _user = authResult.user;
    _userId = _user!.uid;
    _userName = _user!.displayName;
    _userEmail = _user!.email;
    _userPhotoURL = _user!.photoURL;
    notifyListeners();
  }

  void signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    _user = null;
    _userName = null;
    _userEmail = null;
    _userPhotoURL = null;
    _hasCompletedOnboarding = false;
    notifyListeners();
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void setUserPhotoURL(String? url) {
    _userPhotoURL = url;
    notifyListeners();
  }


  // 온보딩 페이지 했는지
  void setHasCompletedOnboarding(bool value) {
    _hasCompletedOnboarding = value;
    notifyListeners();
  }
}
