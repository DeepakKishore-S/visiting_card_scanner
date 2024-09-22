import 'package:flutter/material.dart';
import 'package:visiting_card_scanner/local_db.dart';
import 'package:visiting_card_scanner/scanning_card.dart';

// SavedCardsPage is a StatefulWidget to maintain the state when displaying saved cards
class SavedCardsPage extends StatefulWidget {
  const SavedCardsPage({super.key});

  @override
  State<SavedCardsPage> createState() => _SavedCardsPageState();
}

class _SavedCardsPageState extends State<SavedCardsPage> {
  final DatabaseHelper dbHelper =
      DatabaseHelper(); // Initializing database helper to interact with local DB

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visiting Card Scanner'),
      ),
      // FloatingActionButton used to navigate to the CardScannerPage for scanning new cards
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const CardScannerPage()), // Navigating to the CardScannerPage
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // FutureBuilder to fetch saved cards from the database asynchronously
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: dbHelper
              .fetchCards(), // Calling the method to fetch cards from local DB
          builder: (context, snapshot) {
            // While the data is still loading, display a loading spinner
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // If data is successfully retrieved and not empty, display the list of cards
            else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot
                    .data!.length, // Setting the number of items in the list
                itemBuilder: (context, index) {
                  final card = snapshot.data![index]; // Access each card data
                  return Card(
                    child: ExpansionTile(
                      title: Text(
                        card["name"]
                            .toString()
                            .toUpperCase(), // Display the card's name in uppercase
                        style: const TextStyle(fontSize: 20),
                      ),
                      childrenPadding: const EdgeInsets.all(12),
                      children: [
                        Text(
                            card['details']), // Display additional card details
                        // IconButton to delete the card
                        IconButton(
                            onPressed: () async {
                              await dbHelper
                                  .deleteCard(card["id"]
                                      .toString()) // Deleting the card from the local DB
                                  .then(
                                (value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Card Deleted successfully!'))); // Show success message after deletion
                                  setState(
                                      () {}); // Refresh the UI to reflect deletion
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  );
                },
              );
            }
            // If there are no saved cards, display a message
            else {
              return const Center(
                  child: Text(
                      'No cards saved yet.')); // Display message when no data is available
            }
          },
        ),
      ),
    );
  }
}
