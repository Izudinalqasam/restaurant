import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

class Navigation {
  static intentWithData(Widget screen) {
    navigatorKey.currentState.push(MaterialPageRoute(builder: (_) => screen));
  }

  static back() => navigatorKey..currentState.pop();
}
