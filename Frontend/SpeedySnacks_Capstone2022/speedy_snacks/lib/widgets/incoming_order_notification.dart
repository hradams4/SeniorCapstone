import 'package:flutter/material.dart';
import 'package:speedy_snacks/models/order_model.dart';

class IncomingOrderNotification extends StatelessWidget {
  final Order order;

  IncomingOrderNotification({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New Order',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Order ID: ' + order.orderId,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                'Customer: ' + order.name,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                'Total Amount: \$0.00', // Todo: getTotal() function
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text('View Details'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Accept Order'),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              TextButton(
                onPressed: () {},
                child: Text('Respond Later'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
