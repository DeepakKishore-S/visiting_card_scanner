import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'; // Importing Google ML Kit for text recognition
import 'dart:io';
import 'package:visiting_card_scanner/local_db.dart'; // Local database helper for saving card details
import 'package:visiting_card_scanner/saved_cards.dart'; // Importing saved cards page

class CardScannerPage extends StatefulWidget {
  const CardScannerPage({super.key});

  @override
  _CardScannerPageState createState() => _CardScannerPageState();
}

class _CardScannerPageState extends State<CardScannerPage> {
  final picker = ImagePicker(); // Initializing image picker for camera access
  File? _image; // To store the selected image
  String extractedText = ''; // To store extracted text from the image
  bool isscanned = false; // Flag to check if card has been scanned
  TextEditingController controller = TextEditingController();

  // Function to pick an image from the camera and extract text
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await extractText(
          pickedFile.path); // Extracting text from the captured image
    }
  }

  // Function to extract text from the selected image using Google ML Kit
  Future<void> extractText(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);

    String cardDetails = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        cardDetails += '${line.text}\n';
      }
    }
    textRecognizer.close();

    setState(() {
      extractedText = cardDetails;
      isscanned = true;
    });
  }

  // Function to show a dialog for saving card details
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Card Details'),
          content: TextField(
            decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.black38),
                hintText: "Card Name",
                border: OutlineInputBorder()),
            controller: controller,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                saveCardDetails(
                    extractedText); // Save card details to the local database
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Function to save card details to the local database
  Future<void> saveCardDetails(String details) async {
    final DatabaseHelper dbHelper =
        DatabaseHelper(); // Initializing database helper
    await dbHelper.insertCard({
      'details': details,
      "name": controller.text
    }); // Inserting card details into the database
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Card details saved!'))); // Show confirmation message
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Visiting Card'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Display the image if it has been captured, otherwise show a placeholder
              _image != null
                  ? Image.file(_image!)
                  : Container(height: 200, color: Colors.grey[300]),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed:
                        pickImage, // Button to capture image and scan card
                    child: const Text('Scan Card'),
                  ),
                  if (extractedText
                      .isNotEmpty) // Show 'Save Card' button only if text is extracted
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: () async {
                        await _showMyDialog(); // Show dialog to save card details
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SavedCardsPage()), // Navigate to saved cards page
                          (route) => false,
                        );
                      },
                      child: const Text('Save Card'),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              if (extractedText.isNotEmpty)
                const Text(
                    'Extracted Text:'), // Display extracted text if available
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  !isscanned
                      ? "Scan your visiting card to get details" // Message before scanning
                      : extractedText.isEmpty
                          ? "No text on scanned card or \nScan again to take clear photo with enough light and clarity" // Message if scan fails
                          : extractedText, // Display extracted text
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
