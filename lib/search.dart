import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

final CollectionReference _products =
    FirebaseFirestore.instance.collection('stories');

Map<String, Color> colorMap = {
  'red': Colors.red,
  'green': Colors.green,
  'blue': Colors.blue,
  'purple': Colors.deepPurple,
  'orange': Colors.deepOrange,
  'teal': Colors.teal,
  'cyan': Colors.cyan,
  'indigo': Colors.indigo,
  'lime': Colors.lime
};

class Searched extends StatelessWidget {
  Searched({Key? key, required this.query}) : super(key: key);
  String query;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 10, 19),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _products.snapshots(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.hasData) {
            List<DocumentSnapshot> results = [];

            for (var documentSnapshot in streamSnapshot.data!.docs) {
              if (documentSnapshot['title']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase())) {
                results.add(documentSnapshot);
              }
            }

            if (results.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    var currentItem = results[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => Scaffold(
                              appBar: AppBar(
                                elevation: 0,
                                backgroundColor:
                                    Color.fromARGB(255, 29, 29, 29),
                              ),
                              body: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(40.0),
                                  child: ListView(
                                    children: [
                                      Text(
                                        currentItem['title'],
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 42,
                                        ),
                                      ),
                                      Text(
                                        'By: ${currentItem['by']}',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w100,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        'Topic: ${currentItem['topic']}',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w100,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(currentItem['story']),
                                      SizedBox(height: 87),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorMap[currentItem['color']],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentItem['title'],
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "- ${currentItem['by']}",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "${currentItem['topic']}",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return Center(
                child: Text(
                  'No results found.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
          }

          return Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 0, 10, 19),
            ),
          );
        },
      ),
    );
  }
}

class Search extends StatelessWidget {
  Search({Key? key});

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: GoogleFonts.poppins(color: Colors.white),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.green,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => Searched(
                  query: _searchController.text,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
