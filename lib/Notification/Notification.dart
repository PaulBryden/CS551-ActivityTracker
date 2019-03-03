import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationWrapper {
  var flutterLocalNotificationsPlugin;

  NotificationWrapper() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = new AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  showNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails('Channel ID', 'Channel Name', 'Description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics =
        new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, 'Almost There!', 'You are more than half way towards today\'s goal!', platformChannelSpecifics, payload: 'item x');
  }
}
