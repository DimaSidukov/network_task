import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:network_task/Fruit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var dio = Dio();
  var baseUrl = "https://fruityvice.com/api/fruit/all";

  Future<Response> _requestFruits() async {
    var response = await dio.get(baseUrl);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: [
              OutlinedButton(
                  onPressed: () {
                    _requestFruits();
                  },
                  child: Text("Call method")),
              FutureBuilder(
                future: _requestFruits(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.none) {
                    return const Text("CHECK YOUR INTERNET CONNECTION ASAP!");
                  }
                  if (snapshot.hasError) {
                    return const Text("AN ERROR OCCURRED! CHECK URL CORRECTNESS");
                  }
                  if (snapshot.hasData) {
                    List<Fruit> fruits = List<Fruit>.from(
                        (jsonDecode(snapshot.data?.data) as Iterable)
                            .map((e) => Fruit.fromJson(e)));

                    return Expanded(
                        child: SizedBox(
                            width: double.infinity,
                            child: ListView.builder(
                                itemCount: fruits.length,
                                itemBuilder:
                                    (BuildContext context, int position) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 30),
                                              child: Text("genus",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ),
                                            Text(fruits
                                                    .elementAt(position)
                                                    .genus ??
                                                "empty")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 30),
                                              child: Text("name",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ),
                                            Text(fruits
                                                    .elementAt(position)
                                                    .name ??
                                                "empty")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 30),
                                              child: Text("family",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ),
                                            Text(fruits
                                                    .elementAt(position)
                                                    .family ??
                                                "empty")
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                })));
                  }
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CircularProgressIndicator(),
                  );
                },
              )
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
