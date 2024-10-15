import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sweetmanager/ResourceManagement/pages/reportlist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase con la configuración correcta para la web
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBTGEj8JZrWvn62ZtofnaGr-LluqliNXMc",
      authDomain: "sweet-solutions.firebaseapp.com",
      projectId: "sweet-solutions",
      storageBucket: "sweet-solutions.appspot.com",
      messagingSenderId: "180154492305",
      appId: "1:180154492305:web:b156d317f56c1d4f34a630",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ReportList(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Initialized'),
      ),
      body: const Center(
        child: Text('Firebase has been successfully initialized!'),
      ),
    );
  }
}
