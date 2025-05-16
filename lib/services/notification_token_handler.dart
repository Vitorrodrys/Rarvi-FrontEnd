import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<FirebaseApp> initNotificationHandler() async {
  WidgetsFlutterBinding.ensureInitialized();
  return Firebase.initializeApp();
}
void requestToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      return;
    }
    String? token = await messaging.getToken();
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("New Token: $newToken");
      // Update backend with the new token if needed
    });
}
