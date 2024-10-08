
# Visiting Card Scanner

A Flutter-based mobile application that allows users to scan and store visiting cards. The app uses Google ML Kit's text recognition technology to extract text from images of visiting cards and stores the information in a local SQLite database.

## Features

- **Scan Visiting Cards**: Capture an image of a visiting card using the device's camera.
- **Extract Text**: Uses Google ML Kit to recognize and extract text from the card image.
- **Save Details**: Store the extracted details, along with a card name, in a local SQLite database.
- **View Saved Cards**: View a list of all scanned cards and their details.
- **Delete Cards**: Remove any card from the saved cards list.

## Tech Stack

- **Flutter**: Frontend framework for building the app UI.
- **Google ML Kit**: For text recognition and extracting text from images.
- **Sqflite**: Local SQLite database for storing scanned card details.
- **Image Picker**: For capturing images using the device's camera.

## Installation

To run this project locally, follow these steps:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/DeepakKishore-S/visiting_card_scanner.git
   cd visiting_card_scanner
   ```

2. **Install Flutter dependencies:**
   Make sure you have Flutter installed. Then run the following command to get all required packages:
   ```bash
   flutter pub get
   ```

3. **Configure Google ML Kit:**
   - Add the required dependencies for Google ML Kit in the `pubspec.yaml` file:
     ```yaml
     dependencies:
       google_mlkit_text_recognition: ^0.6.0 # or latest version
     ```
   - Follow the official setup guide for [Google ML Kit](https://developers.google.com/ml-kit) for both Android and iOS.

4. **Run the app:**
   Connect your device or start an emulator, and run the app:
   ```bash
   flutter run
   

## How It Works

1. **Scan a Visiting Card**:  
   Users can press the floating action button to scan a new visiting card. The app will open the camera, allowing the user to capture an image of the card.

2. **Extract Text from the Card**:  
   Once the image is captured, the app uses Google ML Kit to recognize and extract text from the card image.

3. **Save Card Details**:  
   After extracting the text, the user can enter a name for the card and save the details to a local SQLite database.

4. **View and Delete Saved Cards**:  
   The user can view a list of all saved cards and their details. They can also delete any card by pressing the delete icon.

## Project Structure

```
lib/
├── local_db.dart         # Handles the SQLite database interactions
├── main.dart             # Entry point for the application
├── saved_cards.dart      # Displays a list of saved cards
└── scanning_card.dart    # Allows users to scan and save new visiting cards
```

## Dependencies

This project uses the following dependencies:

- **flutter**: `^3.x.x`
- **google_mlkit_text_recognition**: For text recognition and OCR.
- **sqflite**: For managing local database storage.
- **image_picker**: For capturing images from the camera.
- **path_provider**: For accessing the app's document directory.

You can install these dependencies by running:

```bash
flutter pub get

