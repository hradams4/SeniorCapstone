/**
 * Inventory Page
 * 
 * @author Batbold Altansukh
 * @version November 14, 2022
 */

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:speedy_snacks/screens/inventory_detail_screen.dart';
import 'package:speedy_snacks/screens/menu_screen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late WebSocketChannel channel;
  late StreamController streamController;
  var messageFromServer;
  int productLocationIdx = 0;
  int labelIdx = 1;
  int amountIdx = 5;
  late List<String> productLocactionList = [];
  late List<String> labelList = [];
  late List<String> amountList = [];
  List<String> imagePaths = [
    "assets/images/1bakedsnacks.png",
    "assets/images/2candy.png",
    "assets/images/3chips.png",
    "assets/images/4chocolate.png",
    "assets/images/5coffee.png",
    "assets/images/6drinks.png",
    "assets/images/7crackers.png",
    "assets/images/8gum.png",
    "assets/images/9icecream.png",
    "assets/images/10health.png",
    "assets/images/11instantnoodle.png",
    "assets/images/12kombucha.png",
    "assets/images/13Meats&Jerky.png",
    "assets/images/14Microwave.png",
    "assets/images/15Other.png",
    "assets/images/16Grocery.png",
    "assets/images/17Breakfast.png",
    "assets/images/18Cereal.png",
    "assets/images/19Nuts&Seed.png",
    "assets/images/20Juice.png",
    "assets/images/21Soda.png",
    "assets/images/22Importedsoda.png",
    "assets/images/23Water.png",
    "assets/images/24EnergyDrink.png",
    "assets/images/25SportDrink.png",
    "assets/images/26ImportedCandy.png",
    "assets/images/27ImportedChocolate.png",
    "assets/images/28SnackBars.png",
    "assets/images/29Popcorn.png",
    "assets/images/30pretzel.png",
    "assets/images/31SnackCup.png",
    "assets/images/dots.png"
  ];

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(
        Uri.parse('ws://asu.speedysnacks.co/ws/productList/'));
    streamController = StreamController.broadcast();
    streamController.addStream(channel.stream);
  }

  @override
  Widget build(BuildContext context) {
    streamController.stream.listen((channel) {
      var dataJson = json.decode(channel);
      messageFromServer = dataJson['message'];
      int totalItems = messageFromServer[0][amountIdx];

      for (int i = 0; i < totalItems; i++) {
        productLocactionList
            .add(messageFromServer[i][productLocationIdx].toString());
      }

      for (int i = 0; i < totalItems; i++) {
        labelList.add(messageFromServer[i][labelIdx].toString());
      }

      for (int i = 0; i < totalItems; i++) {
        amountList.add(messageFromServer[i][amountIdx].toString());
      }

      setState(() {
        messageFromServer = messageFromServer;
      });
    });

    Widget eachItem(imgName, imgLabel, imgAmount, productLocation) {
      return GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: Colors.white,
          ),
          margin: const EdgeInsets.all(25),
          width: 200,
          height: 300,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Image.asset(imgName),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  imgLabel,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  imgAmount,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InventoryDetailScreen(
                      imgAmount: imgAmount,
                      imgLabel: imgLabel,
                      productLocation: productLocation)));
          channel.sink.add(jsonEncode({
            'msg': productLocation,
          }));
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: SideMenu(),
      appBar: AppBar(
        title: const Text('Inventory Management'),
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
      body: GridView.count(
        crossAxisCount: 3,
        children: List.generate(labelList.length, (index) {
          return eachItem(imagePaths[index], labelList[index],
              amountList[index], productLocactionList[index]);
        }),
      ),
    );
  }
}
