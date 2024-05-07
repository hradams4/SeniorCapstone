/**
 * Orders page is for users to view orders on the application
 * 
 * @author Hillary Adams, Nicholas Holtman
 * @version November 19, 2022
 */

import 'dart:core';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:speedy_snacks/screens/menu_screen.dart';
import 'package:speedy_snacks/screens/login_screen.dart';
import 'package:speedy_snacks/screens/order_details_screen.dart';
import 'package:speedy_snacks/models/order_model.dart';
import 'package:speedy_snacks/models/order_line_model.dart';
import 'package:speedy_snacks/widgets/order_screen_row.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

//Delete this after implementing persistent user sessions.
import 'package:speedy_snacks/models/user_model.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key});

  @override
  _Orders_Screen createState() => _Orders_Screen();
}

class _Orders_Screen extends State<OrdersScreen> {
  bool incomingOrdersSelected = true;
  bool activeOrdersSelected = false;
  bool completedOrdersSelected = false;
  bool cancelledOrdersSelected = false;

  late WebSocketChannel channel;
  late StreamController streamController;
  var messageFromServer;
  String deliveryOrderIdTest = '';
  List<Order> ordersList = [];

  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(
        Uri.parse('ws://asu.speedysnacks.co/ws/loadOrders/'));
    streamController = StreamController.broadcast();
    streamController.addStream(channel.stream);

    channel.sink.add(json.encode({
      'type': 'request_orders',
    }));
  }

  void _refreshScreen() {
    setState(() {
      ordersList = ordersList;
    });
  }

  @override
  Widget build(BuildContext context) {
    streamController.stream.listen((channel) {
      var dataJson = json.decode(channel);
      messageFromServer = dataJson['message'];
      print('Message from server is : ' + messageFromServer);

      var sqlOrderIds = dataJson['sqlOrderIds'];
      var deliveryOrderIds = dataJson['deliveryOrderIds'];
      var statuses = dataJson['statuses'];
      var deliveryCos = dataJson['deliveryCos'];
      var orderTimes = dataJson['orderTimes'];
      var modifiers = dataJson['modifiers'];
      var itemNames = dataJson['itemNames'];
      var lineItems = dataJson['lineItems'];
      var productIds = dataJson['productIds'];
      var modifierIds = dataJson['modifierIds'];
      var quantities = dataJson['quantities'];
      var prices = dataJson['prices'];
      var productPictureUrls = dataJson['productPictureUrls'];

      print('Number of orders received: ' + deliveryOrderIds.length.toString());
      for (var i = 0; i < deliveryOrderIds.length; i++) {
        if (sqlOrderIds[i] == null || sqlOrderIds[i] == "None") {
          sqlOrderIds[i] = '0';
        }
        if (deliveryOrderIds[i] == "22721763") {
          print("Hi Mom!");
        }

        if (deliveryOrderIds[i]['delivery_order_id'] == null ||
            deliveryOrderIds[i]['delivery_order_id'] == "None") {
          deliveryOrderIds[i]['delivery_order_id'] = '';
        }
        if (statuses[i]['status'] == null || statuses[i]['status'] == "None") {
          statuses[i]['status'] = '';
        }
        if (deliveryCos[i]['delivery_co'] == null ||
            deliveryCos[i]['delivery_co'] == "None") {
          deliveryCos[i]['delivery_co'] = '';
        }
        if (orderTimes[i] == null || orderTimes[i] == "None") {
          orderTimes[i] = '';
        }
        if (modifiers[i]['modifier'] == null ||
            modifiers[i]['modifier'] == "None") {
          modifiers[i]['modifier'] = '';
        }
        if (itemNames[i]['item_name'] == null ||
            itemNames[i]['item_name'] == "None") {
          itemNames[i]['item_name'] = '';
        }
        if (lineItems[i]['line_item'] == null ||
            lineItems[i]['line_item'] == "None") {
          lineItems[i]['line_item'] = '';
        }
        if (productIds[i] == null || productIds[i] == "None") {
          productIds[i] = '0';
        }
        if (modifierIds[i] == null || modifierIds[i] == "None") {
          modifierIds[i] = '0';
        }
        if (quantities[i] == null || quantities[i] == "None") {
          quantities[i] = '0.00';
        }
        if (prices[i] == null || prices[i] == "None") {
          prices[i] = '0.00';
        }
        if (productPictureUrls[i] == null || productPictureUrls[i] == "None") {
          productPictureUrls[i] = '';
        }

        OrderLine newOrderLine = OrderLine(
            int.parse(sqlOrderIds[i]),
            lineItems[i]['line_item'],
            int.parse(productIds[i]),
            itemNames[i]['item_name'],
            double.parse(quantities[i]),
            double.parse(prices[i]),
            modifiers[i]['modifier'],
            int.parse(modifierIds[i]),
            productPictureUrls[i]);
        List<OrderLine> orderLines = [newOrderLine];

        var existingOrder = ordersList.where(((order) =>
            order.orderId == deliveryOrderIds[i]['delivery_order_id']));

        if (existingOrder.isEmpty) {
          Order newOrder = Order(
              deliveryOrderIds[i]['delivery_order_id'],
              "Person",
              statuses[i]['status'],
              deliveryCos[i]['delivery_co'],
              orderTimes[i],
              orderLines);
          ordersList.add(newOrder);
        } else {
          existingOrder.first.orderLines.add(newOrderLine);
          if (statuses[i]['status'].trim().toLowerCase() == "incoming") {
            existingOrder.first.status = "Incoming";
          }
          if (statuses[i]['status'].trim().toLowerCase() == "active" &&
              existingOrder.first.status != "Incoming") {
            existingOrder.first.status = "Active";
          }
          if (statuses[i]['status'].trim().toLowerCase() == "ready" &&
              existingOrder.first.status != "Incoming" &&
              existingOrder.first.status != "Active") {
            existingOrder.first.status = "Ready";
          }
        }
        if (statuses[i]['status'].trim().toLowerCase() == "completed" &&
            existingOrder.first.status != "Incoming" &&
            existingOrder.first.status != "Active" &&
            existingOrder.first.status != "Ready") {
          existingOrder.first.status = "Completed";
        }
      }
      setState(() {
        ordersList = ordersList;
      });
    });

    return Scaffold(
        drawer: SideMenu(),
        appBar: AppBar(
          title: Text("Orders"),
          backgroundColor: Color.fromRGBO(212, 44, 37, 1.000),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.backspace),
            ),
          ],
        ),
        body: Container(
            child: Column(children: [
          Padding(padding: EdgeInsets.only(top: 20.0)),
          Text(
            'Orders List',
            style: TextStyle(fontSize: 35.0),
          ),
          Padding(padding: EdgeInsets.only(top: 20.0)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            FilterChip(
                selected: incomingOrdersSelected,
                label: Text('Incoming'),
                labelStyle: TextStyle(color: Colors.white),
                backgroundColor: Colors.black54,
                selectedColor: Colors.blue,
                avatar: Text('W', style: TextStyle(color: Colors.white)),
                onSelected: (bool selected) {
                  setState(() {
                    incomingOrdersSelected = !incomingOrdersSelected;
                  });
                }),
            FilterChip(
                selected: activeOrdersSelected,
                label: Text('Active'),
                labelStyle: TextStyle(color: Colors.white),
                backgroundColor: Colors.black54,
                selectedColor: Colors.blue,
                avatar: Text('W', style: TextStyle(color: Colors.white)),
                onSelected: (bool selected) {
                  setState(() {
                    activeOrdersSelected = !activeOrdersSelected;
                  });
                }),
            FilterChip(
                selected: completedOrdersSelected,
                label: Text('Completed'),
                labelStyle: TextStyle(color: Colors.white),
                backgroundColor: Colors.black54,
                selectedColor: Colors.blue,
                avatar: Text('W', style: TextStyle(color: Colors.white)),
                onSelected: (bool selected) {
                  setState(() {
                    completedOrdersSelected = !completedOrdersSelected;
                  });
                }),
            FilterChip(
                selected: cancelledOrdersSelected,
                label: Text('Cancelled'),
                labelStyle: TextStyle(color: Colors.white),
                backgroundColor: Colors.black54,
                selectedColor: Colors.blue,
                avatar: Text('W', style: TextStyle(color: Colors.white)),
                onSelected: (bool selected) {
                  setState(() {
                    cancelledOrdersSelected = !cancelledOrdersSelected;
                  });
                }),
          ]),
          Padding(padding: EdgeInsets.only(top: 30.0)),
          Expanded(
              child: ListView.builder(
                  itemCount: ordersList.length,
                  itemBuilder: (BuildContext context, int index) {
                    if ((activeOrdersSelected &&
                            (ordersList[index].status.trim().toLowerCase() ==
                                    "active" ||
                                ordersList[index].status.trim().toLowerCase() ==
                                    "ready")) ||
                        (incomingOrdersSelected &&
                            ordersList[index].status.trim().toLowerCase() ==
                                "incoming") ||
                        (cancelledOrdersSelected &&
                            ordersList[index].status.trim().toLowerCase() ==
                                "cancelled") ||
                        (completedOrdersSelected &&
                            ordersList[index].status.trim().toLowerCase() ==
                                ("completed"))) {
                      return OrderScreenRow(
                        order: ordersList[index],
                        onCallback: _refreshScreen,
                      );
                    } else {
                      return const SizedBox(height: 0);
                    }
                  })),
        ])));
  }
}
