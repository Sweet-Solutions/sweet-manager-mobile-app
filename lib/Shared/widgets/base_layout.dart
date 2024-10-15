

import 'package:flutter/material.dart';

class BaseLayout extends StatelessWidget{
  
  final Widget childScreen; // The content of the screen

  final String role; // User's role to define sidebar's lit

  BaseLayout({required this.role, required this.childScreen});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sweet Manager'),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: _getSidebarOptions(context),
        ),
      ),
      body: childScreen,
    );
  }

  List<Widget> _getSidebarOptions(BuildContext context){
    if(role == '')
    {
      return [
        ListTile(
          leading: const Icon(Icons.not_accessible),
          title: const Text('No current Routes for now'),
          subtitle: const Text('Login First :)'),
          onTap: (){ },
        )
      ];
    }
    if(role == 'ROLE_OWNER')
    {
      return [
        ListTile(
          leading: const Icon(Icons.dashboard),
          title: const Text('Dashboard'),
          onTap: (){
            Navigator.pushNamed(context, '/dashboard');
          },
        ),
        ListTile(
          leading: const Icon(Icons.message),
          title: const Text('Notifications'),
          onTap: (){
            Navigator.pushNamed(context, '/notifications');
          },
        ),
        ListTile(
          leading: const Icon(Icons.subscriptions),
          title: const Text('Current Subscription'),
          onTap: (){
            Navigator.pushNamed(context, '/current_subscription');
          },
        ),
        ListTile(
          leading: const Icon(Icons.emoji_transportation),
          title: const Text('Suppliers Management'),
          onTap: () {
            Navigator.pushNamed(context, '/providers');
          },
        ),
        ListTile(
          leading: const Icon(Icons.food_bank),
          title: const Text('Supplies Management'),
          onTap: (){
            Navigator.pushNamed(context, '/supplies');
          },
        ),
        ListTile(
          leading: const Icon(Icons.room),
          title: const Text('Rooms Management'),
          onTap: (){
            Navigator.pushNamed(context, '/rooms');
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Profiles'),
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
          leading: const Icon(Icons.dashboard),
          title: const Text('Dashboard'),
          onTap: (){
            Navigator.pushNamed(context, '/dashboard');
          },
        ),
        ListTile(
          leading: const Icon(Icons.emoji_transportation),
          title: const Text('Suppliers Management'),
          onTap: () {
            Navigator.pushNamed(context, '/providers');
          },
        ),
        ListTile(
          leading: const Icon(Icons.food_bank),
          title: const Text('Supplies Management'),
          onTap: (){
            Navigator.pushNamed(context, '/supplies');
          },
        ),
        ListTile(
          leading: const Icon(Icons.room),
          title: const Text('Rooms Management'),
          onTap: (){
            Navigator.pushNamed(context, '/rooms');
          },
        ),
        ListTile(
          leading: const Icon(Icons.message),
          title: const Text('Messages'),
          onTap: (){
            Navigator.pushNamed(context, '/messages');
          },
        ),
        ListTile(
          leading: const Icon(Icons.report),
          title: const Text('Reports'),
          onTap: (){
            Navigator.pushNamed(context, '/reports');
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Profiles'),
          onTap: (){
            Navigator.pushNamed(context, '/profile');
          },
        ),
      ];
    }
  }

}