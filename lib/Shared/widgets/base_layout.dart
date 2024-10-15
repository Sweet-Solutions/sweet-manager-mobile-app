

import 'package:flutter/material.dart';

class BaseLayout extends StatelessWidget{
  
  final Widget child; // The content of the screen

  final String role; // User's role to define sidebar's lit

  BaseLayout({required this.role, required this.child});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Sweet Manager'),
        leading: Icon(Icons.home),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [],
        ),
      ),
      body: child,
    );
  }

  List<Widget> _getSidebarOptions(BuildContext context){
    if(role == 'ROLE_OWNER')
    {
      return [
        ListTile(
          leading: Icon(Icons.dashboard),
          title: Text('Dashboard'),
          onTap: (){
            Navigator.pushNamed(context, '/dashboard');
          },
        ),
        ListTile(
          leading: Icon(Icons.message),
          title: Text('Notifications'),
          onTap: (){
            Navigator.pushNamed(context, '/notifications');
          },
        ),
        ListTile(
          leading: Icon(Icons.subscriptions),
          title: Text('Current Subscription'),
          onTap: (){
            Navigator.pushNamed(context, '/current_subscription');
          },
        ),
        ListTile(
          leading: Icon(Icons.emoji_transportation),
          title: Text('Suppliers Management'),
          onTap: () {
            Navigator.pushNamed(context, '/providers');
          },
        ),
        ListTile(
          leading: Icon(Icons.food_bank),
          title: Text('Supplies Management'),
          onTap: (){
            Navigator.pushNamed(context, '/supplies');
          },
        ),
        ListTile(
          leading: Icon(Icons.room),
          title: Text('Rooms Management'),
          onTap: (){
            Navigator.pushNamed(context, '/rooms');
          },
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Profiles'),
          onTap: (){
            Navigator.pushNamed(context, '/profile');
          },
        ),
      ];
    }
    else if (role == 'ROLE_WORKER')
    {
      return [
        
      ];  
    }
    else // ADMIN ROLE
    {
      return [
        ListTile(
          leading: Icon(Icons.dashboard),
          title: Text('Dashboard'),
          onTap: (){
            Navigator.pushNamed(context, '/dashboard');
          },
        ),
        ListTile(
          leading: Icon(Icons.emoji_transportation),
          title: Text('Suppliers Management'),
          onTap: () {
            Navigator.pushNamed(context, '/providers');
          },
        ),
        ListTile(
          leading: Icon(Icons.food_bank),
          title: Text('Supplies Management'),
          onTap: (){
            Navigator.pushNamed(context, '/supplies');
          },
        ),
        ListTile(
          leading: Icon(Icons.room),
          title: Text('Rooms Management'),
          onTap: (){
            Navigator.pushNamed(context, '/rooms');
          },
        ),
        ListTile(
          leading: Icon(Icons.message),
          title: Text('Messages'),
          onTap: (){
            Navigator.pushNamed(context, '/messages');
          },
        ),
        ListTile(
          leading: Icon(Icons.report),
          title: Text('Reports'),
          onTap: (){
            Navigator.pushNamed(context, '/reports');
          },
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Profiles'),
          onTap: (){
            Navigator.pushNamed(context, '/profile');
          },
        ),
      ];
    }
  }

}