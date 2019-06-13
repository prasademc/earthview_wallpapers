import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import './imageDetails.dart';

class LandingPage extends StatefulWidget {
  @override
  State createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  final primaryColor = const Color(0xFF151026);
  Color gradientStart = const Color(0xFFEBEA6F);
  Color gradientEnd = const Color(0xFF12B5BA);
  List imageData = [];
  ScrollController _scrollController = new ScrollController();
  bool lastStatus = true;

  List shuffle(List items) {
    var random = new Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  Future<String> loadImageData() async {
    var jsonText = await rootBundle.loadString('assets/utils/config.json');

    setState(() {
      imageData = shuffle(json.decode(jsonText));
    });

    return 'success';
  }

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    this.loadImageData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFFFFFFFF),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Earthview Wallpapers',
                style: TextStyle(
                  color: isShrink
                      ? const Color(0xFFFBC012)
                      : const Color(0xFFDFDFDF),
                  fontSize: isShrink ? 24.0 : 12.0,
                ),
              ),
              background: Image.asset(
                'assets/images/appBarBg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Container(
                    color: const Color(0xFFFFFFFF),
                    child: new Padding(
                      padding: new EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      child: new GestureDetector(
                        child: new Card(
                          elevation: 1.0,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(6.0),
                          ),
                          child: new Container(
                            decoration: BoxDecoration(
                              gradient: new LinearGradient(
                                  colors: [gradientStart, gradientEnd],
                                  begin: const FractionalOffset(0.5, 0.0),
                                  end: const FractionalOffset(0.0, 0.5),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new ClipRRect(
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: imageData[index]['thumbUrl'],
                                  ),
                                  borderRadius: new BorderRadius.only(
                                    topLeft: new Radius.circular(3.0),
                                    topRight: new Radius.circular(3.0),
                                  ),
                                ),
                                new Padding(
                                  padding: new EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 9,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Text(
                                              imageData[index]['title'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .title,
                                            ),
                                            new Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0, right: 30.0),
                                              child: Text(
                                                imageData[index]['attribution'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Post(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new ImageDetailsPage(
                                    title: imageData[index]['title'],
                                    imgURL: imageData[index]['photoUrl'],
                                    downloadURL: imageData[index]
                                        ['downloadUrl']),
                          );
                          Navigator.of(context).push(route);
                        },
                      ),
                    ),
                  ),
              childCount: imageData.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0.0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 600),
          );
        },
        child: Icon(
          Icons.arrow_upward,
          color: const Color(0xFFFFFFFF),
        ),
        backgroundColor: const Color(0xFFFBC012),
      ),
    );
  }
}

class Post extends StatefulWidget {
  @override
  PostState createState() => new PostState();
}

class PostState extends State<Post> {
  bool liked = false;

  _likedPressed() {
    setState(() {
      liked = !liked;
    });
  }

  @override
  Widget build(BuildContext contaxt) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 30.0,
            height: 30.0,
            child: IconButton(
              icon: liked ? Icon(EvaIcons.heart) : Icon(EvaIcons.heartOutline),
              color: liked ? const Color(0xFFFBC012) : const Color(0xFFFFFFFF),
              onPressed: () => _likedPressed(),
            ),
          ),
        ],
      ),
    );
  }
}
