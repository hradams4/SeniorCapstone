/**
 * Orders page is for users to view orders on the application
 * 
 * @author Batbold Altansukh
 * @version November 4, 2022
 */

import 'package:flutter/material.dart';
import 'package:speedy_snacks/screens/menu_screen.dart';
import 'package:speedy_snacks/screens/settings_screen.dart';

class ProfileInfoScreen extends StatelessWidget {
  final name = TextEditingController();
  final telephone = TextEditingController();
  final email = TextEditingController();
  final storeAddress = TextEditingController();

  ProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      /** 
         * Title bar for Profile Info page.
        */
      appBar: AppBar(
        title: const Text('Profile Info'),
        backgroundColor: Color.fromRGBO(212, 44, 37, 1.000),
      ),
      /** 
         * Input boxes in columns for Profile info page.
        */
      body: Column(
        children: <Widget>[
          /**
             *  SubTitle
             */
          Container(
            padding: const EdgeInsets.fromLTRB(0, 30, 240, 0),
            child: const Text(
              'Store Contact Information',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 108, 109, 109),
              ),
            ),
          ),
          /**
             * Input box for Name
             */
          Container(
            width: 500,
            padding: const EdgeInsets.all(30),
            child: TextField(
              controller: name,
              autocorrect: true,
              decoration: const InputDecoration(
                hintText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          /**
             * Input box for Telephone.
             */
          Container(
            width: 500,
            padding: const EdgeInsets.all(30),
            child: TextField(
              controller: telephone,
              autocorrect: true,
              decoration: const InputDecoration(
                hintText: 'Telephone',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          /**
             * Input box for Store Addres.
             */
          Container(
            width: 500,
            padding: const EdgeInsets.all(30),
            child: TextField(
              controller: storeAddress,
              autocorrect: true,
              decoration: const InputDecoration(
                hintText: 'Employee Number',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          /**
             * Input box for Email.
             */
          Container(
            width: 500,
            padding: const EdgeInsets.all(30),
            child: TextField(
              controller: email,
              autocorrect: true,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              /**
           * Cancel button
           */
              Container(
                padding: const EdgeInsets.fromLTRB(300, 30, 30, 0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen()));
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white, // Text Color
                    backgroundColor: Color.fromARGB(255, 93, 96, 97),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              /**
             * Submit button
             */
              Container(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileInfoScreen()));
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white, // Text Color
                    backgroundColor: Color.fromARGB(255, 56, 154, 199),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
