import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart';

import '../data/global_data.dart' as global_data;


enum Status {Authenticating, Unauthenticated, Uninitialized, Authenticated}

class AuthRepository with ChangeNotifier{
  final FirebaseAuth _auth;
  User? user;
  Status _status = Status.Uninitialized;
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(bucket: global_data.storageBucketPath);

  Status get status => _status;

  AuthRepository.instance(): _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
    user = _auth.currentUser;
    _onAuthStateChanged(user);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      user = null;
      _status = Status.Unauthenticated;
    } else {
      user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      log('${global_data.loggerIdentifier} trying to sign in with email: ${email} ${global_data.loggerIdentifier}');
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      log('${global_data.loggerIdentifier} sign in succeed with email: ${email} ${global_data.loggerIdentifier}');
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
    log('${global_data.loggerIdentifier} sign out succeed with email: ${user?.email} ${global_data.loggerIdentifier}');
    user = null;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }
}