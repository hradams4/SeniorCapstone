/**
 * This class defines Order-type objects.
 * 
 * @author Nicholas Holtman
 * @version November 17, 2022
 */

import 'package:speedy_snacks/models/order_line_model.dart';

class Order {
  String orderId;
  String name;
  String status;
  String deliveryCo;
  String orderTime;
  List<OrderLine> orderLines;

/*  int modifierId;
  double total;
*/
  Order(
    this.orderId,
    this.name,
    this.status,
    this.deliveryCo,
    this.orderTime,
    this.orderLines,
/*      this.modifierId,
      this.total,
*/
  ) {}
}
