import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:speedy_snacks/models/order_line_model.dart';
import 'package:intl/intl.dart';

class EditOrderScreenRow extends StatefulWidget {
  const EditOrderScreenRow({
    Key? key,
    required this.lineNumber,
    required this.orderLine,
  }) : super(key: key);

  final int lineNumber;
  final OrderLine orderLine;

  @override
  _EditOrderScreenRowState createState() => _EditOrderScreenRowState();
}

class _EditOrderScreenRowState extends State<EditOrderScreenRow> {
  late OrderLine orderLine;
  late int lineNumber;

  @override
  void initState() {
    super.initState();
    orderLine = widget.orderLine;
    lineNumber = widget.lineNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Image.asset(orderLine.productPictureUrl, height: 100),
          ),
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(orderLine.productName,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(orderLine.modifier,
                      style: TextStyle(fontSize: 22, color: Colors.grey)),
                ]),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.edit,
                  color: Colors.black,
                  size: 35.0,
                ),
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 35.0,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(padding: EdgeInsets.only(left: 15.0)),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  'Price',
                  style: TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
                Text(
                  NumberFormat.currency(symbol: "\$", decimalDigits: 2)
                      .format(orderLine.price),
                  style: TextStyle(fontSize: 18.0),
                ),
                Container(
                  width: 50.0,
                  height: 35.0,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  'Quantity',
                  style: TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
                Text(
                  orderLine.quantity.toString(),
                  style: TextStyle(fontSize: 18.0),
                ),
                Container(
                  width: 50.0,
                  height: 35.0,
                  child: TextField(
                    controller: orderLine.quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  'Inventory',
                  style: TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
                Text(
                  '15',
                  style: TextStyle(fontSize: 18.0),
                ),
                Container(
                  width: 50.0,
                  height: 35.0,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  'Total',
                  style: TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
                Text(
                  NumberFormat.currency(symbol: "\$", decimalDigits: 2)
                      .format(orderLine.quantity * orderLine.price),
                  style: TextStyle(fontSize: 18.0),
                ),
                Container(
                  width: 50.0,
                  height: 35.0,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
