import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Stories extends StatefulWidget {
  Stories({Key? key});

  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  Map<String, Color> colorMap = {
    'red': Colors.red,
    'green': Colors.green,
    'blue': Colors.blue,
    'purple': Colors.deepPurple,
    'orange': Colors.deepOrange,
    'teal': Colors.teal,
    'cyan': Colors.cyan,
    'indigo': Colors.indigo,
    'lime': Colors.lime,
  };

  @override
  Widget build(BuildContext context) {
    final CollectionReference _products =
        FirebaseFirestore.instance.collection('stories');

    return StreamBuilder(
      stream: _products.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final itemWidth = (constraints.maxWidth - 0) / 3;
                return SingleChildScrollView(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: itemWidth / itemWidth,
                    ),
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      final title = documentSnapshot['title'].toString();
                      final titleLength = title.length;
                      final textScaleFactor =
                          MediaQuery.of(context).textScaleFactor;
                      final titleStyle = GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18 * textScaleFactor,
                        color: Colors.white,
                      );
                      final byStyle = GoogleFonts.poppins(
                        fontWeight: FontWeight.w200,
                        fontSize: 12 * textScaleFactor,
                        color: Colors.black,
                      );
                      final topicStyle = GoogleFonts.poppins(
                        fontWeight: FontWeight.w300,
                        fontSize: 14 * textScaleFactor,
                        color: Colors.black,
                      );

                      return GestureDetector(
                        onTap: () {
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => Scaffold(
                                appBar: AppBar(
                                  elevation: 0,
                                  backgroundColor:
                                      colorMap[documentSnapshot['color']],
                                ),
                                body: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(40.0),
                                    child: ListView(
                                      children: [
                                        Text(
                                          title,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 42 * textScaleFactor,
                                          ),
                                        ),
                                        Text(
                                          'By: ${documentSnapshot['by']}',
                                          style: byStyle,
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          'Topic: ${documentSnapshot['topic']}',
                                          style: topicStyle,
                                        ),
                                        Text(
                                          documentSnapshot['story'],
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 18 * textScaleFactor,
                                          ),
                                        ),
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
                            borderRadius: BorderRadius.circular(10),
                            color: colorMap[documentSnapshot['color']],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                LimitedBox(
                                  maxHeight: 40,
                                  child: Text(
                                    title,
                                    style: titleStyle,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  "- ${documentSnapshot['by']}",
                                  style: byStyle,
                                ),
                                Text(
                                  "${documentSnapshot['topic']}",
                                  style: topicStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
