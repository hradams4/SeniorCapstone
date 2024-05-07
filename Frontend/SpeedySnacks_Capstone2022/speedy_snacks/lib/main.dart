//This is a package that contains widgets (objects)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speedy_snacks/screens/home_screen.dart';

//importing additional dart file in lib/screens
import 'package:speedy_snacks/screens/login_screen.dart';
import 'package:speedy_snacks/screens/menu_screen.dart';

/**
 * Main file of our application.  This file will is responsible for launching our 
 * starting page which will be our login screen.
 * 
 * Our screens will be located in the lib/screens folder for each page of our application.
 * 
 * @author William Sanchez 
 * @version 0.0.1
 */
void main() {
  /////////////////////////////////////////////////////////////////////////
  ///////////Adds Screen orientation feature to application////////////////
  /////////////////////////////////////////////////////////////////////////
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  /**
   * startScreen loads a widget and shows it on the screen.
   */
  runApp(loginScreen());
}

/**
 * Class below points to separate dart file in lib/screens folder and calls User_Login() class.
 */
class loginScreen extends StatelessWidget {
  const loginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: UserLogin());
  }
}

/**
 * Homepage class calls SideMenu drawer class in lib/screens for the side menu 
 */
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}
