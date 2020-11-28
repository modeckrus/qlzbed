import 'dart:async';
import 'dart:io';

import 'package:get_it/get_it.dart';

import 'entities/user.dart';
import 'package:firedart/firedart.dart' as fd;

class UserRepository {
  // final FirebaseAuth _firebaseAuth;
  // final GoogleSignIn _googleSignIn;

  // UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
  //     : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
  //       _googleSignIn = googleSignin ?? GoogleSignIn();

  Future<User> signInWithGoogle() async {
    // try {
    //   final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    //   final GoogleSignInAuthentication googleAuth =
    //       await googleUser.authentication;
    //   final AuthCredential credential = GoogleAuthProvider.getCredential(
    //     accessToken: googleAuth.accessToken,
    //     idToken: googleAuth.idToken,
    //   );
    //   await _firebaseAuth.signInWithCredential(credential);
    //   return _firebaseAuth.currentUser();
    // } catch (e) {
    //   throw PlatformException(code: 'code');
    // }
  }

  Future<void> signInWithCredentials(String email, String password) async {
    // return _firebaseAuth.signInWithEmailAndPassword(
    //   email: email,
    //   password: password,
    // );
    if (Platform.isAndroid || Platform.isIOS) {
    } else {
      final fduser = await fd.FirebaseAuth.instance.signIn(email, password);
      final user = User.fromFd(fduser);
      if (GetIt.I.isRegistered<User>()) {
        GetIt.I.unregister<User>();
      }
      GetIt.I.registerSingleton<User>(user);
    }
  }

  Future<void> signUp({String email, String password}) async {
    // return await _firebaseAuth.createUserWithEmailAndPassword(
    //   email: email,
    //   password: password,
    // );
    if (Platform.isAndroid || Platform.isIOS) {
    } else {
      final fduser = await fd.FirebaseAuth.instance.signUp(email, password);
      final user = User.fromFd(fduser);
      if (GetIt.I.isRegistered<User>()) {
        GetIt.I.unregister<User>();
      }
      GetIt.I.registerSingleton<User>(user);
    }
  }

  Future<void> signOut() async {
    // GetIt.I.unregister<User>();
    // return Future.wait([
    //   _firebaseAuth.signOut(),
    //   _googleSignIn.signOut(),
    // ]);
    if (Platform.isAndroid || Platform.isIOS) {
    } else {
      fd.FirebaseAuth.instance.signOut();
    }
  }

  Future<bool> isSignedIn() async {
    // final currentUser = await _firebaseAuth.currentUser();
    // return currentUser != null;
    if (Platform.isAndroid || Platform.isIOS) {
    } else {
      return fd.FirebaseAuth.instance.isSignedIn;
    }
  }

  Future<User> getUser() async {
    // return (await _firebaseAuth.currentUser());
    return User.fromFd(await fd.FirebaseAuth.instance.getUser());
  }

  Future<User> anonAuth() async {
    // final result = await _firebaseAuth.signInAnonymously();
    // return result.user;
    // final fduser = await fd.FirebaseAuth.instance.signInAnonymously();
    // final user = User.fromFd(fduser);
    // if (GetIt.I.isRegistered<User>()) {
    //   GetIt.I.unregister<User>();
    // }
    // GetIt.I.registerSingleton<User>(user);
  }
}
