/**
 * FAQ page for users to get help navigating the app and its features
 * 
 * 
 * @author Hillary Adams
 * @version October 21, 2022
 */

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:speedy_snacks/screens/menu_screen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:speedy_snacks/screens/contacts_screen.dart';
import 'package:speedy_snacks/screens/settings_screen.dart';
import 'package:speedy_snacks/screens/orders_screen.dart';
import 'package:speedy_snacks/screens/inventory_screen.dart';
import 'change_password.dart';
import 'package:flutter/gestures.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  _FAQ createState() => _FAQ();
}

class _FAQ extends State<FAQScreen> {
  late WebSocketChannel channel;
  late StreamController streamController;
  var messageFromServer;
  final GlobalKey<ExpansionTileCardState> card1 = GlobalKey();
  final GlobalKey<ExpansionTileCardState> card2 = GlobalKey();
  final GlobalKey<ExpansionTileCardState> card3 = GlobalKey();
  final GlobalKey<ExpansionTileCardState> card4 = GlobalKey();
  final GlobalKey<ExpansionTileCardState> card5 = GlobalKey();
  final GlobalKey<ExpansionTileCardState> card6 = GlobalKey();
  final GlobalKey<ExpansionTileCardState> card7 = GlobalKey();

  void initState() {
    super.initState();
    channel =
        WebSocketChannel.connect(Uri.parse('ws://asu.speedysnacks.co/ws/faq/'));
    streamController = StreamController.broadcast();
    streamController.addStream(channel.stream);
  }

  @override
  Widget build(BuildContext context) {
    streamController.stream.listen((channel) {
      var dataJson = json.decode(channel);
      messageFromServer = dataJson['message'];

      print('Message from server is : ' + messageFromServer);
    });
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );

    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: const Text('FAQs'),
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
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ExpansionTileCard(
              key: card1,
              expandedTextColor: Colors.red,
              leading: Container(
                child: const FittedBox(
                  fit: BoxFit.contain,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/SS_Mascot.png'),
                    backgroundColor: Colors.red,
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
              ),
              title: const Text('What is Speedy Snacks?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              subtitle: const Text(''),
              children: <Widget>[
                const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      "Speedy Snacks is your favourite snacks delivered in under 30 minutes! \nWe partner with delivery companies like Uber Eats, Skip the Dishes, and Door Dash who each have their own apps. Having multiple apps and tablets is a deal breaker for our partner stores and using a single delivery partner results in missed sales opportunities. \n\nBy developing our own app designed specifically for our convenience store partners we have removed confusion, improved our partners reports and inventory control, and have the ability to allow you to efficiently utilize multiple delivery partners.",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 16),
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  buttonHeight: 52.0,
                  buttonMinWidth: 90.0,
                  children: <Widget>[
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        card1.currentState?.collapse();
                      },
                      child: Column(
                        children: const <Widget>[
                          Icon(Icons.arrow_upward),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('Close'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ExpansionTileCard(
              key: card2,
              expandedTextColor: Colors.red,
              leading: Container(
                child: const FittedBox(
                  fit: BoxFit.contain,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/SS_Mascot.png'),
                    backgroundColor: Colors.red,
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
              ),
              title: const Text('How can I turn on/off incoming orders?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              subtitle: const Text(''),
              children: <Widget>[
                const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text:
                                'You can find the option to turn on/off incoming orders in the ',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: 'Settings page here, ',
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SettingsScreen()));
                              },
                          ),
                          const TextSpan(
                            text: 'or located on the top left drop down menu.',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  buttonHeight: 52.0,
                  buttonMinWidth: 90.0,
                  children: <Widget>[
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        card2.currentState?.collapse();
                      },
                      child: Column(
                        children: const <Widget>[
                          Icon(Icons.arrow_upward),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('Close'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ExpansionTileCard(
              key: card3,
              expandedTextColor: Colors.red,
              leading: Container(
                child: const FittedBox(
                  fit: BoxFit.contain,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/SS_Mascot.png'),
                    backgroundColor: Colors.red,
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
              ),
              title: const Text('How can I change my password?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              subtitle: const Text(''),
              children: <Widget>[
                const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'You can find the ',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: 'Change Password page here',
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const changePassword()));
                              },
                          ),
                          const TextSpan(
                            text:
                                ', or in the Settings page from the left top dropdown menu. Change Password page will walk you through the steps of the process.',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  buttonHeight: 52.0,
                  buttonMinWidth: 90.0,
                  children: <Widget>[
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        card3.currentState?.collapse();
                      },
                      child: Column(
                        children: const <Widget>[
                          Icon(Icons.arrow_upward),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('Close'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ExpansionTileCard(
              key: card4,
              expandedTextColor: Colors.red,
              leading: Container(
                child: const FittedBox(
                  fit: BoxFit.contain,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/SS_Mascot.png'),
                    backgroundColor: Colors.red,
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
              ),
              title: const Text('How can I adjust my notifications settings?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              subtitle: const Text(''),
              children: <Widget>[
                const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'You can find the ',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: 'Settings page here',
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SettingsScreen()));
                              },
                          ),
                          const TextSpan(
                            text:
                                ', or on the left top dropdown menu. In the notifications section of the Settings page you will find checkboxes to allow or disable notifications. Email notifications will be sent to the email connected to the account holder used for logging in.',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  buttonHeight: 52.0,
                  buttonMinWidth: 90.0,
                  children: <Widget>[
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        card4.currentState?.collapse();
                      },
                      child: Column(
                        children: const <Widget>[
                          Icon(Icons.arrow_upward),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('Close'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ExpansionTileCard(
              key: card5,
              expandedTextColor: Colors.red,
              leading: Container(
                child: const FittedBox(
                  fit: BoxFit.contain,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/SS_Mascot.png'),
                    backgroundColor: Colors.red,
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
              ),
              title: const Text('Where can I find my order history?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              subtitle: const Text(''),
              children: <Widget>[
                const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'You can find the ',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: 'Orders Page here',
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const OrdersScreen()));
                              },
                          ),
                          const TextSpan(
                            text:
                                ', or on the left top dropdown menu. From the Orders Page you can view current, past, and cancelled orders using the toggle filters.',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  buttonHeight: 52.0,
                  buttonMinWidth: 90.0,
                  children: <Widget>[
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        card5.currentState?.collapse();
                      },
                      child: Column(
                        children: const <Widget>[
                          Icon(Icons.arrow_upward),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('Close'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ExpansionTileCard(
              key: card6,
              expandedTextColor: Colors.red,
              leading: Container(
                child: const FittedBox(
                  fit: BoxFit.contain,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/SS_Mascot.png'),
                    backgroundColor: Colors.red,
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
              ),
              title: const Text('Where can I adjust my store inventory?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              subtitle: const Text(''),
              children: <Widget>[
                const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'You can find the ',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: 'Inventory page here',
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const InventoryScreen()));
                              },
                          ),
                          const TextSpan(
                            text:
                                ', or on the left top dropdown menu. From the Inventory page you can select the category containing the items you wish to modify the inventory for.',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  buttonHeight: 52.0,
                  buttonMinWidth: 90.0,
                  children: <Widget>[
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        card6.currentState?.collapse();
                      },
                      child: Column(
                        children: const <Widget>[
                          Icon(Icons.arrow_upward),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('Close'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ExpansionTileCard(
              key: card7,
              expandedTextColor: Colors.red,
              leading: Container(
                child: const FittedBox(
                  fit: BoxFit.contain,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/SS_Mascot.png'),
                    backgroundColor: Colors.red,
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
              ),
              title: const Text("Don't see your question listed here?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              subtitle: const Text(''),
              children: <Widget>[
                const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text:
                                'We can assist you with further questions through the form on the ',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: 'Contact Us page!',
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ContactsScreen()));
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  buttonHeight: 52.0,
                  buttonMinWidth: 90.0,
                  children: <Widget>[
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        card7.currentState?.collapse();
                      },
                      child: Column(
                        children: const <Widget>[
                          Icon(Icons.arrow_upward),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('Close'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
