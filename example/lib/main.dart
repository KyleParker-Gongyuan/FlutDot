import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutdot/flutdot.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'dart:io'
    show
        HttpRequest,
        HttpServer,
        InternetAddress,
        WebSocket,
        WebSocketTransformer;
import 'dart:convert' show json, utf8;

late FlutDot FlutDotHandler;
final List<WebSocket> onlineClients = [];
void main() {
  FlutDotHandler = FlutDot();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      title: 'flutdot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String godotData = "";
  Color davecolor = Color.fromARGB(255,255,255,255);
  late MagnetometerEvent magEvent;
  @override
  void initState() {
    // TODO: implement initState
    FlutDotHandler.receiveMsg = (data) {
      //parseGameData(data);
      setState(() {

      });
      godotData = data;
      print(godotData);
    };
    
    /* magnetometerEvents.listen((MagnetometerEvent event) {
      magEvent = event;
      //print("MagnetometerEvent:" + event.toString());
    }); */

    //initClient();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: Stack(
        children: [
          FlutDotHandler.GoDotContainer(),
          Align(
            alignment: Alignment(0.0, 0.9),
            child: Text(godotData),
          ),
          Align(
            alignment: Alignment(0.8, -0.8),
            child: TextButton(
              child: Text("Send Hello Hero! -> GoDot", style: TextStyle(color: davecolor),),
              onPressed: () {
                //FlutDotHandler.sendMessage("AlertData", "Hello Hero!");
                final a = {"command":"ping"};
                
                FlutDotHandler.sendMessage(json.encode(a));
                
              },
            ),
          )
        ],
      ),
    ));
  }
}
// a generic client 
/* 
void initClient() {
  print("WS starting connection");
  WebSocket.connect('ws://localhost:5000').then((WebSocket ws) {
    // our websocket server runs on ws://localhost:8000
    // in emulator might have to use 10.0.2.2:8000 instead of localhost
    
    if (ws.readyState == WebSocket.open) {
      // as soon as websocket is connected and ready for use, we can start talking to other end
      print("WS is open");
      
      ws.add(json.encode({
        'data': 'from client at ${DateTime.now().toString()}',
      })); // this is the JSON data format to be transmitted
      ws.listen(
        // gives a StreamSubscription
        (data) { //! ideally we want to expose this json data to flutter it self 
          
          print("data from godot: " + 
              '\t\t -- ${Map<String, String>.from(json.decode(data))}'); // listen for incoming data and show when it arrives
          Timer(Duration(seconds: 1), () {
            if (ws.readyState ==
                WebSocket
                    .open){ // checking whether connection is open or not, is required before writing anything on socket
              ws.add(json.encode({
                'data': 'from client at ${DateTime.now().toString()}',
              }));
            }
          });
        },
        onDone: () => print('[+]Done :)'),
        onError: (err) => print('[!]Error -- ${err.toString()}'),
        cancelOnError: true,
      );
    } else
      print('[!]Connection Denied');
    // in case, if serer is not running now
  }, onError: (err) => print('[!]Error -- ${err.toString()}'));
  

} */


void parseGameData(String gameData){

  final Map<String, dynamic> jsonMap = json.decode(gameData);

  final String code = jsonMap['code'];
  switch (code) {
  case'ping':
    print("game pinged server");
    FlutDotHandler.sendMessage('{"command":"message", "val":"recieved msg"}');
    break;
  case'message':
    print("message sent");
    break;
  default:
    print("unknown code [${code}], CONTACT GAME DEV PPL!!!");
    print("ALL CODE FLUSH:  [$gameData]");
  
  
  }
}