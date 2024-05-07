import 'package:flutter/material.dart';
import 'package:speedy_snacks/screens/order_details_screen.dart';
import 'package:speedy_snacks/models/order_model.dart';
import 'package:speedy_snacks/models/order_line_model.dart';

class OrderScreenRow extends StatefulWidget {
  const OrderScreenRow({
    Key? key,
    required this.order,
    required this.onCallback,
  }) : super(key: key);

  final Order order;
  final VoidCallback onCallback;

  @override
  _OrderScreenRowState createState() => _OrderScreenRowState();
}

class _OrderScreenRowState extends State<OrderScreenRow> {
  late Order order;
  late VoidCallback onCallback;

  @override
  void initState() {
    super.initState();
    order = widget.order;
    onCallback = widget.onCallback;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          visualDensity: VisualDensity(vertical: 4),
          leading: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 80,
                minHeight: 80,
                maxWidth: 80,
                maxHeight: 80,
              ), // fixed width and height
              child:
                  Image.asset(getIconUrl(order.deliveryCo), fit: BoxFit.cover)),
          title: Text(order.name, style: TextStyle(fontSize: 30.0)),
          subtitle: Text(order.orderTime, style: TextStyle(fontSize: 25.0)),
          trailing: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 40,
              minHeight: 80,
              maxWidth: 300,
              maxHeight: 80,
            ), // fixed width and height
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(order.status, style: TextStyle(fontSize: 25.0)),
              Padding(padding: EdgeInsets.only(left: 20.0)),
              if (order.status == "Active")
                (Icon(Icons.alarm, size: 50.0, color: Colors.green))
              else if (order.status == "Incoming")
                (Icon(Icons.new_releases, size: 50.0, color: Colors.blue))
              else if (order.status == "Closed")
                (Icon(Icons.check_circle, size: 50.0, color: Colors.green))
              else if (order.status == "Cancelled")
                (Icon(Icons.close, size: 50.0, color: Colors.red)),
              Padding(padding: EdgeInsets.only(left: 65.0)),
              Icon(
                Icons.more_vert,
                size: 30.0,
                color: Colors.black,
              ),
            ]),
          ),
          //selected: true,
          onTap: () {
            print("Tapped on Order for " + order.name);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        OrderDetailsScreen(order, onCallback)));
          }),
    );
  }

  String getIconUrl(String deliveryCo) {
    String deliveryCoIconUrl = "";
    if (deliveryCo.toLowerCase().replaceAll(RegExp(r"\s+"), "") ==
        "skipthedishes") {
      return "assets/images/SkipTheDishLogo.png";
    } else if (deliveryCo.toLowerCase().replaceAll(RegExp(r"\s+"), "") ==
        "ubereats") {
      return "assets/images/UberEatLogo.png";
    } else if (deliveryCo.toLowerCase().replaceAll(RegExp(r"\s+"), "") ==
        "doordash") {
      return "assets/images/DoorDashLogo.png";
    } else {
      return "assets/images/DoorDashLogo.png";
    }
  }
}
