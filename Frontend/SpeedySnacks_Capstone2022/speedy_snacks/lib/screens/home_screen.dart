/**
 * Home page for navigating to subpages with main app functions. This is the
 * landing page after users log in.
 * 
 * Initial widget built from interactive example of 
 * https://docs.flutter.dev/cookbook/navigation/navigation-basics
 * 
 * @author Nicholas Holtman, Batbold Altansukh, Will Sanchez
 * @version November 29, 2022
 */

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:speedy_snacks/screens/inventory_screen.dart';
import 'package:speedy_snacks/screens/menu_screen.dart';
import 'package:speedy_snacks/screens/login_screen.dart';

//Delete this after implementing persistent user sessions.
import 'package:speedy_snacks/models/user_model.dart';
import 'package:speedy_snacks/screens/orders_screen.dart';
import 'package:speedy_snacks/screens/settings_screen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _Home_Screen createState() => _Home_Screen();
}

class _Home_Screen extends State<HomeScreen> {
  late WebSocketChannel channel;
  late StreamController streamController;
  var messageFromServer;
  var first_name;
  String firstName = '';

  @override
  void initState() {
    super.initState();

    channel = WebSocketChannel.connect(
        Uri.parse('ws://asu.speedysnacks.co/ws/userSession/'));

    //Add a stream controller to handle listening to a stream more than once.
    streamController = StreamController.broadcast();
    streamController.addStream(channel.stream);
  }

  @override
  Widget build(BuildContext context) {
    /**
     * Listens to messages sent by the server.
     */
    streamController.stream.listen((channel) {
      var dataJson = json.decode(channel);
      messageFromServer = dataJson['message'];
      /**
       * Grabs first name from server, assigns to variable and refreshes screen
       */
      setState(() {
        firstName = dataJson['name'].toString();
      });

      print('Message from server is : ' + messageFromServer);

      /**
       * Listen for server to return with success for authentication.
       */

      //if authentication is successful.
      if (messageFromServer == 'user found') {
        print('Hello ' + firstName);
      } else {
        print('UH OH Something went wrong.');
      }
    });

    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: Text('Welcome ' + firstName + '!'),
        backgroundColor: Color.fromRGBO(212, 44, 37, 1.000),
      ),
      body: _buildContent(context),
    );
  }
}

Widget _buildContent(BuildContext context) {
  return Scaffold(
      body: Container(
          child: Column(children: [
    Padding(padding: EdgeInsets.only(top: 20.0)),
    Text(
      'Main Menu',
      style: TextStyle(fontSize: 35.0),
    ),
    Padding(padding: EdgeInsets.only(top: 20.0)),
    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Column(children: [
            SizedBox.fromSize(
                size: Size.fromRadius(80),
                child: GestureDetector(
                    child: Image.asset(
                      'assets/images/orders.png',
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrdersScreen()));
                    })),
            Text(
              'View Orders',
              style: TextStyle(fontSize: 25.0),
            ),
          ])),
      ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Column(children: [
            SizedBox.fromSize(
                size: Size.fromRadius(80),
                child: GestureDetector(
                    child: Image.asset(
                      'assets/images/inventory.png',
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InventoryScreen()));
                    })),
            Text(
              'Inventory',
              style: TextStyle(fontSize: 25.0),
            ),
          ])),
      ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Column(children: [
            SizedBox.fromSize(
                size: Size.fromRadius(80),
                child: GestureDetector(
                    child: Image.asset(
                      'assets/images/settings.png',
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsScreen()));
                    })),
            Text(
              'Settings',
              style: TextStyle(fontSize: 25.0),
            ),
          ])),
    ]),
    Padding(padding: EdgeInsets.only(top: 50.0)),
    Text(
      'Delivery Partners',
      style: TextStyle(fontSize: 35.0),
    ),
    Padding(padding: EdgeInsets.only(top: 20.0)),
    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: SizedBox.fromSize(
            size: Size.fromRadius(80),
            child: Image.asset('assets/images/UberEatLogo.png'),
          )),
      ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: SizedBox.fromSize(
            size: Size.fromRadius(80),
            child: Image.asset('assets/images/DoorDashLogo.png'),
          )),
      ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: SizedBox.fromSize(
            size: Size.fromRadius(80),
            child: Image.asset('assets/images/SkipTheDishLogo.png'),
          )),
    ])
  ])));
}
