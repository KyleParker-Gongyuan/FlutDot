import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


class FlutDot {
  late int _localWebPort;
  late int _localWSPort;
  late InAppLocalhostServer _localhostServer;
  late InAppWebViewController _webcontroller;



  /// [consoleCb] recives print(in godot) output's.
  /// 
  /// Needs more benchmarking to compare with real WS
  late Function(dynamic jsonData) consoleCb;
  
  /// [receiveMsg] should*** be faster then console
  late Function(String msg) receiveMsg;

  final List<WebSocket> onlineClients = [];


  ///Must be initialized in the void main(){} //! does it actually or do we need to be
  FlutDot({int portWeb = 1878, int portWS = 5000}) {
    _localWebPort = portWeb;
    _localWSPort = portWS;
    if (!kIsWeb) {
      _localhostServer = InAppLocalhostServer(port: _localWebPort);
    }
    // start the localhost server
    _startServer();
  }

  int get port {
    return _localWebPort;
  }

  void set port(int portNumber) {
    _localWebPort = portNumber;
  }

  void _startServer() async {
    // start the localhost server
    
    try {
      WidgetsFlutterBinding.ensureInitialized();
      if (!kIsWeb) await _localhostServer.start();
      if (Platform.isAndroid) {
        await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(
            true);
      }
    } catch (e) {
      print("FlotDotError: " + e.toString());
    }
    //Start websocket Server
    // maybe wait untill we get some code from server first
    try {
      
      print("FlutDot: Init Server!");
      
      HttpServer.bind('localhost', _localWSPort).then((HttpServer server) { //! 不懂
        print('FlutDot: [+]WebSocket listening at -- ws://localhost:$_localWSPort/');
        server.listen((HttpRequest request) {
          print("got request: $request");
          WebSocketTransformer.upgrade(request).then((WebSocket ws) {
            onlineClients.add(ws);
            print("added client: $ws");
            ws.listen(
              (data) {
                var curtim = DateTime.now();
                print("recived somthing");

                final utf8Decoder = utf8.decoder;
                

                final str = utf8Decoder.convert(data);
                print(
                    '\t\t FlutDot:${request?.connectionInfo?.remoteAddress} -- ${json.decode(str)}');

                if (receiveMsg != null) {
                  try {
                    //dynamic jsonOBJ = jsonDecode(consoleMessage.message);
                    receiveMsg(json.decode(str));
                  } catch (e) {
                    print("flutdot[!]consoleCallBack error: $e");
                  }
                }
                Timer(Duration(seconds: 1), () {
                  if (ws.readyState == WebSocket.open) {
                    // checking connection state helps to avoid unprecedented errors
                    ws.add(json.encode({
                      'data': 'from server at ${DateTime.now().toString()}',
                    }));
                  }
                }
                
                );
              },
              onDone: () => print('[+]Done :)'),
              onError: (err) => print('[!]Error -- ${err.toString()}'),
              cancelOnError: true,
            );
            ws.done.then((_) {
                // Remove the disconnected client from the list.
                onlineClients.remove(ws);
              });
          }, onError: (err) => print('[!]Error -- ${err.toString()}'));
        }, onError: (err) => print('[!]Error -- ${err.toString()}'));
      }, onError: (err) => print('[!]Error -- ${err.toString()}'));
      print("started server");
    } catch (e) {
      print("FlotDotServerError: " + e.toString());
    }
  }

  Widget GoDotContainer() {
    return InAppWebView(
      onWebViewCreated: (controller) {
        _webcontroller = controller;
      },
      onConsoleMessage: (controller, consoleMessage) {
        if (consoleCb != null) {
          try {
            //dynamic jsonOBJ = jsonDecode(consoleMessage.message);
            consoleCb(consoleMessage.message);
          } catch (e) {
            print("flutdot[!]consoleCallBack error: $e");
          }
        }
      },
      initialUrlRequest:
          //URLRequest(url: Uri.parse("http://scooter-report.de/2d")),
          URLRequest(
              url: Uri.parse(
                  "http://127.0.0.1:${_localWebPort}/GoDotExport/index.html")),
    );
  }
  // send a message to all connected clients. (which is just 1 on locally)
  void sendMessage(dynamic message) {
    for (var client in onlineClients) {
      client.addUtf8Text(utf8.encode(message));
    }
  }
  
  void stopServer(){
    _localhostServer.close();
  }
}
