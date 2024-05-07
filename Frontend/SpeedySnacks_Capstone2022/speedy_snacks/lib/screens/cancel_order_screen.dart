/**
 * Cancel order page for users to cancel an order
 * 
 * 
 * @author Na Lee
 * @version February 17, 2023
 */

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:speedy_snacks/screens/menu_screen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const List<Widget> titles = <Widget>[
  Text('Reason 1 for cancel'),
  Text('Reason 2 for cancel'),
  Text('Reason 3 for cancel'),
  Text('Reason 4 for cancel')
];

class CancelOrderScreen extends StatefulWidget {
  final String cancelOrderId;

  const CancelOrderScreen({required this.cancelOrderId, Key? key})
      : super(key: key);

  @override
  _CancelOrderScreenState createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  final List<bool> _selectedTitle = <bool>[false, false, false, false];
  bool vertical = false;

  late WebSocketChannel channel;
  late StreamController streamController;
  TextEditingController commentsController = TextEditingController();

  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(
        Uri.parse('ws://asu.speedysnacks.co/ws/orderDetails/'));
    streamController = StreamController.broadcast();

    // Listen to the stream controller and check if the stream is closed before adding new events to it
    streamController.stream.listen((channel) {
      if (!streamController.isClosed) {
        var dataJson = json.decode(channel);
        // handle data received from the WebSocket server
      } else {
        // Create a new stream controller to replace the closed one
        streamController = StreamController.broadcast();
        var dataJson = json.decode(channel);
        // handle data received from the WebSocket server
      }
    });
  }

  @override
  void dispose() {
    streamController.close();
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    streamController.stream.listen((channel) {
      var dataJson = json.decode(channel);
      // handle data received from the WebSocket server
    });

    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: Text('Cancel order page'),
        backgroundColor: const Color.fromRGBO(212, 44, 37, 1.000),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0),
              child: Row(
                children: [
                  const BackButton(
                    color: Colors.black,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Cancel Order: ${widget.cancelOrderId}',
                        style: TextStyle(fontSize: 35.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 30.0)),
            const Text(
              'Select a reason for canceling the order!',
              style: TextStyle(fontSize: 15.0),
            ),
            const SizedBox(height: 5),
            ToggleButtons(
              direction: vertical ? Axis.vertical : Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  _selectedTitle[index] = !_selectedTitle[index];
                });
              },
              selectedBorderColor: Colors.transparent,
              selectedColor: Colors.white,
              fillColor: Colors.red[500],
              color: Colors.red[400],
              textStyle: const TextStyle(fontSize: 20),
              borderWidth: 20,
              borderColor: Colors.transparent,
              splashColor: Colors.transparent,
              isSelected: _selectedTitle,
              children: titles,
            ),
            Container(
                width: 280,
                padding: const EdgeInsets.all(10.0),
                child: TextFormField()),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.grey, // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: () {},
              child: const Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}
