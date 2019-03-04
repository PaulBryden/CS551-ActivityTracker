import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/*Simple Wrapper Class for Deploy The 50% Notification.*/
class MotivationNotification {
  var m_flutterLocalNotificationsPlugin;

  MotivationNotification() {
    m_flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin(); //Initialize notification plugin for iOS and Android
    var initializationSettingsAndroid = new AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    m_flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  showNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails('Channel ID', 'Channel Name', 'Description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics =
        new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await m_flutterLocalNotificationsPlugin
        .show(0, 'Almost There!', 'You are more than half way towards today\'s goal!', platformChannelSpecifics, payload: 'item x');
  }
}
