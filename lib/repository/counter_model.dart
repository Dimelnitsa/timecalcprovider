import 'package:flutter/material.dart';

class CounterModel with ChangeNotifier{
  int _counter = 20;
  int startNumber = 1;

  void decrementCounter (){
    _counter --;
    notifyListeners();
  }

  void incrementCounter(){
    _counter++;
    notifyListeners();
  }

   int get counter => _counter;

  // void setCounter (String? value){
  //   if (value == null){ _counter = 0;}
  //   else{_counter = int.tryParse(value)!;}
  //   notifyListeners();
  // }

  void decrementStartNumber (){
    startNumber --;
    notifyListeners();
  }

  void incrementStartNumber(){
    startNumber++;
    notifyListeners();
  }

}