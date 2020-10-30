import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

import 'dart:typed_data';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 235, 235, 235),
      appBar: AppBar(
        title: Text('App Name'),
      ),
      body: Center(
        child: MyRenderBoxWidget(),
      ),
    );
  }
}

class MyRenderBoxWidget extends SingleChildRenderObjectWidget {
  @override
  RenderObject createRenderObject(BuildContext context) {
    return _MyRenderBox();
  }
}

class _MyRenderBox extends RenderBox {
  ui.Image _img;
  Offset _pos;

  @override
  bool hitTest(HitTestResult result, {@required Offset position}) {
    result.add(BoxHitTestEntry(this, position));
    return true;
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    super.handleEvent(event, entry);
    _pos = event.position;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    Canvas c = context.canvas;
    c.drawColor(Colors.black, BlendMode.clear);
    if (_pos != null) {
      Paint p = Paint();
      p.style = PaintingStyle.fill;
      for (var i = 0; i < 10; i++) {
        p.color = Color.fromARGB(50, 255, 255, 255);
        c.drawCircle(_pos, i * 5.0, p);
      }
    }
  }
}
