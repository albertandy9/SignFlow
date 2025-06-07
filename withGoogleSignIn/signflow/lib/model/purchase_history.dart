import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class PurchaseHistoryItem {
  final String date;
  final String productName;
  final String type;

  PurchaseHistoryItem({
    required this.date,
    required this.productName,
    required this.type,
  });

  factory PurchaseHistoryItem.fromJson(Map<String, dynamic> json) {
    String formattedDate;
    final Timestamp? createdAtTimestamp = json['createdAt'] as Timestamp?;

    if (createdAtTimestamp != null) {
      formattedDate = DateFormat(
        'dd-MM-yyyy HH:mm',
      ).format(createdAtTimestamp.toDate());
    } else {
      formattedDate = json['date'] as String? ?? 'Unknown Date';
      debugPrint(
        'Warning: createdAt not found or not Timestamp in purchase data. Data: $json',
      );
    }

    return PurchaseHistoryItem(
      date: formattedDate,
      productName: json['productName'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'productName': productName, 'type': type};
  }
}
