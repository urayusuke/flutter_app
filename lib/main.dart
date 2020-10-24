import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Generated App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2196f3),
        accentColor: const Color(0xFF2196f3),
        canvasColor: const Color(0xFFfafafa),
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _message;
  static var _janken = <String>['グー', 'チョキ', 'パー'];

  @override
  void initState() {
    _message = 'ok.';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Name'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  _message,
                  style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto"),
                ),
              ),
              RawMaterialButton(
                fillColor: Colors.white,
                highlightColor: Colors.red,
                elevation: 10.0,
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Push me!",
                  style: TextStyle(
                      fontSize: 32.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto"),
                ),
                onPressed: buttonPressed,
              ),
            ]),
      ),
    );
  }

  void buttonPressed() {
    setState(() {
      _message = (_janken..shuffle()).first;
    });
  }
}
