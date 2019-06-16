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

  Color gradientStart = const Color(0xFFEBEA6F);
  Color gradientEnd = const Color(0xFF12B5BA);

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
        title: new Text(
          '${widget.title}',
          style: TextStyle(color: const Color(0xFFFBC012)),
        ),
        backgroundColor: const Color(0xFFFFFFFF),
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
      body: new Stack(
        children: <Widget>[
          new Positioned.fill(
            child: new ExtendedImage.network(
              widget.imgURL,
              fit: BoxFit.contain,
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
                inPageView: false,
              ),
            ),
          ),
          Center(
            child: downloading
                ? Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          child: CircularProgressIndicator(),
                          height: 50.0,
                          width: 50.0,
                        ),
                        SizedBox(
                            child: Text(
                          'Downloading Wallpaper: $progressString',
                          style: Theme.of(context).textTheme.caption,
                        ))
                      ],
                    ),
                  )
                : Text(''),
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
