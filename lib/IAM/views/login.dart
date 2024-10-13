import 'package:flutter/material.dart';
import 'package:sweetmanager/IAM/services/auth_service.dart';

class LogInScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LogInScreenState();
}

class LogInScreenState extends State<LogInScreen>{

  final AuthService _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';

  @override
  Widget build(BuildContext context) { // Implements design for login view.
    return const Scaffold(

    );
  }

}