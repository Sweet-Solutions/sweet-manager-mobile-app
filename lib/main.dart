import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sweetmanager/Commerce/views/dashboard.dart';
import 'package:sweetmanager/Commerce/views/subscription_plans.dart';
import 'package:sweetmanager/Communication/views/messageScreen.dart';
import 'package:sweetmanager/IAM/views/home.dart';
import 'package:sweetmanager/IAM/views/login.dart';
import 'package:sweetmanager/Monitoring/views/tableroom.dart';
import 'package:sweetmanager/Profiles/Views/ownerProfile.dart';
import 'package:sweetmanager/Profiles/Views/providers/management_provider_page.dart';
import 'package:sweetmanager/ResourceManagement/pages/reportlist.dart';
import 'package:sweetmanager/supply-management/views/inventorymanagement.dart';
import 'package:sweetmanager/Communication/views/writeMessage.dart';
import 'package:sweetmanager/Communication/views/alertScreen.dart';
import 'package:sweetmanager/Communication/views/writeAlert.dart';
import 'package:sweetmanager/Communication/views/notificationScreen.dart';


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

  runApp( const MyHomePage());
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sweet Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeView(),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeView(), // the default app's entry point 
        '/login': (context) => const LogInScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/subscription': (context) => SubscriptionPlansView
        (),
        '/rooms': (context) => TableRoom(),
        '/providers': (context) => GestionProveedoresPage(),
        // ignore: prefer_const_constructors
        '/supplies': (context) => InventoryManagement() ,
        '/messages': (context) => Messagescreen(),
        // ignore: prefer_const_constructors
        '/reports': (context) => ReportList(),
        '/profiles': (context) => ProfilePage(),
        '/writemessage': (context) => WriteMessage(),
        '/alerts': (context) => AlertsScreen(),
        '/writealert': (context) => WriteAlertScreen(),
        '/notifications': (context) => NotificationsScreen(),
        
      },
    );
  }
}
