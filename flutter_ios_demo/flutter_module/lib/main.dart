import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter_cc_cwli'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  // 创建一个给native的channel (类似iOS的通知）
  static const methodChannel = const MethodChannel('com.pages.your/native_get');

  // 注册一个通知
  static const EventChannel eventChannel = const EventChannel('com.pages.your/native_post');

  // 注册一个通知
  static const EventChannel eventChannel1 = const EventChannel('com.second.your/native_post');

  @override
  void initState() {
    super.initState();

    // 监听事件，同时发送参数12345
    eventChannel.receiveBroadcastStream(12345).listen(_onChangeCountEvent,onError: _onError);
    eventChannel1.receiveBroadcastStream(88888).listen(_onChangeCountEvent,onError: _onError);
  }

  String naviTitle = '你好，大佬' ;
  // 回调事件
  void _onEvent(Object event) {
    setState(() {
      naviTitle =  event.toString();
    });
  }

  // 回调事件
  void _onChangeCountEvent(Object event) {
    setState(() {
      _counter =  int.parse(event.toString());

      print('flutter的log打印：现在输出count=$_counter');
      // 当个数累积到3的时候给客户端发参数
      if(_counter == 3) {
        _toNativeSomethingAndGetInfo();
      }

      // 当个数累积到5的时候给客户端发参数
      if(_counter == 1002) {
        Map<String, String> map = { "title": "这是一条来自flutter的参数" };
        methodChannel.invokeMethod('toNativePush',map);
      }

      // 当个数累积到8的时候给客户端发参数
      if(_counter == 1005) {
        Map<String, dynamic> map = { "content": "flutterPop回来","data":[1,2,3,4,5]};
        methodChannel.invokeMethod('toNativePop',map);
      }

    });
  }

  // 错误返回
  void _onError(Object error) {

  }

  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  // 给客户端发送一些东东 , 并且拿到一些东东
  Future<Null> _toNativeSomethingAndGetInfo() async {
    dynamic result;
    try {
      result = await methodChannel.invokeMethod('toNativeSomething','大佬你点击了$_counter下');
    } on PlatformException {
      result = 100000;
    }
    setState(() {
      // 类型判断
      if (result is int) {
        _counter = result;
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
