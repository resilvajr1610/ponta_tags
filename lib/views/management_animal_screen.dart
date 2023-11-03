import 'package:flutter/material.dart';
import 'package:ponta_tags/models/animal_model.dart';
import 'package:ponta_tags/models/farm_model.dart';
import 'package:ponta_tags/models/fixed_model.dart';
import '../models/alert_model.dart';
import '../service/db_sqlite/db_sqlite.dart';
import '../widgets/show_snackbar_model.dart';

class ManagementAnimalScreen extends StatefulWidget {

  @override
  State<ManagementAnimalScreen> createState() => _ManagementAnimalScreenState();
}

class _ManagementAnimalScreenState extends State<ManagementAnimalScreen> {

  FarmModel farmModel = FarmModel();
  TextEditingController controllerTag = TextEditingController();
  List<AnimalModel> listAnimal = [];
  int idAnimal = 0;
  List<InputsList> inputList = [];

  Future<void> dataFarm()async{
    Map dataFarm = await DbSqlite().dataFarm();
    farmModel.id = dataFarm['ID_FARM'];
    farmModel.farm = dataFarm['FARM'];
    setState(() {});
  }

  dataAnimal()async{
    List result = await DbSqlite().dataAnimal();
    if(result.isNotEmpty){
      listAnimal.clear();
      for(int i = 0; result.length > i; i++){
        listAnimal.add(AnimalModel(id: result[i]['ID_ANIMAL'], tag: result[i]['TAG'], farmModel: farmModel));
      }
    }
    setState((){});
  }

  validationData()async{
    List listAux = [];
    if(idAnimal!=0){
      inputList.add(InputsList(controller: controllerTag, index: idAnimal));
    }
    for(int j = 0; inputList.length > j; j ++){
      if(inputList[j].controller.text.length == 15){
        for(int i = 0; listAnimal.length > i; i++){
          listAux.add(listAnimal[i].tag);
        }
        if(idAnimal!=0 && !listAux.contains(inputList[j].controller.text)){
          await DbSqlite().updateAnimal(idAnimal,controllerTag.text,context);
          controllerTag.clear();
          idAnimal = 0;
          dataAnimal();
        }else{
          if(!listAux.contains(inputList[j].controller.text)){
            if(idAnimal != 0){
              await DbSqlite().updateAnimal(idAnimal,controllerTag.text,context);
            }else{
              Map<String,dynamic> data = {
                'TAG'     : inputList[j].controller.text,
                'ID_FARM' : farmModel.id,
                'FARM'    : farmModel.farm
              };
              await DbSqlite().saveAnimal(data,context);
            }
            controllerTag.clear();
            idAnimal = 0;
            dataAnimal();
          }else{
            showSnackBarModel(context, 'Tag já foi salva!', Colors.red);
          }
        }
      }else{
        showSnackBarModel(context, 'Digite a tag com 15 digitos para salvar!', Colors.red);
        break;
      }
    }
    Navigator.of(context).pop();
    setState((){});
  }

  editAnimal()async{
    setState(() {});
    AlertModel().alert(context, 'EDITAR ANIMAL', 'Insira a tag do animal','EDITAR',controllerTag,TextInputType.number,validationData,onPressedCancelEdit,onPressedDelete,[]);
    // print(result);
  }

  onPressedCancelEdit(){
    controllerTag.clear();
    idAnimal = 0;
    setState(() {});
    Navigator.pop(context);
  }

  onPressedDelete(){
    AlertModel().alert(context, 'EXCLUIR ANIMAL?', '','EXCLUIR',controllerTag,TextInputType.text,delete,onPressedCancelEdit,null,inputList);
  }

  delete()async{
    DbSqlite().deleteAnimal(idAnimal, context);
    idAnimal = 0;
    dataAnimal();
    setState(() {});
  }

  onPressedFarm(){
    controllerTag.text = farmModel.farm;
    setState(() {});
    print(controllerTag.text);
    AlertModel().alert(context, 'EDITAR FAZENDA', 'Insira a fazenda','ALTERAR',controllerTag,TextInputType.text,editFarm,onPressedCancelEdit,(){},[]);
  }

  editFarm(){
    if(controllerTag.text.isNotEmpty){
      DbSqlite().updateFarm(controllerTag.text,context);
      controllerTag.clear();
      setState(() {});
      dataFarm();
    }else{
      showSnackBarModel(context, 'Insira o nome da fazenda para alterar!', Colors.red);
    }
  }

  @override
  void initState() {
    super.initState();
    dataFarm();
    dataAnimal();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 100,
        title: Text('FAZENDA ${farmModel.farm.toUpperCase()}',style: TextStyle(color: Fixed.GREY,fontSize: 25),maxLines: 2,overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(onPressed: onPressedFarm, icon: Icon(Icons.edit,color: Fixed.GREEN_MAIN,))
        ],
      ),
      body: Container(
        child: listAnimal.isEmpty?Container(
            height: height*0.7,
            alignment: Alignment.center,
            child: Text('NENHUMA INFORMAÇÃO SALVA',style: TextStyle(color: Fixed.GREY,fontSize: 20),)
        ):ListView.builder(
            itemCount: listAnimal.length,
            itemBuilder:(context,index){
              return GestureDetector(
                onTap: (){
                  controllerTag.text = listAnimal[index].tag;
                  idAnimal = listAnimal[index].id;
                  editAnimal();
                },
                child: Card(
                  elevation: 1,
                    child: Container(
                        padding: EdgeInsets.all(15),
                        child: Text(listAnimal[index].tag,style: TextStyle(color: Fixed.GREEN_MAIN,fontSize: 20))
                    )
                ),
              );
            },
        ),
      ),
      bottomSheet: Container(
        alignment: Alignment.center,
        width: width,
        height: 50,
        color: Fixed.GREEN_SECOND,
        child: Text('QUANTIDADE DE ANIMAIS CADASTRADOS: ${listAnimal.length}',style: TextStyle(color: Fixed.GREY,fontSize: 15))
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: (){
                if(inputList.isEmpty){
                  inputList.add(InputsList(controller: controllerTag, index: 0));
                }
                AlertModel().alert(context, 'CADASTRAR ANIMAL', 'Insira a tag do animal','SALVAR',controllerTag,TextInputType.number,validationData,(){
                  Navigator.pop(context);
                  inputList.clear();
                  controllerTag.clear();
                },null,inputList);
              },
              icon: Icon(
                Icons.add_circle,
                color: Fixed.GREEN_MAIN,
                size: 50,
              )
          ),
        ],
      ),
    );
  }
}
