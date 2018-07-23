import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();



/*
  Future<String> _testSignInAnonymously() async {
    final FirebaseUser user = await _auth.signInAnonymously();
    assert(user != null);
    assert(user.isAnonymous);
    assert(!user.isEmailVerified);
    assert(await user.getIdToken() != null);
    if (Platform.isIOS) {
      assert(user.providerData.isEmpty);
    }
    else if (Platform.isAndroid) {
      assert(user.providerData.length == 1);
      assert(user.providerData[0].uid != null);
      assert(user.providerData[0].displayName = null);
      assert(user.providerData[0].photoUrl == null);
      assert(user.providerData[0].email = null);
    }

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInAnonymously succeeded: $user';
  }
  */

  Future<FirebaseUser> googleSignIn() async{
      GoogleSignInAccount currentUser = _googleSignIn.currentUser;
      print("SIGNED IN");
      if(currentUser == null){
          currentUser = await _googleSignIn.signInSilently();
      }
      if(currentUser == null)
          {
              currentUser = await _googleSignIn.signIn();
          }

      final GoogleSignInAuthentication auth = await currentUser.authentication;

      final FirebaseUser user = await _auth.signInWithGoogle(idToken: auth.idToken, accessToken: auth.accessToken);

      assert(user != null);
      assert(!user.isAnonymous);


      /*assert(idToken != null);
      assert(accessToken != null);
      final Map<dynamic, dynamic> data = await channel.invoke

      print("1");
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      print("2");
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      print("3");
      final FirebaseUser user = await _auth.signInWithGoogle(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);

      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = new FirebaseUser._(data);
      assert(user.uid == currentUser.uid);
    */

      print("signInWithGoogle succeeded: ");
      return user;

  }

