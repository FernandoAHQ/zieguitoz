import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';


enum ServerStatus { Online, Offline, Connecting }

class ProviderSocket with ChangeNotifier {
   FlutterTts tts = FlutterTts();
   late Socket socket;

 
  void disconnectFromServer() {
    socket.disconnect();
  }

  Future connectToServer(BuildContext _context) async {
print('INSTANTIATED PROVIDER');
 
 String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYyYTI2YTdhNzkzYmIxMjBmZjk4MGEyYiIsInJvbGUiOiJBRE1JTl9ST0xFIiwiaWF0IjoxNjY2MjAyNTYxLCJleHAiOjE2NjYyODg5NjF9.s0xAxkhSdE-0UZAUjKlLzvMMZUBCGs7Rye9bCxf2BuE';
    try {
      // Configure socket transports must be sepecified
      socket = IO.io(
          'http://localhost:4000',
          IO.OptionBuilder()
              .setTransports(['websocket'])
              .enableForceNew()
              .disableAutoConnect()
              .setQuery({'accessToken': 'Bearer $token'})
              .build());

      // Connect to websocket
      socket.connect();
      // Handle socket events
      socket.onConnect((_) {
         print('connect: ${socket.id}');
      });

      socket.onReconnectError((data) => print("RECONNECT ERROR"));
      socket.onReconnectFailed((data) => print("RECONNECT FAILED"));
      socket.on('event', (data) => null);


      socket.on('fromServer', (_) => debugPrint(_));

      socket.on('objectDetected', (data) => speak(data['name']));


    } catch (e) {
      debugPrint(e.toString());
    }


  


  // Send Location to Server
  sendLocation(Map<String, dynamic> data) {
    socket.emit("location", data);
  }


  // Send update of user's typing status
  sendTyping(bool typing) {
    socket.emit("typing", {
      "id": socket.id,
      "typing": typing,
    });
  }

  // Listen to update of typing status from connected users
  void handleTyping(Map<String, dynamic> data) {
    print(data);
  }

  // Send a Message to the server
  sendMessage(String message) {
    socket.emit(
      "message",
      {
        "id": socket.id,
        "message": message, // Message to be sent
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

   //    print(report);
  }

  // Listen to all message events from connected users
  void handleMessage(Map<String, dynamic> data) {
    print(data);
  }


  void speak(String text) async{
    while(true){
      await Future.delayed(Duration(seconds: 1));
    await tts.setLanguage('es-MX');
    await tts.setSpeechRate(1.2);
    await tts.setPitch(1);
    await tts.speak(text);
    }
   // isSpeaking = false;
  }



}







