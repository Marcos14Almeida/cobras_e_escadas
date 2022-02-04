import 'dart:async';
import 'dart:math';

import 'package:cobras_e_escadas/class/cobras_escadas.dart';
import 'package:cobras_e_escadas/popup.dart';
import 'package:cobras_e_escadas/theme/textstyle.dart';
import 'package:cobras_e_escadas/theme/toast.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{

  //Animation Parameters
  late AnimationController _controllerStar;
  late AnimationController _controllerAvatar;
  late Animation<double> rot;
  late Animation<double> trasl;

  //Gameplay data
  int nplayers = 2;
  late int currentPlayer;
  late int rodada;
  late int dice1;
  late int dice2;
  late List<int> playerPosition;
  late List<int> playerPositionBefore;
  List<String> playerAvatarImageFileName = ['','assets/peao azul.png','assets/peao vermelho.png'];

  //Widgets controls and parameters
  late int winner; //nº do jogador vencedor da partida
  late bool playAgain; // mostra o botao para jogar novamente
  late bool moving; //os avatares estão se movendo?
  late bool showChangedPosition;
  late bool canClickPlay; //Botao para ir para a rodada do próximo jogador
  late bool showFinishPlayerRoundButton; //Variavel pra mostrar os botoes pra jogar
  late bool fallSnakeAnimation;//faz a animação para o avatar rodar
  late bool showWinnerWidget;//mostra a animação do jogador vencedor

  late double _opacity; //opacidade da animação do troféu
  late double boardSize; //tamanho do tabuleiro
////////////////////////////////////////////////////////////////////////////
//                               INIT                                     //
////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    resetGame();
    funcControllerStar();
    funcControllerAvatar();
    super.initState();
  }
  void resetGame(){
    //Reseta todos os parâmetros
    setState(() {
      currentPlayer = 1;
      playerPositionBefore = [0,0,0];
      playerPosition = [0,0,0];
      dice1 = 0;
      dice2 = 0;
      rodada = 1;
      playAgain = false;
      showChangedPosition = false;
      moving = false;
      canClickPlay = true;
      showFinishPlayerRoundButton = false;
      moving = false;
      fallSnakeAnimation = false;
      showWinnerWidget = true;
      winner = 0;
      _opacity = 0;
    });

    //OS JOGADORES ESCOLHEM A COR DOS SEUS AVATARES
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      for(int i=nplayers;i>=1;i--){
        //Abre um popup para os n jogadores escolherem
        popUpChooseAvatar(
            context: context,
            playerNumber: i,
            functionOK: (imageName){
              playerAvatarImageFileName[i] = imageName;
              setState(() {});
            }
        );
      }
    });

  }
  //Parametros da animação da rotação da estrela
  funcControllerStar(){
    _controllerStar = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _controllerStar.forward();
    _controllerStar.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controllerStar.repeat();
      }
    });
  }
  //Parametros da animação do avatar
  funcControllerAvatar(){

    _controllerAvatar = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    rot = Tween<double>(
      begin: 0,
      end: 2 * pi, //360º
    ).animate(_controllerAvatar);

    trasl = Tween<double>(
      begin: 0,
      end: 360,
    ).animate(_controllerAvatar);

    _controllerAvatar.repeat();
  }

////////////////////////////////////////////////////////////////////////////
//                               DISPOSE                                  //
////////////////////////////////////////////////////////////////////////////
  @override
  void dispose() {
    _controllerStar.dispose();
    _controllerAvatar.dispose();
    super.dispose();
  }
////////////////////////////////////////////////////////////////////////////
//                               BUILD                                    //
////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    boardSize = _height>_width ? _width : _height;
    Color playerColor = CobrasEscadas().playerColor(imageName: playerAvatarImageFileName[currentPlayer]);

    return Scaffold(

      appBar: AppBar(
        backgroundColor: playerColor.withOpacity(0.6),
        title: Text('Vez do: Jogador $currentPlayer'),
      ),

      body: Stack(
        children: [
          Container(
            //cor de fundo de acordo com a cor escolhida pelo usuario
            color: playerColor.withOpacity(0.4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                //TÍTULO DO JOGO
                Container(
                  height: 50,
                  padding: const EdgeInsets.only(top:8),
                  child: Stack(
                    children: [
                      Text('Cobras e Escadas',
                          style: EstiloTexto.borda,
                      ),
                      Text('Cobras e Escadas',
                          style: EstiloTexto.titulo,
                          )
                    ],
                  ),
                ),


                //INFO DOS JOGADORES
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //WIDGET COM AS INFOS DO JOGADOR 1
                      playerInfoWidget(playerNumber: 1),

                      //RODADA E DADOS
                      Column(
                        children: [
                          Text('Rodada $rodada',style: EstiloTextoPreto.text22),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CobrasEscadas().imageDice(diceNumber: dice1),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CobrasEscadas().imageDice(diceNumber: dice2),
                              ),
                            ],
                          ),
                          Text((dice1+dice2).toString(),style: EstiloTextoPreto.text22),
                        ],
                      ),

                      //WIDGET COM AS INFOS DO JOGADOR 2
                      playerInfoWidget(playerNumber: 2),

                    ],
                  ),
                ),


                //TABULEIRO
                SizedBox(
                  height: boardSize,
                  width: boardSize,
                  child: Stack(
                    children: [
                      Image.asset('assets/tabuleiro.png',height: boardSize,width: boardSize),
                      avatarWidget(playerNumber: 1),
                      avatarWidget(playerNumber: 2),
                    ],
                  ),
                ),

                //BOTOES DE JOGAR E RESETAR
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: resetGame,
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.black54, // Text Color
                          ),
                          child: const Text('RESETAR'),
                        ),

                        showFinishPlayerRoundButton ? TextButton(
                          onPressed: nextPlayerRound,
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.black54, // Text Color
                          ),
                          child: const Text('TERMINAR TURNO',style: EstiloTextoBranco.text20),
                        )
                        : canClickPlay ? TextButton(
                          onPressed: (){if(playerPosition[currentPlayer] !=100){
                            changeTurn();
                          }else{
                            customToast('O jogo acabou!!!\n Pressione "resetar" para recomeçar');
                          }
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.black54, // Text Color
                          ),
                          child: const Text('JOGAR',style: EstiloTextoBranco.text34),
                        ) : Container(),

                        TextButton(
                          onPressed: rulesPopUp,
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.black54, // Text Color
                          ),
                          child: const Text('REGRAS'),
                        ),
                      ],
                    ),
                  ),
                ),


              ],
            ),
          ),

          //VICTORY ANIMATION
          showWinnerWidget ? AnimatedOpacity(
            duration: const Duration(seconds: 2),
            opacity: _opacity,
            onEnd: () async {
              //delay pra manter o widget por 2 segundos antes de apagar
              await Future.delayed(const Duration(seconds: 2), () {}); showWinnerWidget = false;
              //desativa o widget
                _opacity=0;
                setState(() {});
              },
            child: Stack(
              children: [
                Center(
                  child: Container(
                    color: Colors.black54,
                    height: 250,
                    width: 250,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(8),
                          child: Image.asset('assets/trophy.png',height: 140,width: 140)
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                          child: Text('Jogador $winner\n Vencedor!!!',textAlign:TextAlign.center,style: EstiloTexto.vitoria)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ) : Container(),

        ],
      ),

    );
  }





////////////////////////////////////////////////////////////////////////////
//                               WIDGETS                                  //
////////////////////////////////////////////////////////////////////////////
  double spaceLeftAvatar({required int playerPosition}){
    //Espaçamento do avatar relativo ao lado esquerdo do tabuleiro
    //(boardSize*0.1) = tamanho de cada quadrado
    //(playerPosition-1) = Se está na posição 2, dá o espaço de 1 quadrado
    //((playerPosition-1)%10) = Calculo para cada fileira, Ex: (23) -> 23-1=22 -> 22%10 = 2 quadrados de espaço
    return (playerPosition-1)%20>=10 //O tabuleiro tem fileiras com a direção do tabuleiro invertida
        ? (boardSize*0.1)*(9-((playerPosition-1)%10))
        : (boardSize*0.1)*((playerPosition-1)%10);
  }
  double spaceBottomAvatar({required int playerPosition}){
    //Espaçamento do avatar relativo ao lado de baixo do tabuleiro
    return playerPosition==0 //Se for a 1ªrodada a peça começa na posição 0
        ? -35  //por isso ela começa escondida
        :(boardSize*0.1)*((playerPosition-1)~/10);
  }
  //Avatar e sua respectiva animação
  Widget avatarWidget({required int playerNumber}){
    return AnimatedBuilder(
        animation: _controllerAvatar,
        builder: (_, child) => Stack(children: <Widget>[
          AnimatedPositioned(
            bottom:spaceBottomAvatar(playerPosition: playerPosition[playerNumber]),
            left: (playerNumber == 2  && playerPosition[1]==playerPosition[playerNumber]) //se duas peças estiverem no mesmo espaço da um espaço extra de +10
                  ? 10 + spaceLeftAvatar(playerPosition: playerPosition[playerNumber])
                  : spaceLeftAvatar(playerPosition: playerPosition[playerNumber]),
            duration: const Duration(seconds: 1),
            child: Transform(
              //Se o peao selecionado cair na cobra, ele rotaciona
              transform: currentPlayer == playerNumber && fallSnakeAnimation
                  ? Matrix4.rotationZ(rot.value)
                  : Matrix4.rotationZ(0),
              child: Image.asset(playerAvatarImageFileName[playerNumber],height: boardSize*0.09,width: boardSize*0.09),
            ),
          ),
        ]));
  }
  //Box com as infos da posição no tabuleiro do usuário
  Widget playerInfoWidget({required int playerNumber}){
    Color playerColor = CobrasEscadas().playerColor(imageName: playerAvatarImageFileName[playerNumber]);

    return Container(
      height: 130,
      width: 100,
      decoration: const BoxDecoration(
          color: Colors.white30,
          borderRadius: BorderRadius.all(Radius.circular(15.0))
      ),
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Text('Jogador $playerNumber:'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person,color: playerColor,size: 35),
              currentPlayer == playerNumber
                  ? RotationTransition(
                        turns: Tween(begin: 0.0, end: 1.0).animate(_controllerStar),
                        child: const Icon(Icons.stars),
                    ) : Container(),
            ],
          ),
          Text(playerPosition[playerNumber].toString(),style: EstiloTextoPreto.text22),
          currentPlayer == playerNumber && showChangedPosition
              ? changePositionWidget(
                  currentPlayer: currentPlayer,
                  playerPosition: playerPosition[playerNumber],
                  playerPositionBefore: playerPositionBefore[playerNumber])
              : Container(),
        ],
      ),
    );
  }

  Widget changePositionWidget({required currentPlayer, required playerPosition,required playerPositionBefore}) {
    if (playerPositionBefore == playerPosition) {
      return Container();
    } else {
      return Column(
        children: [
          const Text('Posição: ',style: EstiloTextoPreto.text16,),
          Text('$playerPositionBefore -> $playerPosition',style: EstiloTextoPreto.text16)
        ],
      );
    }
  }

  rulesPopUp(){
    popUpOK(
      context: context,
      title: 'Regras',
      content: "1. Existem dois jogadores e ambos começam fora do tabuleiro.\n\n2. O jogador 1 começa e alterna sua vez com o jogador 2.\n\n3.Um jogador deve jogar dois dados e somar sua posição atual ao valor da soma dos dados sempre em ordem crescente, do 1 até o 100.\n\n4. Caso o valor de ambos os dados seja igual, o jogador atual ganha uma nova.\n\n5.Caso um jogador pare em uma casa que é a base de uma escada, ele obrigatoriamente deve subir até a casa em que está o topo da escada.\n\n6.Caso um jogador pare em uma casa em que está localizada a cabeça de uma cobra, ele vai obrigatoriamente deve descer até o casa onde está a ponta da cauda da cobra.\n\n7.Um jogador deve cair exatamente na última casa (100) para vencer o jogo. O primeiro jogador a fazer isso, vence. Mas se o somatório dos dados com a casa atual for maior que 100, o jogador deve se movimentar para trás até a contagem terminar, como se ele tivesse batido em uma parede e retornasse.\n\n8.Se um jogador tirar dados iguais e chegar exatamente na casa 100 sem movimentos restantes, então o jogador vence o jogo e não precisa jogar novamente.",
    );
  }
////////////////////////////////////////////////////////////////////////////
//                               FUNCTIONS                                //
////////////////////////////////////////////////////////////////////////////
changeTrophyOpacity(){
    showWinnerWidget = true;
    _opacity = 1;
    setState(() {});
}
moveAvatar() async{
  //Começa a mover o avatar
  moving = true;
  showChangedPosition = true; //mostra o texto de deslocamento dos avatares Ex:1->12
  setState(() {});

  moving = false;
  await Future.delayed(const Duration(seconds: 2), () {});
  setState(() {});
}

Future<void> changeTurn() async {
  canClickPlay = false;//enquanto joga não pode clicar pra jogar

    //ANIMAÇÃO DE SORTEAR OS DADOS
    //Duração de 1segundo
    for(int i=0; i<10; i++){
      await Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          dice1 = Random().nextInt(6)+1;
          dice2 = Random().nextInt(6)+1;
        });
      });
    }

    //dice1=5;dice2=5; //para testar possibilidades mais rápido

    //MOVIMENTO DAS PEÇAS
    for(int i=1;i<=nplayers;i++){
      if(currentPlayer==i){
        playerPositionBefore[i] = playerPosition[i]; //salva a posicao anterior
        playerPosition[i] += CobrasEscadas().jogar(dado1: dice1, dado2: dice2);

        //REBATE NO FINAL DO TABULEIRO
        if(playerPosition[i]>100){
          playerPosition[i] = 200 - playerPosition[i];
        }

        //Faz o movimento das peças
        //espera x segundos da animação
        await moveAvatar();

        //SE CAIR NUMA ESCADA OU NA COBRA
        int movements = CobrasEscadas().bonusMovimentos(playerPosition: playerPosition[i]);
        if(movements!=0){
          playerPosition[i]+=movements;
          if(movements<0){
            fallSnakeAnimation = true;
          }
          //Faz o movimento das peças se caiu na escada ou cobra
          //espera x segundos da animação
          await moveAvatar();
          fallSnakeAnimation = false;
        }

        //FIM DO JOGO
        if(playerPosition[i] == 100){
          if(winner==0){
            //Se ainda ninguém ganhou mostra o widget
            changeTrophyOpacity();
            winner = i; //Salva o nºdo jogador ganhador
            customToast('O jogador $winner Venceu!');
          }
          showFinishPlayerRoundButton = true;
        }else{

          //SE O JOGO NÃO TERMINAR
          //SE OS DADOS FOREM IGUAIS TEM DIREITO A UMA NOVA JOGADA
          if(dice1 == dice2 && !playAgain){
            customToast('Dados iguais, jogue novamente');
            showFinishPlayerRoundButton = false;
            playAgain = true;
          }else{
            //Se a rodada do jogador terminar
            playAgain = false;
            showFinishPlayerRoundButton = true;
          }

        }

      }
    }


    //NOTIFICA A VEZ DO OUTRO JOGADOR
    if(!playAgain){
      if(currentPlayer==1) {
        customToast('Jogador $currentPlayer está na casa ${playerPosition[1]}');
      }else{
        customToast('Jogador $currentPlayer está na casa ${playerPosition[2]}');
      }
      playAgain = false;
    }

    //FIM DA RODADA
    canClickPlay = true;
    setState(() {});
  }

  nextPlayerRound(){
    //Depois que o usuario clicar em próxima rodada
      showFinishPlayerRoundButton = false;

      //Quando o outro jogador for jogar, mostra os dados zerados
      dice1 = 0;
      dice2 = 0;
      showChangedPosition=false;
      if(winner == 1){//se alguem ganhar pula de volta pro usuario que ainda nao terminou o jogo
        currentPlayer=2;
        rodada++;
      }else if (winner == 2){//se alguem ganhar pula de volta pro usuario que ainda nao terminou o jogo
        currentPlayer=1;
        rodada++;
      }else{

        //SE ninguem tiver vencido
        if(!playAgain){//Se nao tiver a repeticao dos dados, muda de jogador
          if(currentPlayer==1){
            currentPlayer=2;
          }else{
            rodada++; //E se for o usuario 2 o ultimo que jogou atualiza a rodada
            currentPlayer=1;
          }
        }
      }
      setState(() {});
    }


}
