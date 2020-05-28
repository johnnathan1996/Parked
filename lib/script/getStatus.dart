import 'package:flutter/material.dart';

getStatus(int status) {
    switch (status) {
      case 1:
        return Icon(Icons.access_time, color: Colors.orange);
      case 0:
        return Icon(Icons.close, color: Colors.red);
      case 2:
        return Icon(Icons.check, color: Colors.green);
      default:
        return Container();
    }
  }

  getStatusText(int status) {
    switch (status) {
      case 1:
        return "En attente";
      case 0:
        return "refuser";
      case 2:
        return "Accepter";
      default:
        return "";
    }
  }