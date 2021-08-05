import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModelProvider with ChangeNotifier {
  int currentIndex = 0;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  get getCurrentIndex => currentIndex;

  set setCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
