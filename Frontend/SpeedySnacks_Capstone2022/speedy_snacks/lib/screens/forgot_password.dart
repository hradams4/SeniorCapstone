import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../main.dart';
import 'change_password.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

/**
 * This file will allow a user to verify their identity by entering their email address
 * 
 * @version 1.0.1
 * @date 10/17/2022
 */

class forgotPassword extends StatefulWidget {
  const forgotPassword({super.key});

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  String email_addr = '';
  late WebSocketChannel channel;
  late StreamController streamController;
  var messageFromServer;

  @override
  void initState() {
    super.initState();

    /**
     * Channel below establishes a connection to our websocket server and activates
     * loginConsumer() in server.
     * NOTE: IP Will need to be changed to asu.speedysnacks.co
     */

    channel = WebSocketChannel.connect(
        Uri.parse('ws://asu.speedysnacks.co/ws/resetPassword/'));

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
      print('Message from server is : ' + messageFromServer);

      /**
       * Listen for server to return with success for authentication.
       */

      //if authentication is successful.
      if (messageFromServer == 'password reset') {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => loginScreen()));
        print(email_addr + ' Password reset was successful!');
      }
      //If authentication is not successful.
      else if (messageFromServer == 'Email does not exist') {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Email is incorrect!'),
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
      }
    });

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
          appBar: AppBar(title: const Text('Forgot Password')),

          /**
           * Everything underneath the appBar.
           */
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                /**
                 * Speedy Snacks Logo.
                 */
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Image.asset('assets/images/SS_Logo.png'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),

                /**
                 * Form where user will enter in password for verification code
                 */
                child: Form(
                  child: Column(
                    children: [
                      Text('Please enter email address to verify identity'),

                      /**
                       * add a space in between text and form.
                       */
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 200),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter Email Address',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (String value) {
                            email_addr = value;
                          },
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Please enter email address'
                                : null;
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
                       * Send button
                       */
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 200),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          onPressed: () async {
                            /**
                             * TEMPORARY behavior -> open changePassword(). 
                             * Future behavior -> send password reset link to email.
                             */
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => changePassword()),
                            // );

                            channel.sink.add(jsonEncode({
                              'type': 'password reset',
                              'email': email_addr,
                            }));
                          },
                          color: Color.fromRGBO(212, 44, 37, 1.000),
                          textColor: Colors.white,
                          child: const Text('Send'),
                        ),
                      ),

                      /**
                       * add a space in between text and form.
                       */
                      const SizedBox(
                        height: 1,
                      ),

                      /**
                       * Cancel button that routes user back to the login screen.
                       */
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 200),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => loginScreen()),
                            );
                          },
                          color: Color.fromRGBO(212, 44, 37, 1.000),
                          textColor: Colors.white,
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
