//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:finalpro/object_detector.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jaafod - SignIn',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),

      // home: new WallScreen(analytics: analytics, observer: observer),
      home: new MyHomePage('Jaafod - SignIn'),
    );
  }
}

class MyHomePage extends StatelessWidget{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  GoogleSignInAccount googleSignInAccount;
  GoogleSignInAuthentication gSA;
  AuthCredential credential;
  FirebaseUser user;
  String title;
  MyHomePage(this.title);


  void _signIn(context) async {
    googleSignInAccount = await googleSignIn.signIn();
    gSA = await googleSignInAccount.authentication;
    credential = GoogleAuthProvider.getCredential(
      accessToken: gSA.accessToken,
      idToken: gSA.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    user = authResult.user;

    navigateToObjectDetection(context);
  }
  Future<FirebaseUser> navigateToObjectDetection(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ObjectDetector(user)));
  }

  void _signOut() {
    googleSignIn.signOut();
    print("User Signed out");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text(title),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new RaisedButton(
              //onPressed: () => _signIn().then((FirebaseUser user) => print(user)).catchError((e) => print(e)),
              onPressed: () => _signIn(context),
              child: new Text("Sign In"),
              color: Colors.green,
            ),
            new Padding(
              padding: const EdgeInsets.all(10.0),
            ),
            new RaisedButton(
              onPressed: _signOut,
              child: new Text("Sign out"),
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
