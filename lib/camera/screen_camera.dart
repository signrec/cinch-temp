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
  CameraImage? cameraImage;

  late CameraController cameraController;
  @override
  void initState() {
    super.initState();
    loadmodel();
    initCamera();
  }

  @override
  void dispose() async {
    super.dispose();
    cameraController.stopImageStream();
    Tflite.close();
  }

  Future loadmodel() async {
    Tflite.close();
    await Tflite.loadModel(
        model: "assets/model.tflite", labels: "assets/model.txt");
  }

  initCamera() {
    cameraController =
        CameraController(widget.cameras![0], ResolutionPreset.max);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.startImageStream((imageFromStream) => {
              if (!isWorking)
                {isWorking = true, cameraImage = imageFromStream, runModel()}
            });
      });
    });
  }

  runModel() async {
    {
      var recognitions = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 1,
          threshold: 0.4,
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
          color: Colors.black,
          child: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    Center(
                      child: Container(
                          child: cameraImage == null
                              ? Container()
                              : CameraPreview(cameraController)),
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
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
