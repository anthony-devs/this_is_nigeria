import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:this_is_nigeria/search.dart';
import 'package:this_is_nigeria/stories.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Today's Happenings",
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: "Today's Happenings"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isSearching = true;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 0, 10, 19),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Padding(
            padding: const EdgeInsets.all(18.0),
            child: isSearching
                ? Text('Stories',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white))
                : Search(),
          ),
          leading: isSearching
              ? IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isSearching = !isSearching;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      isSearching = !isSearching;
                    });
                  }),
          elevation: 0,
        ),
        body: Center(
          child: ListView(
            children: [
              SizedBox(
                height: 50,
              ),
              Stories(),
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
