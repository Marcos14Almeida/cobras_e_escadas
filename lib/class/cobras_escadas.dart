import 'package:cobras_e_escadas/theme/toast.dart';
import 'package:flutter/material.dart';

class CobrasEscadas{

  int jogar({required int dado1, required int dado2}){
    return dado1+dado2;
  }

  int bonusMovimentos({required int playerPosition}){
    //Mapeia o ponto inicial(key) do tabuleiro e indica o ponto de chegada(value);
    Map<int,int> cobras = {16:6, 46:25, 49:11, 62:19, 64:60, 74:53, 89:68, 92:88, 95:75, 99:80};
    Map<int,int> escadas = {2:38, 7:14, 8:31, 15:26, 21:42, 28:84, 36:44, 51:67, 71:91, 78:98, 87:94};

    //CAIU EM UMA COBRA
    int movements = 0;
    if(cobras.containsKey(playerPosition)){
      movements = int.parse(cobras[playerPosition].toString()) - playerPosition;
      customToast('Caiu em uma cobra');
    }
    //CAIU EM UMA ESCADA
    if(escadas.containsKey(playerPosition)){
      movements = int.parse(escadas[playerPosition].toString()) - playerPosition;
      customToast('Caiu em uma escada');
    }
    return movements;
  }

  Image imageDice({required diceNumber}){
    //retorna a imagem do dado, a depender do valor que foi sorteado
    double sizeDice = 50;
    Image image = Image.asset('assets/dice 0.png',height: sizeDice,width: sizeDice);
    if(diceNumber==1){image = Image.asset('assets/dice 1.png',height: sizeDice,width: sizeDice);}
    if(diceNumber==2){image = Image.asset('assets/dice 2.png',height: sizeDice,width: sizeDice);}
    if(diceNumber==3){image = Image.asset('assets/dice 3.png',height: sizeDice,width: sizeDice);}
    if(diceNumber==4){image = Image.asset('assets/dice 4.png',height: sizeDice,width: sizeDice);}
    if(diceNumber==5){image = Image.asset('assets/dice 5.png',height: sizeDice,width: sizeDice);}
    if(diceNumber==6){image = Image.asset('assets/dice 6.png',height: sizeDice,width: sizeDice);}

    return image;
  }

  Color playerColor({required imageName}){
    late Color color;
    if(imageName == 'assets/peao azul.png'){color=Colors.blue;}
    if(imageName == 'assets/peao verde.png'){color=Colors.green;}
    if(imageName == 'assets/peao vermelho.png'){color=Colors.red;}
    if(imageName == 'assets/peao preto.png'){color=Colors.black;}
    return color;
  }
}