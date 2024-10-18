import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, SystemUiOverlayStyle;
import 'package:internet_file/internet_file.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    _setSystemUIOverlayStyle();
  }

  Brightness get platformBrightness =>
      MediaQueryData.fromView(WidgetsBinding.instance.window)
          .platformBrightness;

  void _setSystemUIOverlayStyle() {
    if (platformBrightness == Brightness.light) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.grey[50],
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.grey[850],
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Epub demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
        ),
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  EpubController? _epubReaderController;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    _epubReaderController?.dispose();
    super.dispose();
  }

  getData() async {
    _epubReaderController = EpubController(
      document: EpubDocument.openData(
        await InternetFile.get(
          // 'https://firebasestorage.googleapis.com/v0/b/freetrip-dev.appspot.com/o/Biet%20Thu%20Cua%20Nguoi%20Da%20Khuat%20-%20_638647769440306850.epub?alt=media&token=3f65e39d-e16e-4d12-a808-ada0f9a35597',
          'https://firebasestorage.googleapis.com/v0/b/freetrip-dev.appspot.com/o/New-Findings-on-Shirdi-Sai-Baba.epub?alt=media&token=b4f1e3c8-1cac-4c1f-a2bd-cd77c8670473',
        ),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: _epubReaderController != null
              ? EpubViewActualChapter(
                  controller: _epubReaderController!,
                  builder: (chapterValue) => Text(
                    chapterValue?.chapter?.Title?.replaceAll('\n', '').trim() ??
                        '',
                    textAlign: TextAlign.start,
                  ),
                )
              : null,
        ),
        drawer: _epubReaderController != null
            ? Drawer(
                child:
                    EpubViewTableOfContents(controller: _epubReaderController!),
              )
            : null,
        body: _epubReaderController != null
            ? EpubView(
                builders: EpubViewBuilders<DefaultBuilderOptions>(
                  options: const DefaultBuilderOptions(
                    textStyle: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  chapterDividerBuilder: (_) => const Divider(),
                ),
                controller: _epubReaderController!,
              )
            : SizedBox(),
      );
}
