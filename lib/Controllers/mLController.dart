import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class MLController extends GetxController {
  Interpreter? interpreter;
  List<String> labels = [];

  @override
  void onInit() {
    super.onInit();
    loadModelAndLabels();
  }


  Future<void> loadModelAndLabels() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/model/fruit_classifier.tflite');
      if (interpreter == null) {
        print("Unable to load interpreter");
        return;
      }

      final String labelsData = await rootBundle.loadString('assets/model/labels.txt');
      labels = labelsData.split('\n');
      print("Loaded labels: $labelsData");

      print("Model and labels loaded successfully");
    } catch (e) {
      print("Failed to load model or labels: $e");
    }
  }


  Future<dynamic> processImage(File? image) async {
    // Print the values of image and interpreter before the condition
    print("Image: $image");
    print("Interpreter: $interpreter");
    try {
      print(labels.length);
      var inputImage = await convertImageToTensor(image!);
      var output = Float32List(labels.length);
      print("Output tensor before inference: $output");
      interpreter!.run(inputImage, output);
      print("Output tensor after inference: $output");

      var index = argMax(output, labels.length)[0];
      print("index $index");
      if (index >= 0 && index < labels.length) {
        print("$index: ${labels[index]}");
        return labels[index];
      } else {
        print('No label found');
        return null;
      }
    } catch (e) {
      print("Error processing image: $e");
      // Return the output tensor or index if an error occurs
      return e.toString(); // Return the error for debugging
    }
  }

  List<int> argMax(Float32List list, int batchSize) {
    var indices = <int>[];
    int classes = list.length ~/ batchSize; // Calculate the number of classes per batch

    for (var i = 0; i < batchSize; i++) {
      var start = i * classes;
      var end = (i + 1) * classes;

      var sublist = list.sublist(start, end);
      var maxIndex = sublist.indexOf(sublist.reduce((currMax, element) => element > currMax ? element : currMax));

      indices.add(maxIndex);
    }

    return indices;
  }
  Future<Float32List> convertImageToTensor(File? image) async {
    var bytes = await image?.readAsBytes();
    var decodedImage = img.decodeImage(bytes!);
    var resizedImage = img.copyResize(decodedImage!, width: 256, height: 256); // Ensure this matches your model's expected input size
    var imageData = resizedImage.getBytes();

    // Calculate the size of the input list based on the image dimensions and channels
    int inputSize = labels.length; // Adjust the dimensions and channels as needed
    Float32List input = Float32List(inputSize);

    for (int i = 0; i < 256 * 256; ++i) {
      final int pixel = imageData[i * 3];
      input[i * 3] = ((pixel >> 16) & 0xFF).toDouble();
      input[i * 3 + 1] = ((pixel >> 8) & 0xFF).toDouble();
      input[i * 3 + 2] = (pixel & 0xFF).toDouble();
    }
    print(input);
    processImage(image);
    return input;
  }

}
