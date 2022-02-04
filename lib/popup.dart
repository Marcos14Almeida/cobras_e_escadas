import 'package:cobras_e_escadas/theme/textstyle.dart';
import 'package:flutter/material.dart';

void popUpOK({required BuildContext context, required String title, required String content}){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // retorna um objeto do tipo Dialog
      return AlertDialog(
        title: Text(title,style: EstiloTextoPreto.text22),
        content: SizedBox(
            height:400,
            child: Scrollbar(
                isAlwaysShown:true,
                child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(content,textAlign:TextAlign.justify,style: EstiloTextoPreto.text16),
                    )))),
        actions: <Widget>[
          TextButton(
            child: const Text("OK",style: EstiloTextoPreto.text16,),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void popUpChooseAvatar({required BuildContext context, required playerNumber, required Function(String imageName)? functionOK}){
  double imageSize = 50;

  //WIDGET DE CADA AVATAR SELECIONAVEL
  Widget avatarWidget(String imageName){
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
        functionOK!(imageName);
      },
      child: Image.asset(imageName,height: imageSize,width: imageSize),
    );
  }

  showDialog(
    barrierDismissible: false, //impede que feche quando clica fora
    context: context,
    builder: (BuildContext context) {
      // retorna um objeto do tipo Dialog
      return AlertDialog(
        title: Text('Jogador $playerNumber: \nEscolha a sua cor: ',style: EstiloTextoPreto.text22),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            avatarWidget('assets/peao azul.png'),
            avatarWidget('assets/peao vermelho.png'),
            avatarWidget('assets/peao verde.png'),
            avatarWidget('assets/peao preto.png'),
          ],
        ),
      );
    },
  );


}