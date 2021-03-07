import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_flutter_app/LoginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegScreen extends StatelessWidget {
  //fr FORM
  var _formkey = GlobalKey<
      FormState>(); // key to uniquely identify a widget; also handles the state
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.cyan[200],
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Center(
                  child: Image.network(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRd6Q3SqfLv8P9Gt5kk2X514XNjsDwatdnAyA&usqp=CAU",
                    width: 200,
                    height: 250,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Mr. Sam Witney',
                      labelText: 'Enter your full name',
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
                    keyboardType: TextInputType.text,
                    validator: (val) {
                      if (val.isEmpty)
                        return 'Please enter your name';
                      else if (val.length < 10)
                        return 'Please State your full name';

                      return null;
                    },
                  ),
                ),

                //phn no
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'abc@gmail.com',
                      labelText: 'Enter your Email',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 5,
                          color: Colors.green[900],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // errorText: name.isEmpty?'Please input a name':null,
                      icon: Icon(Icons.mail),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val.isEmpty) return 'Please enter your no';
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
                    'Sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(width: 3, color: Colors.cyan),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  checkSignIn(BuildContext context) async {
    if (!_formkey.currentState.validate()) // validator
      print('${_emailController.text}, ${_passwordController.text}');
    else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance // instance of firebase auth services
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);

        if(userCredential!=null){
          await userCredential.user.sendEmailVerification();
          DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('User');

          dbRef.child(userCredential.user.uid)
          .set({'a_email':_emailController.text,'a_name':_nameController.text})
          .then((_){
            showAlertDialog(context, 'Registered Successfully');
            Navigator.of(context).push(MaterialPageRoute(builder: (con) => LoginScreen()));

          })
          .catchError((onError)=>print("Error: $onError"));
        }

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password')
          showAlertDialog(context, 'The password provided is too weak.');
        else if (e.code == 'email-already-in-use')
          showAlertDialog(context, 'The account already exits for the email');
      } catch (e) {
        showAlertDialog(context, e.toString());
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
