// main.dart
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';



// dependencias internas do sistema
import '../core/routes.dart';
import 'firebase_options.dart';

final g = GetIt.instance;

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  // Registro dos controladores


  //Executar o aplicativo
  runApp(
    DevicePreview(
      builder: (context) => MyApp(),
    ), 
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Codificador Secreto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // ligthTheme: lightTheme,
      // darkTheme: darkTheme,
      // themeMode: ThemeMode.system,
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/login' : '/dashboard',
      routes: AppRoutes.routes,
    );
  }
}
