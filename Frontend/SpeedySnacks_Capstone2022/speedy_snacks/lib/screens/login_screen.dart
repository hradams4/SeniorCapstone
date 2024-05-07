import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:speedy_snacks/screens/menu_screen.dart';
import '../main.dart';
import 'package:speedy_snacks/screens/forgot_password.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:speedy_snacks/models/order_model.dart';
import 'package:speedy_snacks/models/order_line_model.dart';
import 'home_screen.dart';
import 'package:speedy_snacks/widgets/incoming_order_dialog.dart';
import 'package:speedy_snacks/screens/orders_screen.dart';

/**
 * This file will handle all of the logic necessary for a user to be able to
 * login.  If the user needs his password reset this screen will route the user
 * to the forgot_password.dart screen.
 * 
 * @version 1.0.3
 * @date 11/7/2022
 */
class UserLogin extends StatefulWidget {
  @override
  _User_Login_State createState() => _User_Login_State();
}

class _User_Login_State extends State<UserLogin> {
  var email_addr = '';
  var password = '';
  late WebSocketChannel channel;
  late StreamController streamController;
  var messageFromServer;
  late bool _passwordVisible;
  int _counter = 60;
  late Timer _timer;
  late StreamController<int> _events;
  bool _showIncomingOrderNotification = false;
  OrderLine testOrderLine = OrderLine(1, "1", 1, "Pop", 1, 1.00, "N/A", 1, "");
  late List<OrderLine> testOrderLines = [testOrderLine];
  late Order testOrder = Order(
    "1",
    "Bob",
    "Active",
    "DoorDash",
    "6:00 PM",
    testOrderLines,
  );

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;

    /**
     * Channel below establishes a connection to our websocket server and activates
     * loginConsumer() in server.
     * NOTE: IP Will need to be changed to asu.speedysnacks.co
     */

    channel = WebSocketChannel.connect(
        Uri.parse('ws://asu.speedysnacks.co/ws/login/'));

    //Add a stream controller to handle listening to a stream more than once.
    streamController = StreamController.broadcast();
    streamController.addStream(channel.stream);
  }

  void _startTimer() {
    _counter = 60;
    // if (_timer != null) {
    //   _timer.cancel();
    // }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer.cancel();
        }
      });
      print(_counter);
      _events.add(_counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    /**
     * Listens to messages sent by the server.
     */
    streamController.stream.listen((channel) {
      var dataJson = json.decode(channel);
      messageFromServer = dataJson['message'];
      print('Message from server is : ' + messageFromServer);

      /**
       * Listen for server to return with success for authentication.
       */

      //if authentication is successful.
      if (messageFromServer == 'authenticated') {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen()));
        print(email_addr + ' Logged in Successful!');
      }
      //If authentication is not successful.
      else if (messageFromServer == 'Invalid credentials') {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Login is incorrect!'),
            content: const Text('Please try again'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  child: const Text('okay'),
                ),
              ),
            ],
          ),
        );
      } else if (messageFromServer == 'New order request!') {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('New order notification!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order #: ' + testOrder.orderId),
                Text('Customer: ' + testOrder.name),
                SizedBox(height: 16),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrdersScreen(),
                    ),
                  );
                },
                child: Text('Review order'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Dismiss'),
              ),
            ],
          ),
        );
      }
    });

    /**
     * MaterialApp() is a predefined class that contains widgets that are used for
     * the design of the application.
     */
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color.fromRGBO(212, 44, 37, 1.000),
        ),
      ),

      /**
       * A Scaffold is used to implement the basic material design visual layout structure.
       */
      home: Scaffold(
        /**
         * Bar at the top of the page.
         */
        appBar: AppBar(title: const Text('Welcome to Speedy Snacks!')),

        /**
         * Everything underneath the appBar.
         */
        body: Column(
          /**
           * Align everything to the center of the screen.
           */
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          /**
           * Everything that will go inside top of our body panel.
           */
          children: [
            Padding(
              /**
               * Speedy Snacks Logo
               */
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Image.asset('assets/images/SS_Logo.png'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),

              /**
               * Form where we will add our email, password, button and Reset password link
               */
              child: Form(
                child: Column(
                  children: [
                    /**
                     * Text form field for user to enter email address
                     */
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 200),
                      child: TextFormField(
                        // controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter Email',
                          prefixIcon: Icon(Icons.mail_lock_rounded),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (String value) {
                          email_addr = value;
                        },
                        validator: (value) {
                          return value!.isEmpty ? 'Please enter email' : null;
                        },
                      ),
                    ),

                    /**
                     * Adds space between email and password field.
                     */
                    const SizedBox(
                      height: 30,
                    ),

                    /**
                     * Text form field for user to enter password.
                     */
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 200),
                      child: TextFormField(
                        // controller: password,
                        // keyboardType: TextInputType.visiblePassword,
                        keyboardType: TextInputType.text,
                        obscureText: !_passwordVisible,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter Password',
                          prefixIcon: Icon(Icons.password),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (String value) {
                          password = value;
                        },
                        onFieldSubmitted: (String value) {
                          password = value;
                          /**
                           * Will send credentials to websocket server on Press.
                           */
                          channel.sink.add(jsonEncode({
                            'type': 'subscribe',
                            'email': email_addr,
                            'password': password,
                          }));
                        },
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Please enter password'
                              : null;
                        },
                      ),
                    ),

                    /**
                     * Adds space between password field and button.
                     */
                    const SizedBox(
                      height: 30,
                    ),

                    /**
                     * Login button
                     */
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 200),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        onPressed: () {
                          /**
                           * Will send credentials to websocket server on Press.
                           */
                          channel.sink.add(jsonEncode({
                            'type': 'subscribe',
                            'email': email_addr,
                            'password': password,
                          }));
                        },
                        color: Color.fromRGBO(212, 44, 37, 1.000),
                        textColor: Colors.white,
                        child: const Text('Login'),
                      ),
                    ),

                    /**
                     * Adds space between button & Reset link.
                     */
                    const SizedBox(
                      height: 30,
                    ),

                    /**
                     * Hyperlink that routes to the forgot password screen.
                     */
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: 'Reset Password',
                            style: new TextStyle(
                                color: Color.fromRGBO(24, 44, 228, 1)),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => forgotPassword()),
                                );
                              }),
                      ]),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
