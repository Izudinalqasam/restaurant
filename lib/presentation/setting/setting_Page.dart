import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission1_fundamental/data/local/local_data_source.dart';
import 'package:submission1_fundamental/data/remote/api_service.dart';
import 'package:submission1_fundamental/data/repository.dart';
import 'package:submission1_fundamental/provider/setting_provider.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  SettingProvider _provider = new SettingProvider(
      repository: Repository(
          remoteDataSource: ApiService(), localDataSource: LocalDataSource()));

  @override
  void initState() {
    super.initState();
    _provider.getRestaurantNotificationState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ChangeNotifierProvider<SettingProvider>(
        create: (_) => _provider,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Setting",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100],
                ),
                child: Consumer<SettingProvider>(
                  builder: (context, value, child) {
                    return Builder(
                      builder: (context) {
                        return SwitchListTile(
                          value: value.notificationStatus,
                          title: Text("Restaurant Notification",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          subtitle: Text("Enable Notification"),
                          onChanged: (newValue) {
                            value.setRestaurantNotification(newValue);
                          },
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
