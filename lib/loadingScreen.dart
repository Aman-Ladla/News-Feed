import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';

import 'homeScreen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  static const url =
      'https://newsapi.org/v2/everything?q=tesla&from=2021-04-26&sortBy=publishedAt&apiKey=fbea42ac91de4284aca68af24ebcfa64';

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    Response response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      String data = response.body;
      var newsData = jsonDecode(data);
      // print(newsData['articles'][0]['title']);
      // print(newsData['articles'].length);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return HomeScreen(newsData);
      }));
    } else {
      print("something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Color(0xffc75734),
          statusBarIconBrightness: Brightness.light),
    );
    return Scaffold(
      body: Center(
        child: SpinKitWave(
          color: CupertinoColors.black,
          size: 100.0,
        ),
      ),
    );
  }
}
