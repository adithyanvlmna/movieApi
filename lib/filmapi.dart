import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Filmapi extends StatefulWidget {
  const Filmapi({super.key});

  @override
  State<Filmapi> createState() => _FilmapiState();
}

class _FilmapiState extends State<Filmapi> {
  var searchItem = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("i works");
    final provider = Provider.of<Userprovider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "H-Movies",
          style: TextStyle(color: Colors.black),
        ),
        leading: const CircleAvatar(
          radius: 28,
          backgroundColor: Colors.black,
          backgroundImage: NetworkImage(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRkbZeo0bzL3hONL9wJCzrk-o5DelkOXW6Xnw&s"),
        ),
        backgroundColor: const Color.fromARGB(255, 198, 242, 199),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
                controller: searchItem,
                elevation: WidgetStatePropertyAll(20),
                leading: IconButton(
                  onPressed: () async {
                    String data = searchItem.text;
                    provider.getusers(data);
                    searchItem.clear();
                  },
                  icon: const Icon(Icons.search),
                  color: Colors.black,
                ),
                hintText: "Search",
                hintStyle: const WidgetStatePropertyAll(
                    TextStyle(color: Colors.black)),
                backgroundColor: const WidgetStatePropertyAll(
                    Color.fromARGB(255, 198, 242, 199)),
                onTap: () {}),
          ),
          Consumer<Userprovider>(builder: (context, data, _) {
            return Expanded(
                child: GridView.builder(
                    itemCount: data.userGetter.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.9, crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.all(5.0),
                        height: 400,
                        width: 300,
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 198, 242, 199)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                data.userGetter[index].title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 100,
                              width: 280,
                              child:
                                  Image.network(data.userGetter[index].poster),
                            ),
                            Text(
                              data.userGetter[index].year,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              data.userGetter[index].imdbID,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              data.userGetter[index].type,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }));
          })
        ],
      ),
    );
  }
}

class User {
  final String title;
  final String year;
  final String imdbID;
  final String type;
  final String poster;
  User(
      {required this.title,
      required this.year,
      required this.imdbID,
      required this.type,
      required this.poster});
  factory User.from(Map<String, dynamic> userMap) {
    return User(
        title: userMap["Title"],
        year: userMap["Year"],
        imdbID: userMap["imdbID"],
        type: userMap["Type"],
        poster: userMap["Poster"]);
  }
}

class Userprovider extends ChangeNotifier {
  List<User> users = [];
  List<User> get userGetter => users;
  Future<void> getusers(String data) async {
    final respons = await http.get(Uri.parse("c"));
    print(respons);
    List<dynamic> decoded = jsonDecode(respons.body)["Search"];
    List<User> finalrespons = decoded
        .map((mapdata) => User.from(mapdata as Map<String, dynamic>))
        .toList();
    users = finalrespons;
    notifyListeners();
  }
}
