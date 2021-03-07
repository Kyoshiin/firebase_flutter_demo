import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_app/ContactList.dart';
import 'package:firebase_flutter_app/Dashboard.dart';
import 'package:firebase_flutter_app/RegScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const SCREEN_NAME = "@route-login";

  //fr FORM
  var _formkey = GlobalKey<
      FormState>(); // key to uniquely identify a widget; also handles the state

  final _sKey = GlobalKey<ScaffoldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  static const mPs = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _sKey,
        backgroundColor: Colors.cyan[200],
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: CircleAvatar(
                      child: Image.network(
                        "https://www.charislms.com/images/slogin.png",
                        // width: 200,
                        // height: 250,
                      ),
                      radius: 60,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _emailController,
                    // onSubmitted: (v){
                    //   name = v;
                    // },
                    // onChanged: (v) {
                    //   print(v);
                    // },
                    decoration: InputDecoration(
                      hintText: 'abc@gmail.com',
                      labelText: 'Enter your email id',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 5,
                          color: Colors.green[900],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // errorText: name.isEmpty?'Please input a name':null,
                      icon: Icon(Icons.person),
                    ),

                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val.isEmpty)
                        return 'Please enter your email';
                      // else if (val.length < 5)
                      //   return 'Number must be of 10 characters atleast';

                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _passwordController,
                    // onSubmitted: (v){
                    //   name = v;
                    // },
                    // onChanged: (v) {
                    //   print(v);
                    // },
                    decoration: InputDecoration(
                      hintText: 'Password',
                      labelText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 5,
                          color: Colors.green[900],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // errorText: name.isEmpty?'Please input a name':null,
                      icon: Icon(Icons.enhanced_encryption),
                    ),

                    keyboardType: TextInputType.text,
                    validator: (val) {
                      if (val.isEmpty)
                        return 'Please enter your password';
                      else if (val.length < 5)
                        return 'Password must be of 5 characters atleast';

                      return null;
                    },
                    obscureText: true,
                  ),
                ),
                FlatButton(
                  onPressed: () => checkSignIn(context),
                  height: 40,
                  minWidth: 200,
                  color: Colors.cyan[800],
                  child: Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(width: 3, color: Colors.cyan),
                  ),
                ),
                FlatButton(
                    onPressed: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (con) => RegScreen())),
                    child: Text("Sign up"))
              ],
            ),
          ),
        ));
  }

  checkSignIn(BuildContext con) async {
    if (_formkey.currentState.validate()) {
      // validator
      String phn = _emailController.text;
      String ps = _passwordController.text;

      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text);

        if(userCredential!=null){

          if(userCredential.user.emailVerified){
            //success

            _sKey.currentState.showSnackBar(SnackBar(
              content: Text('Login successful'),
              backgroundColor: Colors.cyan[800],
              duration: Duration(
                seconds: 3,
              ),
            ));

            print("inSuccess");

            // SharedPreferences sp = await SharedPreferences.getInstance();
            // await sp.setString(FirstApp.KEY, phn.trim());

            //navigate
            // Navigator.of(con).push(MaterialPageRoute(builder: (con) => Dashboard()));

            Navigator.of(con).push(MaterialPageRoute(builder: (con) => ContactList()));

            // Navigator.pushReplacementNamed(con, Dashboard.SCREEN_NAME);

          }
          else {
            showAlertDialog(con, 'Verify your email ID and try again');
          }

        }

      } on FirebaseAuthException catch (e){
        if (e.code == 'user-not-found'){
          showAlertDialog(con, 'No user found for the email');
        }
        else if (e.code == 'wrong-password'){
          showAlertDialog(con, 'Wrong password');
        }

      }
    }
  }



  showAlertDialog(BuildContext con, String msg){
    showDialog(
      context: con,
      builder: (con) => AlertDialog(
        content: Text(msg),
      ),
    );
  }
}
