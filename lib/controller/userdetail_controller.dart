import 'package:flutter/material.dart';

class Userdetailcontroller extends ChangeNotifier{
  String name='';
  String email='';
  String pass='';
  String mobileno='';
  String add='';

  void changedata({required String name,required String email,required String pass,required String mobileno,required String add}){
    this.name=name;
    this.email=email;
    this.pass=pass;
    this.mobileno=mobileno;
    this.add=add;
    notifyListeners();
  }
}