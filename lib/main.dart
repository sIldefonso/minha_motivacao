import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shake/shake.dart';

import 'constantes.dart' as Constantes;
import 'dart:convert';
import 'dart:math';

void main() {
  runApp(MinhaMotivacaoApp());
}

class MinhaMotivacaoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Retirar a barra de status do Android
    SystemChrome.setEnabledSystemUIOverlays([]);
    //Manter a App na vertical
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      home: MinhaMotivacao(),
    );
  }
}

class MinhaMotivacao extends StatefulWidget {
  @override
  _MinhaMotivacaoState createState() => _MinhaMotivacaoState();
}

class _MinhaMotivacaoState extends State<MinhaMotivacao> {
  int numeroFrase = 1;
  int numeroImagem = 1;
  int numeroMusica = 1;
  bool tocarSom = false;
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  Widget build(BuildContext context) {
    var tmpData = json.decode(Constantes.frases);
    String fraseAMostrar = tmpData['frases'][numeroFrase];
    String image = 'assets/imagem$numeroImagem.jpg';
    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      novaFraseEImagem(tmpData);
    });
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/fundo1.jpg"), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Container(
                child: Card(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    fraseAMostrar,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Card(
                  margin: EdgeInsets.all(10),
                  child: Image.asset(image),
                ),
                width: double.infinity,
                height: 300,
              ),
              SizedBox(
                height: 30,
              ),
              RaisedButton(
                color: Colors.green,
                onPressed: () {
                  novaFraseEImagem(tmpData);
                },
                child: Container(
                  child: Text(
                    'Próxima frase',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              controloDeSom(),
            ],
          ),
        ),
      ),
    );
  }

  void novaFraseEImagem(tmpData) {
    setState(() {
      Random r = new Random();
      numeroFrase = r.nextInt(tmpData['frases'].length);
      numeroImagem = r.nextInt(4) + 1;
    });
  }

  Widget controloDeSom() {
    Random r = new Random();
    if (this.tocarSom == false) {
      //Não começou a tocar
      return IconButton(
          icon: Icon(Icons.volume_off, //ícone "sem som"
              size: 50),
          onPressed: () {
            //Quando premido, calcula música e começa a tocar
            setState(() {
              this.tocarSom = true;
              numeroMusica = r.nextInt(4) + 1;
              assetsAudioPlayer.loop = true;
              assetsAudioPlayer.open(Audio('assets/musica$numeroMusica.mp3'));
              assetsAudioPlayer.play();
            });
          });
    } else {
      //Já está a tocar
      return IconButton(
          icon: Icon(Icons.volume_up, //ícone "com som"
          size: 50),
          onPressed: () {
            setState(() {
              //Quando premido, pára de tocar
              this.tocarSom = false;
              assetsAudioPlayer.loop = false;
              assetsAudioPlayer.stop();
            });
          });
    }
  }
}
