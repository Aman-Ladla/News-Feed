import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gods_creation_task/webLook.dart';
import 'package:http/http.dart';

class HomeScreen extends StatefulWidget {
  var data;
  HomeScreen(this.data);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var newsdata;
  static const url =
      'https://newsapi.org/v2/everything?q=tesla&from=2021-04-26&sortBy=publishedAt&apiKey=fbea42ac91de4284aca68af24ebcfa64';

  Future<dynamic> getData() async {
    Response response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      String data = response.body;
      var newsData = jsonDecode(data);
      return newsData;
    } else {
      print("something went wrong");
    }
  }

  @override
  void initState() {
    super.initState();
    newsdata = widget.data;
    //print(newsdata['articles'][0]['urlToImage']);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Color(0xffc75734),
          statusBarIconBrightness: Brightness.light),
    );
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return null;
      },
      child: Scaffold(
        backgroundColor: Color(0xfff4f0f0),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.dark,
          title: Text(
            'News Feed',
            textAlign: TextAlign.start,
          ),
          backgroundColor: Color(0xffff6b3d),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            newsdata = await getData();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return HomeScreen(newsdata);
            }));
            return Future.value(false);
          },
          child: ListView.builder(
            itemCount: widget.data['articles'].length,
            itemBuilder: (BuildContext ctx, int index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      //print(newsdata['articles'][index]['url']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return WebLook(newsdata['articles'][index]['url']);
                          },
                        ),
                      );
                    },
                    child: Container(
                      // width: MediaQuery.of(context).size.width * 0.9,
                      // height: MediaQuery.of(context).size.height * 0.2,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: newsdata['articles'][index]
                                                  ['urlToImage'] !=
                                              "null" &&
                                          newsdata['articles'][index]
                                                  ['urlToImage'] !=
                                              null
                                      ? Image(
                                          image: NetworkImage(
                                              //articles[0].urlToImage
                                              newsdata['articles'][index]
                                                  ['urlToImage']),
                                        )
                                      : Text(
                                          'Image not available',
                                          textAlign: TextAlign.center,
                                        ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Expanded(
                                  child: Text(
                                    newsdata['articles'][index]['title'],
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
