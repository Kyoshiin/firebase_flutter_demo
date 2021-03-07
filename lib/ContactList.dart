import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_flutter_app/AddContactDetails.dart';
import 'package:firebase_flutter_app/ContactDetails.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

//using cloud firestore
//TODO: implement the abv link & shared pref & add and fetch data

class ContactList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Contacts');

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text('Add'),
        onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (con) => AddContact()))
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return new ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) { // for each loop
              return new ListTile(
                leading: CircleAvatar(
                  child: putImage(document.data()['pic']),
                ),
                title: new Text(document.data()['name']),
                subtitle: new Text(document.data()['phone'].toString()),
                onTap: ()=>{
                  Navigator.of(context).push(MaterialPageRoute(builder: (con) => ContactDetails(document.data())))

                }//show contact details,
              );
            }).toList(),
          );
        },
      ),
    );
  }

  putImage(var pic) {
    return pic!=null? Image.network(pic) : Icon(Icons.person);
  }
}
