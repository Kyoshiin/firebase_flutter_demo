import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'LoginScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // server attached to app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // initializer
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  static const KEY = 'phone';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(

      future: _initialization,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // check for errors
        if(snapshot.hasError)
          return Text("ERROR");

        //once complete, connection done
        if(snapshot.connectionState == ConnectionState.done)
          return MaterialApp(
              title: 'Firebase App',
              theme: ThemeData(
                primaryColor: Colors.cyan, //for different clr of purple
              ),
              debugShowCheckedModeBanner: false,
              home: LoginScreen(),
              // initialRoute: '/',
              // routes: {
              //   LoginScreen.SCREEN_NAME: (context) => LoginScreen(),
              // }
          );

        return Center(child: CircularProgressIndicator());
      },

    );
  }
}