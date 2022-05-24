import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:stateful_affichage_film/add_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase flutter affichage film',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Center(
              child: Text("Movies",
                  style: TextStyle(
                      fontSize: 25,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold))),
        ),
        body: const MoviesInformations(),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Get.to(() => const AddPage());
          },
        ));
  }
}

class MoviesInformations extends StatefulWidget {
  const MoviesInformations({Key? key}) : super(key: key);

  @override
  State<MoviesInformations> createState() => _MoviesInformations();
}

class _MoviesInformations extends State<MoviesInformations> {
  final Stream<QuerySnapshot> _moviesStream =
      FirebaseFirestore.instance.collection('movies').snapshots();

  void addLike(String docID, int likes) {
    var newLikes = likes + 1;
    try {
      FirebaseFirestore.instance.collection("movies").doc(docID).update({
        'likes': newLikes,
      }).then((value) => print("Données à jour"));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return StreamBuilder<QuerySnapshot>(
      stream: _moviesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> movies =
                document.data()! as Map<String, dynamic>;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      SizedBox(
                          width: 100, child: Image.network(movies["poster"])),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(movies["name"],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const Text("Année de production"),
                              Text(movies['year'].toString()),
                              Row(
                                children: [
                                  for (final categorie in movies['categories'])
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Chip(
                                          backgroundColor: Colors.lightBlue,
                                          label: Text(categorie),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(Icons.favorite),
                                    iconSize: 20,
                                    onPressed: () {
                                      addLike(
                                          document.id,
                                          movies[
                                              'likes']); //document.id permet de recuperer l'id du document
                                    },
                                  ),
                                  Text(movies['likes'].toString())
                                ],
                              )
                            ],
                          )),
                    ],
                  )),
            );
          }).toList(),
        );
      },
    );
  }
}
