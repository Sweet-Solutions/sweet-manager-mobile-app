import 'package:flutter/material.dart';
import 'package:sweetmanager/IAM/services/auth_service.dart';

// In the following line you configure or declare that SplashScreen is a Widget.
class SplashScreen extends StatelessWidget{
  SplashScreen({super.key});
  
  final AuthService _authService = AuthService();
  
  // Configure the Authentication Status (isAuthenticated?)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _authService.isAuthenticated(),
        builder: (context, AsyncSnapshot<bool> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
          {
            return const Center(
              child: CircularProgressIndicator()
            );
          }
          else
          {
            WidgetsBinding.instance.addPostFrameCallback((_){
              if(snapshot.hasData && snapshot.data == true)
              {
                Navigator.pushReplacementNamed(context, '/dashboard');
              }
              else
              {
                Navigator.pushReplacementNamed(context, '/home');
              }
            });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        ),
    );
  }

}