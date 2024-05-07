import 'package:flutter/material.dart';
import 'package:speedy_snacks/models/order_model.dart';

class IncomingOrderDialog extends StatelessWidget {
  final Order order;
  final VoidCallback onAccept;
  final VoidCallback onDefer;
  final VoidCallback onDismiss;

  const IncomingOrderDialog({
    Key? key,
    required this.order,
    required this.onAccept,
    required this.onDefer,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New order notification!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order #: ${order.orderId}'),
          Text('Customer: ${order.name}'),
          Text('Items: ${order.orderLines.length}'),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: onAccept,
                child: Text('Accept'),
              ),
              ElevatedButton(
                onPressed: onDefer,
                child: Text('Defer'),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onDismiss,
          child: Text('Dismiss'),
        ),
      ],
    );
  }
}
