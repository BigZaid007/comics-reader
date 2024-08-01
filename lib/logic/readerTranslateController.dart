import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class TranslateImageController extends GetxController {
  // Function to extract text from an image URL
  Future<String> extractText(String imageUrl) async {
    try {
      if (!Uri.parse(imageUrl).isAbsolute) {
        throw Exception('Invalid URL');
      }

      // Log URL being processed
      print('Extracting text from URL: $imageUrl');

      // Download the image from the URL
      final http.Response response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to load image');
      }

      // Convert the image to bytes
      final Uint8List imageBytes = response.bodyBytes;

      // Convert bytes to InputImage
      final InputImage image = InputImage.fromFilePath(
        await _bytesToFile(imageBytes),
      );

      // Initialize the TextRecognizer
      final TextRecognizer textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);

      // Process the image and extract text
      final RecognizedText recognizedText =
          await textRecognizer.processImage(image);

      // Log the recognized text
      print('Recognized text: ${recognizedText.text}');

      // Return the recognized text
      return recognizedText.text;
    } catch (e) {
      // Handle errors
      print('Error extracting text: $e');
      return '';
    }
  }

  // Helper function to convert bytes to a temporary file
  Future<String> _bytesToFile(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/temp_image.jpg');
    await tempFile.writeAsBytes(bytes);
    return tempFile.path;
  }

  // Function to translate text to Arabic
  Future<String> translateText(String text) async {
    try {
      final translator = GoogleTranslator();

      // Log the text being translated
      print('Translating text: $text');
      final translation = await translator.translate(text, to: 'ar');

      // Log the translated text
      print('Translated text: ${translation.text}');

      return translation.text;
    } catch (e) {
      // Handle errors
      print('Error translating text: $e');
      return '';
    }
  }
}
