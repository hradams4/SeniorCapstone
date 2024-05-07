import 'package:flutter/material.dart';
import 'package:speedy_snacks/screens/FAQ.dart';
import 'package:speedy_snacks/screens/contacts_screen.dart';
import 'package:speedy_snacks/screens/home_screen.dart';
import 'package:speedy_snacks/screens/inventory_screen.dart';
import 'package:speedy_snacks/screens/orders_screen.dart';
import 'package:speedy_snacks/screens/settings_screen.dart';

import 'inventory_screen.dart';
import 'login_screen.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(),
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(212, 44, 37, 1.000),
            ),
            child: Text(
              'Welcome!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
          ),
          // ListTiles give the side menu options
          ListTile(
            leading: const Icon(Icons.handshake),
            title: const Text('Partners'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Orders'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OrdersScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Inventory'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InventoryScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text('Contact Us'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ContactsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('FAQ'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FAQScreen()));
            },
          ),
          ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserLogin()));
              }),
        ],
      ),
    );
  }
}
