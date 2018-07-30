import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();


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

  void signOut (){
      FirebaseAuth.instance.signOut();
  }

