import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Landing.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    return user;
  }
  @override
  Widget build(BuildContext context){
  return Scaffold(
    body: Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Center(child:new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("Assets/logo.png",height: 100.0,width: 100.0,),
          new Padding(padding: EdgeInsets.only(top:50.0,left: 20.0,right: 20.0),child:  RaisedButton(
              color: Colors.orangeAccent,
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)) ,
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[
                  new Image.asset("Assets/g.png",height:50.0,width:50.0,),
                  Text(""
                      "Sign in with Amal Jyothi Mail",
                      style: TextStyle(
                          fontSize:15.0,
                          color: Colors.white
                      ))],
              ),
              onPressed: (){
                //action
                //Navigator.push(context, MaterialPageRoute(builder: (context)=>new Landing()));
                _handleSignIn()
                    .then((FirebaseUser user) => print(user))
                    .catchError((e) => print(e));
              }),)
        ],
      )



      ),
    ),
  );
  }
}
