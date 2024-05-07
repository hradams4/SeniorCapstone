import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:speedy_snacks/main.dart';
import 'package:speedy_snacks/screens/settings_screen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/**
 * This file will allow a user to change their password.
 * 
 * @version 1.0.1
 * @date 10/20/2022
 */

class changePassword extends StatefulWidget {
  const changePassword({super.key});

  @override
  State<changePassword> createState() => _changePasswordState();
}

class _changePasswordState extends State<changePassword> {
  String email_addr = '';
  String oldPassword = '';
  String newPassword = '';
  String verifyPassword = '';
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
        Uri.parse('ws://asu.speedysnacks.co/ws/changePassword/'));

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
      if (messageFromServer == 'password changed') {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => loginScreen()));
        print(email_addr + ' Password change was successful!');
      }
      //If authentication is not successful.
      else if (messageFromServer == 'Invalid credentials') {
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
          appBar: AppBar(title: const Text('Change Password')),

          /**
           * Everything underneath the appBar.
           */
          body: SingleChildScrollView(
            child: Column(
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
                   * Form where user will enter password in.
                   */
                  child: Form(
                    child: Column(
                      children: [
                        Text(
                            'Please enter all fields below to change password'),

                        /**
                         * Add space between string and text field.
                         */
                        const SizedBox(
                          height: 30,
                        ),

                        /**
                         * Form where user will enter old password.
                         */
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 200),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                              hintText: 'Enter email address',
                              prefixIcon: Icon(Icons.password),
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
                         * Add space between string and text field.
                         */
                        const SizedBox(
                          height: 10,
                        ),

                        /**
                         * Form where user will enter old password.
                         */
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 200),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Old Password',
                              hintText: 'Enter Old Password',
                              prefixIcon: Icon(Icons.password),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {
                              oldPassword = value;
                            },
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'Please enter old password'
                                  : null;
                            },
                          ),
                        ),

                        /**
                         * Add space between string and text field.
                         */
                        const SizedBox(
                          height: 10,
                        ),

                        /**
                         * Form where user will enter new password.
                         */
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 200),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'New Password',
                              hintText: 'Enter New Password',
                              prefixIcon: Icon(Icons.password),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {
                              newPassword = value;
                            },
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'Please enter new password'
                                  : null;
                            },
                          ),
                        ),

                        /**
                         * Add space between text forms.
                         */
                        const SizedBox(
                          height: 10,
                        ),

                        /**
                         * Form where user will verify new password.
                         */
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 200),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Verify New Password',
                              hintText: 'Verify New Password',
                              prefixIcon: Icon(Icons.password),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {
                              verifyPassword = value;
                            },
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'Please verify new password'
                                  : null;
                            },
                          ),
                        ),

                        /**
                         * Adds space between email and password field.
                         */
                        const SizedBox(
                          height: 10,
                        ),

                        /**
                         * Send button logic that will handle different scenarios.
                         */
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 200),
                          child: MaterialButton(
                            minWidth: double.infinity,

                            /**
                             * If any field is empty
                             */
                            onPressed: () {
                              if (oldPassword.isEmpty ||
                                  newPassword.isEmpty ||
                                  verifyPassword.isEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Password change error'),
                                    content:
                                        const Text('Please use all fields!'),
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

                              /**
                               * If users old password matches the new one.
                               */
                              else if (oldPassword == newPassword ||
                                  oldPassword == verifyPassword) {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Password change error'),
                                    content: const Text(
                                        'You cannot use your old password, try again!'),
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

                              /**
                               * If new password & verify don't match.
                               */
                              else if (newPassword != verifyPassword) {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title:
                                        const Text('Passwords do not match!'),
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

                              /**
                              * If password's match.
                              */
                              else if (newPassword == verifyPassword) {
                                channel.sink.add(jsonEncode({
                                  'type': 'password change',
                                  'username': email_addr,
                                  'old_password': oldPassword,
                                  'new_password': newPassword,
                                }));
                                /**
                                 * SEND MAGIC TO DB
                                 */

                                /**
                                 * Displays success dialog and routes user back to login screen.
                                 */
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Success!'),
                                    content:
                                        const Text('Password has been reset'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    loginScreen()),
                                          );
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
                            },
                            color: Color.fromRGBO(212, 44, 37, 1.000),
                            textColor: Colors.white,
                            child: const Text('Send'),
                          ),
                        ),

                        /**
                         * Adds space between button & Reset link.
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
                                    builder: (context) => SettingsScreen()),
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
            ),
          ),
        ));
  }
}
