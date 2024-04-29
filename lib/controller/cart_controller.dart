import 'package:flutter/material.dart';

class Cartcontroller extends ChangeNotifier{
  double subtotal=0;
  void changetotal(double subtotal){
    this.subtotal=subtotal;
    notifyListeners();
  }

}