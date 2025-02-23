import 'package:dion_app/app.dart';
import 'package:dion_app/core/services/service_locator.dart';
import 'package:flutter/material.dart';

Future<void> main() async{
  setupLocator();
  runApp(const MyApp());
}


