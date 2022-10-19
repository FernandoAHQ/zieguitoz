import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:zieguitoz/providerSockets.dart';

class Home extends StatelessWidget {
   Home({ Key? key }) : super(key: key);


  FlutterTts tts = FlutterTts();
  bool isSpeaking = false;

  speak(String text) async{
    while(true){
      await Future.delayed(Duration(seconds: 5));
    await tts.setLanguage('es-MX');
    await tts.setSpeechRate(1.2);
    await tts.setPitch(1);
    await tts.speak(text);
    }
   // isSpeaking = false;
  }


  @override
  Widget build(BuildContext context) {
      ProviderSocket socket = Provider.of<ProviderSocket>(context);
      socket.connectToServer(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MaterialButton(
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 2, color: Colors.green)),
                  child: const Icon(
                    Icons.volume_up,
                     size: 96,
                     color:Colors.green),
                ),
                onPressed: (){
                  isSpeaking = true;
                
                  speak('Hola, mundo');
                
              })
            ],
          ),
    
      ),
    );
  }
} 