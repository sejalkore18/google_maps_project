import 'package:flutter/material.dart';
import 'package:google_maps_project/app/presentation/show_map_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Google Maps Project',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ShowMapWidget(),
        debugShowCheckedModeBanner: false);
  }
}
