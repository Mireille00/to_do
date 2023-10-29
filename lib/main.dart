import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/auth/login/login-screen.dart';
import 'package:to_do/auth/register/register-screen.dart';
import 'package:to_do/providers/auth-provider.dart';
import 'package:to_do/providers/list-provider.dart';

import 'home/home-screen.dart';
import 'my-theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ListProvider()),
      ChangeNotifierProvider(create: (context) => AuthProvider()),
    ],
    child: MyApp(),
  ));
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
      },
      theme: MyTheme.LightTheme,
    );
  }
}
