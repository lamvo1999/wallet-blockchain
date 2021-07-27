import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:wallet_blockchain/model/user.dart';

class Auth extends ChangeNotifier {

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  var users = Users();

  Auth(){
    getUser();
  }
  

  Future<void> getUser() async{
    User currentUser = await auth.currentUser;
    DocumentSnapshot documentSnapshot = await firestore.collection('user').doc(currentUser.uid).get();
    users = Users(
      uid: currentUser.uid,
      email: documentSnapshot['email'],
      profilePhoto: documentSnapshot['profileImage'],
      privateKey: documentSnapshot['privateKey'],
      username: documentSnapshot['name'],
    );
    return users;
    // Users.fromMap(documentSnapshot.data());
    // print(users.username);
  }

  Future<bool> signIn(String email, String pass) async{
    try{
      notifyListeners();
      await auth.signInWithEmailAndPassword(email: email, password: pass);
      return true;
    }catch(e){
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp(String name, String privateKey, String email, String pass) async {
    try{
      notifyListeners();
      await auth.createUserWithEmailAndPassword(email: email, password: pass).then((result) {
        firestore.collection('user').doc(result.user.uid).set({
          'name': name,
          'privateKey' : privateKey,
          'email' : email,
          'profileImage': ''
        });
      });
      return true;
    }catch(e){
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut()async{
    auth.signOut();
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> uploadImageStorage(File image) async{
    User currentUser = await auth.currentUser;
    Reference reference;
    var downloadUrl;
    String url;
    try{
      reference = await firebaseStorage.ref().child("image");
      UploadTask uploadTask = (await reference.putFile(image)) as UploadTask;
      downloadUrl = await (await uploadTask).ref.getDownloadURL();
      url = downloadUrl.toString();
      print(url);
      print(currentUser.uid);
      // return firestore.collection("user")
      //     .doc(currentUser.uid)
      //     .update({'profileImage' : url})
      //     .then((value) => print("User update"))
      //     .catchError((error) => print("Failed to update :$error"));
      var collection = await firestore.collection('user');
      return await collection.doc(currentUser.uid).update({'profileImage': url}).then((value) => print("update"));
    }catch(e) {
      print(e.toString());
    }
  }


}