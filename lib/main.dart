import 'dart:io';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:submission1_fundamental/common/navigation.dart';
import 'package:submission1_fundamental/presentation/favorite/favorite_page.dart';
import 'package:submission1_fundamental/presentation/home/restaurants_page.dart';
import 'package:submission1_fundamental/presentation/setting/setting_Page.dart';
import 'package:submission1_fundamental/utils/background_service.dart';
import 'package:submission1_fundamental/utils/notification_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initial Intl for time formating
  initializeDateFormatting();
  Intl.defaultLocale = "id_ID";

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.orangeAccent));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedMenu = 0;
  final NotificationHelper _notificationHelper = NotificationHelper();

  static List<Widget> _bottomMenuWidget = [
    RestaurantsPage(),
    FavoritePage(),
    SettingPage()
  ];

  @override
  void initState() {
    super.initState();
    port.listen((message) {
      print("Backgroudn process is executed");
    });
    _notificationHelper.configureSelectNotificationSubject();
  }

  @override
  void dispose() {
    super.dispose();
    selectNotificationSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Submission Flutter Dicoding',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorKey: navigatorKey,
      home: Scaffold(
        body: _bottomMenuWidget[_selectedMenu],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: "Favorites"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings")
          ],
          currentIndex: _selectedMenu,
          selectedItemColor: Colors.orangeAccent,
          onTap: (position) {
            setState(() {
              _selectedMenu = position;
            });
          },
        ),
      ),
    );
  }
}
