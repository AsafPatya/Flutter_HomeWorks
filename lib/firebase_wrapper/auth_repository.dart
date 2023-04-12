import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

import '../global/resources.dart';

enum Status {Authenticating, Unauthenticated, Uninitialized, Authenticated}

class AuthRepository with ChangeNotifier{
  final FirebaseAuth _auth;
  User? _user;
  Status _status = Status.Uninitialized;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Status get status => _status;

  AuthRepository.instance(): _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
    _user = _auth.currentUser;
    _onAuthStateChanged(_user);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      log('${strLOGGER_IDENTIFIER} trying to sign in with email: ${email} ${strLOGGER_IDENTIFIER}');
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      log('${strLOGGER_IDENTIFIER} sign in succeed with email: ${email} ${strLOGGER_IDENTIFIER}');
      _status = Status.Authenticated;
      notifyListeners();
      return true;
    }
    catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<UserCredential?> signUp(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    }
    catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return null;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    _user = null;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }
}