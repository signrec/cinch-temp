import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class OpenCamera extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const OpenCamera({this.cameras, Key? key}) : super(key: key);

  @override
  _OpenCameraState createState() => _OpenCameraState();
}

class _OpenCameraState extends State<OpenCamera> {
  bool isWorking = false;
  String output = "";
  CameraImage? imgCamera;

  late CameraController cameraController;
  @override
  void initState() {
    super.initState();
    loadmodel();
  }

  @override
  void dispose() async {
    super.dispose();
    await Tflite.close();
    cameraController.dispose();
  }

  loadmodel() async {
    await Tflite.loadModel(
        model: "assets/model.tflite", labels: "assets/model.txt");
  }

  initCamera() {
    cameraController =
        CameraController(widget.cameras![0], ResolutionPreset.medium);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.startImageStream((imageFromStream) => {
              if (!isWorking)
                {isWorking = true, imgCamera = imageFromStream, runModel()}
            });
      });
    });
  }

  runModel() async {
    {
      var recognitions = await Tflite.runModelOnFrame(
          bytesList: imgCamera!.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: imgCamera!.height,
          imageWidth: imgCamera!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          // rotation: 90,
          numResults: 2,
          threshold: 0.1,
          asynch: true);
      output = "";
      recognitions?.forEach((response) {
        output += response["label"];
      });

      setState(() {
        output;
      });
      isWorking = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
            body: Container(
          color: Colors.blue,
          child: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    Center(
                      child: Container(
                        color: Colors.black,
                        height: 600,
                        width: 360,
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                          onPressed: (() => {initCamera()}),
                          child: imgCamera == null
                              ? Container(
                                  color: const Color(0xff121421),
                                  height: 400,
                                  width: 300,
                                  child: const Icon(Icons.start, size: 40))
                              : AspectRatio(
                                  aspectRatio: 3 / 4,
                                  child: CameraPreview(cameraController))),
                    )
                  ],
                ),
                Center(
                  child: Container(
                      margin: const EdgeInsets.all(10),
                      child: SingleChildScrollView(
                          child: Text(output,
                              style: const TextStyle(
                                  backgroundColor: Colors.red,
                                  fontSize: 30.0,
                                  color: Colors.white),
                              textAlign: TextAlign.center))),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
