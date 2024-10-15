import 'package:flutter/material.dart';
import 'package:sweetmanager/Commerce/views/dashboard.dart';
import 'package:sweetmanager/Commerce/views/subscription_plans.dart';
import 'package:sweetmanager/Communication/View/message.dart';
import 'package:sweetmanager/IAM/views/home.dart';
import 'package:sweetmanager/IAM/views/login.dart';
import 'package:sweetmanager/Monitoring/views/tableroom.dart';
import 'package:sweetmanager/Profiles/Views/ownerProfile.dart';
import 'package:sweetmanager/Profiles/Views/providers/management_provider_page.dart';
import 'package:sweetmanager/ResourceManagement/pages/reportlist.dart';
import 'package:sweetmanager/supply-management/views/inventorymanagement.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sweet Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeView(),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeView(), // the default app's entry point 
        '/login': (context) => LogInScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/subscription': (context) => SubscriptionPlansView(),
        '/rooms': (context) => TableRoom(),
        '/providers': (context) => GestionProveedoresPage(),
        // ignore: prefer_const_constructors
        '/supplies': (context) => InventoryManagement() ,
        '/messages': (context) => MensajesApp(),
        // ignore: prefer_const_constructors
        '/reports': (context) => ReportList(),
        '/profiles': (context) => ProfilePage()
      },
    );
  }
}