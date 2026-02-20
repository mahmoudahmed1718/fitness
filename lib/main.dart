import 'package:firebase_core/firebase_core.dart';
import 'package:fitness/core/services/get_it_service.dart';
import 'package:fitness/core/services/shared_prefence_singleton.dart';
import 'package:fitness/features/auth/ui/view/sign_in_view.dart';
import 'package:fitness/features/home/ui/view/home_view.dart';
import 'package:fitness/firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPreferenceSingleton.init();
  setupGetIt();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SignInView());
  }
}
