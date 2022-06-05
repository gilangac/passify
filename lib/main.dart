// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, unused_import, must_be_immutable
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:passify/routes/pages.dart';
import 'package:passify/services/service_notification.dart';
import 'package:passify/services/service_preference.dart';
import 'package:passify/themes/light_theme.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('id', null);
  await PreferenceService.init();
  await Firebase.initializeApp();
  await NotificationService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Passify',
      theme: lightTheme(context),
      initialRoute: PreferenceService.getStatus() != "logged"
          ? AppRoutes.INITIAL
          : AppPages.NAVIGATOR,
      getPages: AppRoutes.pages,
      defaultTransition: Transition.cupertino,
    );
  }
}
