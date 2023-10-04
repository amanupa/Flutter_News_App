import 'dart:convert';
//import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restapiapp/models.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var data;

  Future<NewsModel> getData() async {
    final getRequest = await http.get(Uri.parse(
        "https://newsapi.org/v2/everything?q=tesla&from=2023-09-03&sortBy=publishedAt&apiKey=db7a8e75ab04413d8d1516433aeec44e"));
    if (getRequest.statusCode == 200) {
      data = jsonDecode(getRequest.body);
      return NewsModel.fromJson(data);
    }
    return NewsModel.fromJson(data);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getData(),
              builder: (context, AsyncSnapshot<NewsModel> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    child: ListView.builder(
                      itemCount: snapshot.data!.articles.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            color: const Color.fromARGB(255, 9, 245, 221)
                                .withOpacity(0.9),
                            elevation: 8,
                            child: ListTile(
                              leading: Text(snapshot
                                  .data!.articles[index].source.name
                                  .toString()),
                              title: Text(snapshot.data!.articles[index].title
                                  .toString()),
                              subtitle: Text(
                                  data["articles"][index]["author"].toString()),
                              trailing: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                child: Image(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(data["articles"][index]
                                            ["urlToImage"]
                                        .toString())),
                              ),
                            ));
                      },
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
