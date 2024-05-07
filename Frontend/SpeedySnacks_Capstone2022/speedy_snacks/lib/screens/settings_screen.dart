/**
 * Settings page is for users to change settings on application
 * 
 * @author Na Lee, Batbold Altansukh
 * @version October 21, 2022
 */
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:speedy_snacks/screens/menu_screen.dart';
import 'package:speedy_snacks/screens/profile_info_screen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'change_password.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _Settings_Screen();
}

class _Settings_Screen extends State<SettingsScreen> {
  late WebSocketChannel channel;
  late StreamController streamController;
  var messageFromServer;

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(
        Uri.parse('ws://asu.speedysnacks.co/ws/settings/'));
    streamController = StreamController.broadcast();
    streamController.addStream(channel.stream);
  }

  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    streamController.stream.listen((channel) {
      var dataJson = json.decode(channel);
      messageFromServer = dataJson['message'];
      print('message from server is : ' + messageFromServer);
    });
    /** 
         * Returns Scaffold layout
        */
    return Scaffold(
      /** 
         * Able to use side menu
        */
      drawer: SideMenu(),
      /** 
         * AppBar is where title of page is located
        */
      appBar: AppBar(
        title: const Text('Settings Page'),
        backgroundColor: const Color.fromRGBO(212, 44, 37, 1.000),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.backspace),
          ),
        ],
      ),
      /** 
         * Body where Seting Page layout is located in Column order
        */
      body: Column(
        children: <Widget>[
          /**
           * Container contains General title
           */
          Container(
            padding: const EdgeInsets.all(30),
            alignment: Alignment.topLeft,
            child: const Text(
              'General',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 108, 109, 109),
              ),
            ),
          ),
          /**
           * Expanded contains containter that holds first Person Icon and Profile Info title
           */
          Expanded(
            child: Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 30),
                  child: const Icon(
                    Icons.person,
                    size: 40.0,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 30),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileInfoScreen()));
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black, // Text Color
                    ),
                    child: const Text(
                      'Profile Info',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          /**
           * Expanded contains containter that holds Fingerprint Icon and Change Password title
           */
          Expanded(
            child: Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 30),
                  child: const Icon(
                    Icons.fingerprint,
                    size: 40.0,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 30),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => changePassword()),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black, // Text Color
                    ),
                    child: const Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          /**
           * Divider for each groups on Setting Page
           */
          const Divider(
            color: Color.fromARGB(255, 59, 58, 58),
          ),
          /**
           * Container contains Notifications title
           */
          Container(
            padding: const EdgeInsets.all(30),
            alignment: Alignment.topLeft,
            child: const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 108, 109, 109),
              ),
            ),
          ),
          /**
           * Expanded contains Bell Icon and Allow Notifications title
           */
          Expanded(
            child: Row(
              children: const <Widget>[
                SizedBox(
                  width: 30,
                ),
                Icon(
                  Icons.notifications,
                  size: 40.0,
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  'Allow Notifications',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 14, 14, 14),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox.shrink(),
                ),
                _MyCheckBoxWidget(),
              ],
            ),
          ),
          /**
           * Expanded contains Bell Icon and title
           */
          Expanded(
            child: Row(
              children: const <Widget>[
                SizedBox(
                  width: 30,
                ),
                Icon(
                  Icons.notifications,
                  size: 40.0,
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  'Push Notifications',
                  style: TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 14, 14, 14)),
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox.shrink(),
                ),
                _MyCheckBoxWidget(),
              ],
            ),
          ),
          /**
           * Expanded contains Bell Icon and SMS Notifications title
           */
          Expanded(
            child: Row(
              children: const <Widget>[
                SizedBox(
                  width: 30,
                ),
                Icon(
                  Icons.notifications,
                  size: 40.0,
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  'SMS Notifications',
                  style: TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 14, 14, 14)),
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox.shrink(),
                ),
                _MyCheckBoxWidget(),
              ],
            ),
          ),
          /**
           * Expanded contains Bell Icon and Email Notifications title
           */
          Expanded(
            child: Row(
              children: const <Widget>[
                SizedBox(
                  width: 30,
                ),
                Icon(
                  Icons.notifications,
                  size: 40.0,
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  'Email Notifications',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 14, 14, 14),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox.shrink(),
                ),
                _MyCheckBoxWidget(),
              ],
            ),
          ),
          /**
           * Divider for each groups on Setting Page
           */
          const Divider(
            color: Color.fromARGB(255, 59, 58, 58),
          ),
          /**
           * Container contains General title
           */
          Container(
            padding: const EdgeInsets.all(30),
            alignment: Alignment.topLeft,
            child: const Text(
              'Language',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 108, 109, 109),
              ),
            ),
          ),
          /**
           * Expanded contains containter that holds  Information Icon and Language title
           */
          Expanded(
            child: Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 30),
                  child: const Icon(
                    Icons.info,
                    size: 40.0,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 30),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black, // Text Color
                    ),
                    child: const Text(
                      'Languages',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/**
 * Building checkbox statefulWidget 
 */
class _MyCheckBoxWidget extends StatefulWidget {
  const _MyCheckBoxWidget();

  @override
  State<_MyCheckBoxWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<_MyCheckBoxWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.white;
      }
      return Colors.black;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}
