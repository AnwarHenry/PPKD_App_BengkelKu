import 'package:flutter/material.dart';

extension Navigation on BuildContext {
  // Push new screen
  void push(Widget screen) {
    Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Push and replace current screen
  void pushReplacement(Widget screen) {
    Navigator.pushReplacement(
      this,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Push and remove all previous screens
  void pushAndRemoveAll(Widget screen) {
    Navigator.pushAndRemoveUntil(
      this,
      MaterialPageRoute(builder: (context) => screen),
      (route) => false,
    );
  }

  // Pop current screen
  void pop() {
    Navigator.pop(this);
  }

  // Pop with result
  void popWithResult(dynamic result) {
    Navigator.pop(this, result);
  }

  // Push named route
  void pushNamed(String routeName, {Object? arguments}) {
    Navigator.pushNamed(this, routeName, arguments: arguments);
  }

  // Push replacement named route
  void pushReplacementNamed(String routeName, {Object? arguments}) {
    Navigator.pushReplacementNamed(this, routeName, arguments: arguments);
  }

  // Push named and remove until
  void pushNamedAndRemoveUntil(String routeName, {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(
      this,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  // Can pop check
  bool canPop() {
    return Navigator.canPop(this);
  }

  // Get screen size
  Size get screenSize => MediaQuery.of(this).size;

  // Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  // Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;
}
