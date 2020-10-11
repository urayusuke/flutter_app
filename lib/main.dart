import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final title = 'Flutterサンプル';

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      home: new MyHomePage(
        title: this.title,
      ),
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutterサンプルアプリ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title}) : super();

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class Data {
  int _price;
  String _name;

  Data(this._name, this._price) : super();

  @override
  String toString() {
    return _name + ':' + _price.toString() + '円';
  }
}

class _MyHomePageState extends State<MyHomePage> {
  // サンプルデータ
  static final _data = [
    Data('Apple', 200),
    Data('Orange', 150),
    Data('Peach', 300)
  ];
  Data _item;

  @override
  void initState() {
    super.initState();
    _item = _data[0];
  }

  void _setData() {
    setState(() {
      _item = (_data..shuffle()).first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Text(
        _item.toString(),
        style: TextStyle(fontSize: 32.0),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _setData,
        tooltip: 'set message',
        child: Icon(Icons.star),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
