/**
 * This class defines individual order lines for Order-type objects.
 * 
 * @author Nicholas Holtman
 * @version November 22, 2022
 */

import 'package:flutter/material.dart';

class OrderLine {
  int sqlOrderId;
  String orderLineId;
  int productId;
  String productName;
  double quantity;
  String productPictureUrl; // updated field to store image url
  double price;
  String modifier;
  int modifierId;
  late TextEditingController quantityController;

  OrderLine(
    this.sqlOrderId,
    this.orderLineId,
    this.productId,
    this.productName,
    this.quantity,
    this.price,
    this.modifier,
    this.modifierId,
    this.productPictureUrl, // added image url as parameter
  ) {
    quantityController = TextEditingController();
  }
}
