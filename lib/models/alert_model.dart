import 'package:flutter/material.dart';
import '../widgets/buttom_custom.dart';
import '../widgets/input_text_custom.dart';
import 'fixed_model.dart';

class AlertModel{
  alert(BuildContext context,String title,String subtitle,String textButtom,TextEditingController controller,
      TextInputType textInputType, VoidCallback onPressed,VoidCallback onPressedCancel,VoidCallback? onPressedDelete, List<InputsList> inputList) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return StatefulBuilder(
            builder:(context,setState)=>AlertDialog(
              title: Row(
                children: [
                  Text(title,style: TextStyle(color: Fixed.GREEN_MAIN,fontWeight: FontWeight.bold)),
                  onPressedDelete==null || title == "EDITAR FAZENDA"?Container():Spacer(),
                  onPressedDelete==null || title == "EDITAR FAZENDA"?Container():IconButton(
                      onPressed: onPressedDelete,
                      icon: Icon(
                        Icons.delete,
                        color: Fixed.RED,
                        size: 35,
                      )
                  ),
                ],
              ),
              content:onPressedDelete==null && title == "EDITAR FAZENDA"?Container(height: 0,): Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  title == "EDITAR ANIMAL"?InputTextCustom(hint: subtitle,controller: controller,textInputType: TextInputType.number,):Container(),
                  title == "EDITAR FAZENDA"?InputTextCustom(hint: subtitle,controller: controller,textInputType: TextInputType.text,):Container(),
                  title == "PRIMEIRO ACESSO"?InputTextCustom(hint: subtitle,controller: controller,textInputType: TextInputType.text,):Container(),
                  title == 'CADASTRAR ANIMAL'?Container(
                    height: inputList.length*50,
                    width: 500,
                    child: ListView.builder(
                      itemCount: inputList.length,
                      itemBuilder: (context,index){
                        return InputTextCustom(hint: subtitle,controller: inputList[index].controller,textInputType: TextInputType.number,);
                      },
                    ),
                  ):Container(),
                  title == 'CADASTRAR ANIMAL'?IconButton(onPressed: (){
                    var controllerNew = TextEditingController();
                    inputList.add(InputsList(controller: controllerNew, index: inputList.length+1));
                    setState((){});
                  }, icon: Icon(Icons.add_circle,color: Fixed.GREEN_MAIN,size: 30,)):Container(),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ButtomCustom(
                        backgroundColor: Fixed.RED,
                        colorText: Colors.white,
                        text: 'CANCELAR',
                        onPressed:onPressedCancel,
                        width: width*0.3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ButtomCustom(
                        backgroundColor: Fixed.GREEN_SECOND,
                        colorText: Fixed.GREEN_MAIN,
                        text: textButtom,
                        onPressed:onPressed,
                        width: width*0.3,
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        }
    );
  }
}

class InputsList{
  int index;
  TextEditingController controller;

  InputsList({
    required this.controller,
    required this.index
  });
}