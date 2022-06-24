import 'package:cinch/camera/screen_camera.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:google_fonts/google_fonts.dart';

class TakePicture extends StatefulWidget {
  const TakePicture({
    Key? key,
  }) : super(key: key);

  @override
  _TakePictureState createState() => _TakePictureState();
}

class _TakePictureState extends State<TakePicture> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await availableCameras().then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OpenCamera(
                              cameras: value,
                            ),
                          ),
                        ));
                  },
                  child: Text(
                    "Open Camera",
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
