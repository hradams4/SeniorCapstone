/**
 * The Edit Order page recreates the Order Details page with form elements that can
 * be used to send new data to the back end and update the MySQL server.
 * 
 * It must receive the orderId for an Order object to fetch the data for building the page.
 *
 * @author Nicholas Holtman
 * @version February 10, 2023
 */

import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:speedy_snacks/screens/menu_screen.dart';
import 'package:speedy_snacks/models/order_model.dart';
import 'package:speedy_snacks/models/order_line_model.dart';
import 'package:speedy_snacks/widgets/edit_order_screen_row.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:async';
import 'dart:convert';

class EditOrderScreen extends StatefulWidget {
  const EditOrderScreen(this.order, this.onClosed);

  final Order order;
  final VoidCallback onClosed;

  @override
  _EditOrderScreenState createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  late Order _order;
  late WebSocketChannel channelOrderDetails;
  late WebSocketChannel channelCancelOrder;
  late StreamController streamControllerOrderDetails;
  late StreamController streamControllerCancelOrder;
  late VoidCallback _onClosed;
  var messageFromServer;
  var reason = '';

  @override
  void initState() {
    super.initState();
    _order = widget.order;
    _onClosed = widget.onClosed;
    channelOrderDetails = WebSocketChannel.connect(
        Uri.parse('ws://asu.speedysnacks.co/ws/orderDetails/'));
    streamControllerOrderDetails = StreamController.broadcast();
    streamControllerOrderDetails.addStream(channelOrderDetails.stream);

    channelCancelOrder = WebSocketChannel.connect(
        Uri.parse('ws://asu.speedysnacks.co/ws/cancelOrder/'));
    streamControllerCancelOrder = StreamController.broadcast();
    streamControllerCancelOrder.addStream(channelCancelOrder.stream);

    // _onCallback = widget.onCallback;
  }

  void _updateOrder(Order newOrder) {
    setState(() {
      _order = newOrder;
    });
    widget.onClosed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: Text("Order Details"),
        backgroundColor: Color.fromRGBO(212, 44, 37, 1.000),
      ),
      body: _buildContent(context, _order, channelOrderDetails,
          channelCancelOrder, _updateOrder),
    );
  }
}

Widget _buildContent(
    BuildContext context,
    Order order,
    WebSocketChannel channelOrderDetails,
    WebSocketChannel channelCancelOrder,
    Function _updateOrder) {
  return Scaffold(
      body: Container(
          // ignore: prefer_const_literals_to_create_immutables
          child: Column(children: [
    Padding(padding: EdgeInsets.only(top: 10.0)),
    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(padding: EdgeInsets.only(left: 20.0)),
      BackButton(
        color: Colors.black,
      ),
      Padding(padding: EdgeInsets.only(left: 20.0)),
      Text(order.name, style: TextStyle(fontSize: 35.0)),
    ]),
    Padding(padding: EdgeInsets.only(top: 20.0)),
    Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Column(children: [
        Text('Partner', style: TextStyle(fontSize: 16, color: Colors.grey)),
        Text(order.deliveryCo),
      ]),
      Column(children: [
        Text('Driver', style: TextStyle(fontSize: 16, color: Colors.grey)),
        Text('Bob A'),
      ]),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey, // background
          foregroundColor: Colors.white, // foreground
        ),
        onPressed: () {},
        child: const Text('Request Multiple\nDelivery Partners'),
      )
    ]),
    Padding(padding: EdgeInsets.only(top: 20.0)),
    // ignore: prefer_const_constructors
    Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Text('Order ' + order.orderId, style: TextStyle(fontSize: 35.0)),
      Container(
          width: 150,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // background
              foregroundColor: Colors.white, // foreground
            ),
            onPressed: () {
              saveChanges(order, channelOrderDetails, _updateOrder);
            },
            child: const Text('Save Changes'),
          )),
      Container(
          width: 150,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // background
              foregroundColor: Colors.white, // foreground
            ),
            onPressed: () {
              // create a list of options for the dropdown menu
              List<String> reasons = [
                'Item unavailable',
                'Customer canceled',
                'Other'
              ];
              String? selectedReason; // no default selection
              String comment = '';

              // channelCancelOrder.sink.add(jsonEncode({
              //   'cancel_orderId': order.orderId,
              // }));
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => StatefulBuilder(
                  builder: (context, setState) {
                    bool isOtherSelected = selectedReason == 'Other';
                    bool isOKButtonEnabled = selectedReason != null &&
                        (!isOtherSelected || comment.isNotEmpty);

                    return AlertDialog(
                      title: Text('Cancel Order: ${order.orderId}'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Please select a reason for canceling:'),
                          const Padding(padding: EdgeInsets.only(top: 10.0)),
                          DropdownButton<String>(
                            value: selectedReason,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedReason = newValue;
                                isOtherSelected = newValue == 'Other';
                                isOKButtonEnabled = comment.isNotEmpty ||
                                    (selectedReason != null &&
                                        !isOtherSelected);
                              });
                            },
                            items: reasons
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          if (isOtherSelected)
                            Column(
                              children: [
                                const SizedBox(height: 10),
                                const Text('Please provide a reason:'),
                                const Padding(
                                    padding: EdgeInsets.only(top: 10.0)),
                                SizedBox(
                                  width: 200,
                                  height: 100,
                                  child: TextField(
                                    maxLines: null,
                                    onChanged: (value) {
                                      setState(() {
                                        comment = value;
                                        isOKButtonEnabled = comment.isNotEmpty;
                                      });
                                    },
                                    autocorrect: true,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Type a reason',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: isOKButtonEnabled
                              ? () {
                                  // send the reason for canceling the order to the server
                                  channelCancelOrder.sink.add(jsonEncode({
                                    'cancel_orderId': order.orderId,
                                    'cancel_reason': selectedReason.toString(),
                                    'other_reason': comment,
                                  }));
                                  Navigator.pop(context, 'OK');
                                }
                              : null,
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
            child: const Text('Cancel Order'),
          )),
    ]),
    const Padding(padding: EdgeInsets.only(top: 30.0)),
    Expanded(
        child: ListView.builder(
            itemCount: order.orderLines.length,
            itemBuilder: (BuildContext context, int index) {
              return EditOrderScreenRow(
                lineNumber: index + 1,
                orderLine: order.orderLines[index],
              );
            })),
  ])));
}

Future<void> saveChanges(Order order, WebSocketChannel channelOrderDetails,
    Function updateOrder) async {
  for (int i = 0; i < order.orderLines.length; i++) {
    if (order.orderLines[i].quantityController.text != "") {
      try {
        order.orderLines[i].quantity =
            double.parse(order.orderLines[i].quantityController.text);
      } catch (e) {
        print('Error: $e');
        return;
      }
    }
  }
  final List<Map<String, dynamic>> updatedLines = order.orderLines.map((line) {
    return {
      'order_id': line.sqlOrderId,
      'quantity': line.quantity,
    };
  }).toList();
  final jsonEncoded = json.encode(updatedLines);
  channelOrderDetails.sink.add(jsonEncoded);
  updateOrder(order);
}
