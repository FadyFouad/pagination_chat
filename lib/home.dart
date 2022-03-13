import 'dart:async';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

/*
╔═══════════════════════════════════════════════════╗
║ Created by Fady Fouad on 3/13/2022 at 10:36 AM.   ║
║═══════════════════════════════════════════════════║
║ fady.fouad.a@gmail.com.                           ║
╚═══════════════════════════════════════════════════╝
*/


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  createState() =>  HomeState();
}

class HomeState extends State<Home> {

  ScrollController? controller;
  final _all = <WordPair>[];
  final _saved =  Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  GlobalKey<ScaffoldState> scaffoldKey =  GlobalKey<ScaffoldState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _all.addAll(generateWordPairs().take(20));
    controller =  ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  void _scrollListener() {
    if (controller!.position.pixels == controller!.position.maxScrollExtent) {
      startLoader();
    }
  }

  void startLoader() {
    setState(() {
      isLoading = !isLoading;
      fetchData();
    });
  }

  fetchData() async {
    var _duration = const Duration(seconds: 2);
    return  Timer(_duration, onResponse);
  }

  void onResponse() {
    setState(() {
      isLoading = !isLoading;
      _all.addAll(generateWordPairs().take(20));
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: scaffoldKey,
      appBar:  AppBar(
        title: const Text(
          "List load more example",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body:  Stack(
        children: <Widget>[
          _buildSuggestions(),
          _loader(),
        ],
      ),
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return  Column(
      children: <Widget>[
         ListTile(
          title:  Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
          trailing:  Icon(
            alreadySaved ? Icons.check : Icons.check,
            color: alreadySaved ? Colors.deepOrange : null,
          ),
          onTap: () {
            setState(() {
              if (alreadySaved) {
                _saved.remove(pair);
              } else {
                _saved.add(pair);
              }
            });
          },
        ),
         const Divider(),
      ],
    );
  }

  Widget _buildSuggestions() {
    return  ListView.builder(
         reverse: true,
        padding: const EdgeInsets.all(16.0),
        // The itemBuilder callback is called once per suggested word pairing,
        // and places each suggestion into a ListTile row.
        // For even rows, the function adds a ListTile row for the word pairing.
        // For odd rows, the function adds a Divider widget to visually
        // separate the entries. Note that the divider may be difficult
        // to see on smaller devices.
        controller: controller,
        itemCount: _all.length,
        itemBuilder: (context, i) {
          // Add a one-pixel-high divider widget before each row in theListView.
          return _buildRow(_all[i]);
        });
  }

  Widget _loader() {
    return isLoading
        ?  const Align(
      child: SizedBox(
        width: 70.0,
        height: 70.0,
        child:   Padding(
            padding: EdgeInsets.all(5.0),
            child:  Center(child:  CircularProgressIndicator())),
      ),
      alignment: FractionalOffset.topCenter,
    )
        : const SizedBox(
      width: 0.0,
      height: 0.0,
    );
  }
}
