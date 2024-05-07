/**
 * The Order Details page shows all order lines for an order selected in another screen.
 * 
 * It must receive the orderId from an Order object to fetch the data for building the page.
 *
 * @author Nicholas Holtman
 * @version November 25, 2022
 */

import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:speedy_snacks/screens/cancel_order_screen.dart';
import 'package:speedy_snacks/screens/menu_screen.dart';
import 'package:speedy_snacks/models/order_model.dart';
import 'package:speedy_snacks/models/order_line_model.dart';
import 'package:speedy_snacks/widgets/order_details_screen_row.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:speedy_snacks/screens/edit_order_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen(this.order, this.onCallback, {super.key});
  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();

  final Order order;
  final VoidCallback onCallback;
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late Order _order;
  late WebSocketChannel channelCancelOrder;
  late StreamController streamController;
  late VoidCallback _onCallback;
  String _cancelOrderId = '';

  @override
  void initState() {
    super.initState();
    _order = widget.order;
    channelCancelOrder = WebSocketChannel.connect(
        Uri.parse('ws://asu.speedysnacks.co/ws/cancelOrder/'));
    streamController = StreamController.broadcast();
    streamController.addStream(channelCancelOrder.stream);
    _onCallback = widget.onCallback;
  }

  void _refreshScreen() {
    setState(() {
      _order = widget.order;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: Text("Order Details"),
        backgroundColor: Color.fromRGBO(212, 44, 37, 1.000),
      ),
      body: _buildContent(
          context, _order, channelCancelOrder, _refreshScreen, _onCallback),
    );
  }
}

// Main Content
Widget _buildContent(
    BuildContext context,
    Order order,
    WebSocketChannel channel,
    VoidCallback _refreshScreen,
    VoidCallback _onCallback) {
  return Scaffold(
    body: Container(
      child: Column(
        children: [
          _buildHeader(context, order, _onCallback),
          _buildOrderInfo(order),
          Padding(padding: EdgeInsets.only(top: 20.0)),
          _buildStatusButtons(context, order, channel, _onCallback),
          const Padding(padding: EdgeInsets.only(top: 30.0)),
          _buildOrderDetailsList(order),
        ],
      ),
    ),
  );
}

// Header
Widget _buildHeader(
    BuildContext context, Order order, VoidCallback _onCallback) {
  return Padding(
    padding: EdgeInsets.only(top: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(left: 20.0)),
        BackButton(
          color: Colors.black,
          onPressed: () {
            _onCallback();
            Navigator.pop(context);
          },
        ),
        Padding(padding: EdgeInsets.only(left: 20.0)),
        Text(order.name, style: TextStyle(fontSize: 35.0)),
      ],
    ),
  );
}

// Order Info
Widget _buildOrderInfo(Order order) {
  return Padding(
    padding: EdgeInsets.only(top: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text('Partner', style: TextStyle(fontSize: 16, color: Colors.grey)),
            Text(order.deliveryCo),
          ],
        ),
      ],
    ),
  );
}

Widget _buildStatusButtons(BuildContext context, Order order,
    WebSocketChannel channel, VoidCallback _onCallback) {
  switch (order.status.toLowerCase()) {
    case 'incoming':
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              // Send the "accept_order" message with the order ID to the server
              channel.sink.add(jsonEncode({
                'action': 'accept_order',
                'order_id': order.orderId,
              }));
              _onCallback();
            },
            child: const Text('Accept Order'),
          ),
          _buildCancelOrderButton(context, order, channel),
        ],
      );
    case 'active':
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              channel.sink.add(jsonEncode({
                'action': 'mark_ready',
                'order_id': order.orderId,
              }));
              _onCallback();
            },
            child: const Text('Mark as Ready for Pickup'),
          ),
          _buildCancelOrderButton(context, order, channel),
        ],
      );
    case 'ready':
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              channel.sink.add(jsonEncode({
                'action': 'complete_order',
                'order_id': order.orderId,
              }));
              _onCallback();
            },
            child: const Text('Mark as Picked Up'),
          ),
          _buildCancelOrderButton(context, order, channel),
        ],
      );
    default:
      return SizedBox.shrink(); // Return an empty widget for other statuses
  }
}

ElevatedButton _buildCancelOrderButton(
    BuildContext context, Order order, WebSocketChannel channel) {
  return ElevatedButton(
    onPressed: () => _handleCancelOrder(context, order, channel),
    child: const Text('Cancel Order'),
  );
}

void _handleCancelOrder(
    BuildContext context, Order order, WebSocketChannel channel) {
  // create a list of options for the dropdown menu
  List<String> reasons = ['Item unavailable', 'Customer canceled', 'Other'];
  String? selectedReason; // no default selection
  String comment = '';

  showDialog<String>(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) {
        bool isOtherSelected = selectedReason == 'Other';
        bool isOKButtonEnabled =
            selectedReason != null && (!isOtherSelected || comment.isNotEmpty);

        return AlertDialog(
          title: Text('Cancel Order: ${order.orderId}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please select a reason for canceling:'),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              DropdownButton<String>(
                value: selectedReason,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedReason = newValue!;
                    isOtherSelected = newValue == 'Other';
                    isOKButtonEnabled = comment.isNotEmpty ||
                        (selectedReason != null && !isOtherSelected);
                  });
                },
                items: reasons.map<DropdownMenuItem<String>>((String value) {
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
                    const Padding(padding: EdgeInsets.only(top: 10.0)),
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
                      channel.sink.add(jsonEncode({
                        'cancel_orderId': order.orderId,
                        'cancel_reason': selectedReason,
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
}

// Order Details List
Widget _buildOrderDetailsList(Order order) {
  return Expanded(
    child: ListView.builder(
      itemCount: order.orderLines.length,
      itemBuilder: (BuildContext context, int index) {
        return OrderDetailsScreenRow(
          lineNumber: index + 1,
          orderLine: order.orderLines[index],
        );
      },
    ),
  );
}
