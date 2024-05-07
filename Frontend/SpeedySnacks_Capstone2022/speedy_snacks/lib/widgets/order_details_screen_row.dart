import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:speedy_snacks/models/order_line_model.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreenRow extends StatefulWidget {
  const OrderDetailsScreenRow({
    Key? key,
    required this.lineNumber,
    required this.orderLine,
  }) : super(key: key);

  final int lineNumber;
  final OrderLine orderLine;

  @override
  _OrderDetailsScreenRowState createState() => _OrderDetailsScreenRowState();
}

class _OrderDetailsScreenRowState extends State<OrderDetailsScreenRow> {
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
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Image.network(
          orderLine.productPictureUrl,
          width: 100,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Icon(Icons.error_outline);
          },
        ),
        Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(orderLine.productName,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(orderLine.modifier,
                  style: TextStyle(fontSize: 22, color: Colors.grey)),
              Row(children: [
                RatingBar.builder(
                  initialRating: 4,
                  itemSize: 10,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                ),
                Text(
                  '4.1',
                  style: TextStyle(fontSize: 10),
                ),
              ])
            ]),
        Padding(padding: EdgeInsets.only(left: 15.0)),
        Column(children: [
          Text(
            'Price',
            style: TextStyle(fontSize: 18.0, color: Colors.grey),
          ),
          Text(
            NumberFormat.currency(symbol: "\$", decimalDigits: 2)
                .format(orderLine.price),
            style: TextStyle(fontSize: 18.0),
          ),
        ]),
        Column(children: [
          Text(
            'Quantity',
            style: TextStyle(fontSize: 18.0, color: Colors.grey),
          ),
          Text(
            orderLine.quantity.toString(),
            style: TextStyle(fontSize: 18.0),
          ),
        ]),
        Column(children: [
          Text(
            'Inventory',
            style: TextStyle(fontSize: 18.0, color: Colors.grey),
          ),
          Text(
            '15',
            style: TextStyle(fontSize: 18.0),
          ),
        ]),
        Column(children: [
          Text(
            'Total',
            style: TextStyle(fontSize: 18.0, color: Colors.grey),
          ),
          Text(
            NumberFormat.currency(symbol: "\$", decimalDigits: 2)
                .format(orderLine.quantity * orderLine.price),
            style: TextStyle(fontSize: 18.0),
          ),
        ]),
        Icon(
          Icons.more_vert,
          size: 32.0,
          color: Colors.black,
        ),
      ]),
    );
  }
}
