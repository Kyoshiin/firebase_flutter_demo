// to add data to cloud firestore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//add image UI, relevant ui for the screen

class AddContact extends StatelessWidget {
  CollectionReference users = FirebaseFirestore.instance.collection('Contacts');

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        body: FlatButton(onPressed: addUser, child: Text('Save')));
  }

  Future<void> addUser(){// for autoId else use .doc for manual id
    return users.add({
      'name': 'Testing nmae',
      'phone': 2347568327456,
      'email': 'akjfd@hotmail.com'
    }).then((value){ print('User Added');
    // Navigator.of(context).pop();
    })
    .catchError((error)=>print('User Added'));


  }
}
