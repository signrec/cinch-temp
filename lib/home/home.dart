import 'package:flutter/material.dart';

import '../camera/screen_takepicture.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: FloatingActionButton(
        onPressed: () {
          // DatabaseReference _database =
          //     FirebaseDatabase.instance.ref().child("test");
          // _database.set({
          //   "test": "test7",
          // });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TakePicture()),
          );
        },
        child: const Text('Home'),
      )),
    );
  }
}
