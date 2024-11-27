import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Randy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const futurePage(),
    );
  }
}

class futurePage extends StatefulWidget {
  const futurePage({super.key});

  @override
  State<futurePage> createState() => _futurePageState();
}

class _futurePageState extends State<futurePage> {
  String result = '';
  Future<Response> getData() async {
    const authority = 'www.googleapis.com';
    const path = '/books/v1/volumes/junbDwAAQBAJ';
    Uri url = Uri.https(authority, path);
    return http.get(url);
  }

  Future<int> returnOneAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 1;
  }

  Future<int> returnTwoAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 2;
  }

  Future<int> returnThreeAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 3;
  }

  Future count() async {
    int total = 0;
    total = await returnOneAsync();
    total += await returnTwoAsync();
    total += await returnThreeAsync();
    setState(() {
      result = total.toString();
    });
  }

  late Completer completer;

  Future getNumber() {
    completer = Completer<int>();
    calculate();
    return completer.future;
  }

  Future calculate() async {
    await Future.delayed(const Duration(seconds: 5));
    completer.complete(42);
    // throw Exception();
  }

  cacth(_) {
    completer.completeError({});
  }

  void returnFG() {
    final futures = Future.wait<int>([
      returnOneAsync(),
      returnTwoAsync(),
      returnThreeAsync(),
    ]);

    futures.then((List<int> values) {
      int total = values.fold(0, (sum, element) => sum + element);
      setState(() {
        result = total.toString();
      });
    }).catchError((error) {
      setState(() {
        result = "Error: $error";
      });
    });
  }

  Future returnerror() async {
    await Future.delayed(const Duration(seconds: 2));
    throw Exception('something terrible happend!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'back from the future',
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                returnFG();
                returnerror().then((value) {
                  setState(() {
                    result = 'succes';
                  });
                }).catchError((onError) {
                  setState(() {
                    result = onError.toString();
                  });
                }).whenComplete(() => print('complete'));
                // count();
                // setState(() {});
                // getData().then((value) {
                //   result = value.body.toString().substring(0, 450);
                //   setState(() {});
                // }).catchError((_) {
                //   result = 'an error occurred';
                //   setState(() {});
                // });

                // getNumber().then((value) {
                //   setState(() {
                //     result = value.toString();
                //   });
                // });

                // getNumber().then((value) {
                //   setState(() {
                //     result = value.toString();
                //   });
                // }).catchError((e) {
                //   result = 'An error occurred';
                // });
              },
              child: const Text('GO!'),
            ),
            const Spacer(),
            Text(result),
            const Spacer(),
            const CircularProgressIndicator(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
