import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:simple_permissions/simple_permissions.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Generated App',
      theme: new ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: const Color(0xFFe91e63),
        accentColor: const Color(0xFFe91e63),
        canvasColor: const Color(0xFFfafafa),
      ),
      home: new MyImagePage(),
    );
  }
}

class MyImagePage extends StatefulWidget {
  @override
  _MyImagePageState createState() => new _MyImagePageState();
}

class _MyImagePageState extends State<MyImagePage> {
  File image;
  GlobalKey _homeStateKey = GlobalKey();
  List<List<Offset>> strokes = new List<List<Offset>>();
  MyPainter _painter;
  ui.Image targetimage;
  Size mediasize;
  double _r = 255.0;
  double _g = 0.0;
  double _b = 0.0;

  _MyImagePageState() {
    requestPermission();
  }

  // パーミッションの設定
  void requestPermission() async {
    await SimplePermissions.requestPermission(Permission.Camera);
    await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
  }

  @override
  Widget build(BuildContext context) {
    mediasize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Canture Image Drawing!'),
      ),
      body: Listener(
        onPointerDown: _pointerDown,
        onPointerMove: _pointerMove,
        child: Container(
          child: CustomPaint(
            key: _homeStateKey,
            painter: _painter,
            child: ConstrainedBox(
              constraints: BoxConstraints.expand(),
            ),
          ),
        ),
      ),
      floatingActionButton: image == null
          ? FloatingActionButton(
              onPressed: getImage,
              tooltip: 'take a picture!',
              child: Icon(Icons.add_a_photo),
            )
          : FloatingActionButton(
              onPressed: saveImage,
              tooltip: 'Save Image',
              child: Icon(Icons.save),
            ),
      drawer: Drawer(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Set Color...',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Slider(
                  min: 0.0,
                  max: 255.0,
                  value: _r,
                  onChanged: sliderR,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Slider(
                  min: 0.0,
                  max: 255.0,
                  value: _g,
                  onChanged: sliderG,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Slider(
                  min: 0.0,
                  max: 255.0,
                  value: _b,
                  onChanged: sliderB,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // スライダーの値設定
  void sliderR(double value) {
    setState(() => _r = value);
  }

  void sliderG(double value) {
    setState(() => _g = value);
  }

  void sliderB(double value) {
    setState(() => _b = value);
  }

  // MyPainterの作成
  void createMyPainter() {
    var strokecolor = Color.fromARGB(200, _r.toInt(), _g.toInt(), _b.toInt());
    _painter = MyPainter(targetimage, image, strokes, mediasize, strokecolor);
  }

  // カメラを起動しイメージを読み込む
  void getImage() async {
    File file = await ImagePicker.pickImage(source: ImageSource.camera);
    image = file;
    loadImage(image.path);
  }

  // イメージの保存
  void saveImage() {
    _painter.saveImage();
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Saved!"),
              content: Text("save image to file."),
            ));
  }

  // パスからイメージを読み込みui.Imageを作成する
  void loadImage(path) async {
    List<int> byts = await image.readAsBytes();
    Uint8List u8lst = Uint8List.fromList(byts);
    ui.instantiateImageCodec(u8lst).then((codec) {
      codec.getNextFrame().then((frameInfo) {
        targetimage = frameInfo.image;
        setState(() {
          createMyPainter();
        });
      });
    });
  }

  // タップしたときの処理
  void _pointerDown(PointerDownEvent event) {
    RenderBox referenceBox = _homeStateKey.currentContext.findRenderObject();
    strokes.add([referenceBox.globalToLocal(event.position)]);
    setState(() {
      createMyPainter();
    });
  }

  // ドラッグ中の処理
  void _pointerMove(PointerMoveEvent event) {
    RenderBox referenceBox = _homeStateKey.currentContext.findRenderObject();
    strokes.last.add(referenceBox.globalToLocal(event.position));
    setState(() {
      createMyPainter();
    });
  }
}

// ペインタークラス
class MyPainter extends CustomPainter {
  File image;
  ui.Image targetimage;
  Size mediasize;
  Color strokecolor;
  var strokes = new List<List<Offset>>();

  MyPainter(this.targetimage, this.image, this.strokes, this.mediasize,
      this.strokecolor);

  @override
  void paint(Canvas canvas, Size size) {
    mediasize = size;
    ui.Image im = drawToCanvas();
    canvas.drawImage(im, Offset(0.0, 0.0), Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  // 描画イメージをファイルに保存する
  void saveImage() async {
    ui.Image img = drawToCanvas();
    final ByteData bytedata =
        await img.toByteData(format: ui.ImageByteFormat.png);
    int epoch = new DateTime.now().millisecondsSinceEpoch;
    final file = new File(image.parent.path + '/' + epoch.toString() + '.png');
    file.writeAsBytes(bytedata.buffer.asUint8List());
  }

  // イメージを描画したui.Imageを返す
  ui.Image drawToCanvas() {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    ui.Canvas canvas = Canvas(recorder);

    Paint p1 = Paint();
    p1.color = Colors.white;
    canvas.drawColor(Colors.white, BlendMode.color);

    if (targetimage != null) {
      Rect r1 = Rect.fromPoints(Offset(0.0, 0.0),
          Offset(targetimage.width.toDouble(), targetimage.height.toDouble()));
      Rect r2 = Rect.fromPoints(
          Offset(0.0, 0.0), Offset(mediasize.width, mediasize.height));
      canvas.drawImageRect(targetimage, r1, r2, p1);
    }

    Paint p2 = new Paint();
    p2.color = strokecolor;
    p2.style = PaintingStyle.stroke;
    p2.strokeWidth = 5.0;

    for (var stroke in strokes) {
      Path strokePath = new Path();
      strokePath.addPolygon(stroke, false);
      canvas.drawPath(strokePath, p2);
    }
    ui.Picture picture = recorder.endRecording();
    return picture.toImage(mediasize.width.toInt(), mediasize.height.toInt());
  }
}
