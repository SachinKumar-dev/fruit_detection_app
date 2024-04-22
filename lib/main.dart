import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fruit_detection_app/Controllers/logInController.dart';
import 'package:fruit_detection_app/Controllers/mLController.dart';
import 'package:fruit_detection_app/Controllers/signUpController.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'Controllers/userIdController.dart';
import 'Services/firebaseHelper.dart';
import 'Ui_Helper/colorHelper.dart';
import 'Views/AuthStateChange/authState.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: firebaseOptions);
  Get.put(UserController());
  Get.put(LogInController());
  Get.lazyPut(() => SignUpController());
  Get.put(MLController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() {}),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(color: lightGreen),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: lightGreen),
      ),
      home: AuthChangeState(),
    );
  }
}
