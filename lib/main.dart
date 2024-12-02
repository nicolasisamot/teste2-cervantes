import 'package:flutter/material.dart';
import './screens/InitialScreen.dart';
import './screens/AddProductScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: false,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.blue)),
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      initialRoute: "/initial",
      routes: {
        '/initial': (context) => const InitialScreen(),
        '/addproduct': (context) => const AddProductScreen(),
      },
    );
  }
}
