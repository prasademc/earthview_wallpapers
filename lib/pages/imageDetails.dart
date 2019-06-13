import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class ImageDetailsPage extends StatefulWidget {
  final String title;
  final String imgURL;
  final String downloadURL;

  ImageDetailsPage({Key key, this.title, this.imgURL, this.downloadURL})
      : super(key: key);

  @override
  State createState() => ImageDetailsPageState();
}

class ImageDetailsPageState extends State<ImageDetailsPage> {
  static const platform = const MethodChannel('wallpaper');
  bool downloading = false;
  var progressString = "";

  Color gradientStart = Colors.deepPurple[700];
  Color gradientEnd = Colors.purple[500];

  @override
  void initState() {
    super.initState();
  }

  Future<void> downloadWallpaper(url, title) async {
    Dio dio = Dio();

    try {
      var dir = await getApplicationDocumentsDirectory();

      await dio.download(url, "${dir.path}/${title}.jpg",
          onReceiveProgress: (rec, total) {
        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + '%';
        });
      });
    } catch (err) {
      print(err);
    }

    setState(() {
      downloading = false;
      progressString = 'Finish';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('${widget.title}'),
        backgroundColor: const Color(0xFF171432),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                EvaIcons.homeOutline,
                color: Color(0xFFFBC012),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              child: ExtendedImage.network(
                widget.imgURL,
                fit: BoxFit.fitHeight,
                enableLoadState: true,
                mode: ExtendedImageMode.Gesture,
                gestureConfig: GestureConfig(
                    minScale: 0.9,
                    animationMinScale: 0.7,
                    maxScale: 3.0,
                    animationMaxScale: 3.5,
                    speed: 1.0,
                    inertialSpeed: 100.0,
                    initialScale: 1.0,
                    inPageView: false),
              ),
            ),
            flex: 7,
          ),
          Expanded(
            child: Container(
              child: Center(
                  child: downloading
                      ? Container(
                          height: 80.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                            gradient: new LinearGradient(
                                colors: [gradientStart, gradientEnd],
                                begin: const FractionalOffset(0.5, 0.0),
                                end: const FractionalOffset(0.0, 0.5),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          child: Card(
                            color: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircularProgressIndicator(
                                  backgroundColor: const Color(0xFFFFFFFF),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Downloading Wallpaper: $progressString',
                                  style: Theme.of(context).textTheme.caption,
                                )
                              ],
                            ),
                          ),
                        )
                      : Text('')),
            ),
            flex: 3,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          downloadWallpaper(widget.downloadURL, widget.title);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              EvaIcons.codeDownload,
              color: Color(0xFFFFFFFF),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFBC012),
      ),
    );
  }
}
