/**
 * Contact page for users to contact support team
 * 
 * 
 * @author Na Lee
 * @version October 21, 2022
 */

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:speedy_snacks/screens/menu_screen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:speedy_snacks/screens/FAQ.dart';
import 'package:flutter/gestures.dart';

const List<Widget> titles = <Widget>[
  Text('SkipTheDishes'),
  Text('UberEats'),
  Text('DoorDash'),
  Text('Other')
];

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  _ContactUs createState() => _ContactUs();
}

class _ContactUs extends State<ContactsScreen> {
  final message = TextEditingController();
  final List<bool> _selectedTitle = <bool>[false, false, false, false];
  bool vertical = false;

  var contact_deliverypartner = '';
  var contact_message = '';

  var _title = '';

  late WebSocketChannel channel;
  late StreamController streamController;
  var messageFromServer;

  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(
        Uri.parse('ws://asu.speedysnacks.co/ws/contacts/'));

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

    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: Text('Contact Us'),
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
      body: Center(
        child: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 20.0)),
            const Text(
              'Contact Us',
              style: TextStyle(fontSize: 35.0),
            ),
            const Padding(padding: EdgeInsets.only(top: 10.0)),
            const Text(
              'Select a delivery partner or other above for the ticket!',
              style: TextStyle(fontSize: 15.0),
            ),
            const SizedBox(height: 5),
            ToggleButtons(
              direction: vertical ? Axis.vertical : Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  // The button that is tapped is set to true, and the others to false.
                  for (int i = 0; i < _selectedTitle.length; i++) {
                    _selectedTitle[i] = i == index;
                    titles[index] as Text;
                    _title = titles[index].toString();
                    _title = _title.replaceAll("Text(\"", "");
                    _title = _title.replaceAll("\")", "");
                    contact_deliverypartner = _title;
                    //print(_title);
                    // print(_selectedTitle[i]);
                    // print(titles[index] as Text);
                  }
                });
              },
              selectedBorderColor: Colors.transparent,
              selectedColor: Colors.white,
              fillColor: Colors.red[500],
              color: Colors.red[400],
              textStyle: const TextStyle(fontSize: 20),
              borderWidth: 10,
              borderColor: Colors.transparent,
              splashColor: Colors.transparent,
              isSelected: _selectedTitle,
              children: titles,
            ),
            Container(
                width: 300,
                height: 200,
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: message,
                  autocorrect: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your message here'),
                  onChanged: (String value) {
                    contact_message = value;
                  },
                  maxLines: 20,
                  minLines: 10,
                )),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.grey, // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: () {
                channel.sink.add(jsonEncode({
                  'contact_deliverypartner': contact_deliverypartner,
                  'contact_message': contact_message,
                }));
              },
              child: const Text('Submit'),
            ),
            const Padding(padding: EdgeInsets.only(top: 12.0)),
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Before submitting a form, be sure to check our',
                      style: TextStyle(fontSize: 15.0, color: Colors.black),
                    ),
                    TextSpan(
                      text: ' FAQ page here!',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FAQScreen()));
                        },
                    ),
                  ],
                ),
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(50.0),
                    child: Image.asset('assets/images/SS_Mascot.png'),
                  )),
            ]),
          ],
        ),
      ),
    );
  }
}
