import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiselect/multiselect.dart';
import 'package:stateful_affichage_film/main.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final nameController = TextEditingController();
  final yearController = TextEditingController();
  final posterController = TextEditingController();
  List<String> categories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter des films"),
        elevation: 0,
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side:
                          const BorderSide(color: Colors.white30, width: 1.5)),
                  title: Row(
                    children: [
                      const Text("Nom: "),
                      Expanded(
                          child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: nameController,
                      ))
                    ],
                  )),
              const SizedBox(height: 20),
              ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side:
                          const BorderSide(color: Colors.white30, width: 1.5)),
                  title: Row(
                    children: [
                      const Text("Année: "),
                      Expanded(
                          child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: yearController,
                      ))
                    ],
                  )),
              const SizedBox(height: 20),
              ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side:
                          const BorderSide(color: Colors.white30, width: 1.5)),
                  title: Row(
                    children: [
                      const Text("Poster: "),
                      Expanded(
                          child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: posterController,
                      ))
                    ],
                  )),
              DropDownMultiSelect(
                onChanged: (List<String> x) {
                  setState(() {
                    categories = x;
                  });
                },
                options: const [
                  "Action",
                  "Science-fiction",
                  "Comedie",
                  "Drame",
                  "Aventure",
                  "Teenager"
                ],
                selectedValues: categories,
                whenEmpty: "Catégorie",
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  FirebaseFirestore.instance.collection('movies').add({
                    'name': nameController.value.text,
                    'year': yearController.value.text,
                    'poster': posterController.value.text,
                    'categories': categories,
                    'likes': 0,
                  });
                  Get.to(() => const HomePage());
                },
                child: const Text("Ajouter"),
              )
            ],
          )),
    );
  }
}
