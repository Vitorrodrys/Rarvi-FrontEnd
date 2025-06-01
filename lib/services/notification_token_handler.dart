import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';

import 'package:rarvi/services/api/rarvi_api.dart';
import 'package:rarvi/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';



Future<void> initNotificationHandler() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
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
  final logger = Logger("notification handler");
  if (settings.authorizationStatus != AuthorizationStatus.authorized) {
    logger.warning("not authorized to send notification");
    return;
  }
  String? token = await messaging.getToken();
  if (token == null ){
    logger.warning("Failed to get Firebase token. Notifications will not work");
    return;
  }
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    RarviAPI api = RarviAPI();
    api.user.updateNotificationToken(newToken);
  });
  RarviAPI api = RarviAPI();
  api.user.updateNotificationToken(token);
}
