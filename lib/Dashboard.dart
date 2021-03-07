import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


// using realtime database
class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  
  @override
  void initState() {
    super.initState();
    // fetchUserDetails();
  }
  
  @override
  Widget build(BuildContext context) {
    DatabaseReference reference = FirebaseDatabase.instance.reference().child('User');     // need to pass UID via shared ref

    return Scaffold(
      body: FutureBuilder<DataSnapshot>(
         future: reference.child('5jLqRe9aCPfTo2M7avzmiytB7Vf2').once(), // dataSnapshot
        builder:
        (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot){

           if(snapshot.hasError)
             return Text('Something went wrong');

           if(snapshot.connectionState == ConnectionState.done){
             Map<dynamic,dynamic> data = snapshot.data.value;

             return Center(
               child: Text('Name: ${data['a_name']}\n'
                   'Email: ${data['a_email']}'),
             );
           }

           return Text('loading');
        }

      ),
    );
  }

  // to fetch realtime data
  void fetchUserDetails() {
    DatabaseReference reference = FirebaseDatabase.instance.reference().child('User');     // need to pass UID via shared ref

    reference.child('5jLqRe9aCPfTo2M7avzmiytB7Vf2').once() // -> returns value
        .then((value) => print("UserValue ${value.value['a_email']}")) // for email from realtime db

        .catchError((onError)=>print("Error: $onError"));
  }
}
