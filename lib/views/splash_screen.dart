import 'package:flutter/material.dart';
import 'package:ponta_tags/models/alert_model.dart';
import 'package:ponta_tags/service/db_sqlite/db_sqlite.dart';
import 'package:ponta_tags/widgets/buttom_custom.dart';
import 'package:ponta_tags/widgets/show_snackbar_model.dart';
import 'package:sqflite/sqflite.dart';
import '../models/fixed_model.dart';

//tela splash, a primeira tela do app para carregamentos ou verificações iniciais.

class SplashScreen extends StatefulWidget {

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  TextEditingController controllerFarm = TextEditingController();

  enterButton()async{
    Database db = await DbSqlite().initialDB();
    final result = await db.rawQuery('SELECT COUNT(*) FROM FARM');
    int? count = Sqflite.firstIntValue(result);

    if(count!>0){
      Navigator.pushNamed(context, '/animal');
    }else{
      AlertModel().alert(context, 'PRIMEIRO ACESSO', 'Insira o nome da fazenda', 'AVANÇAR',controllerFarm,TextInputType.text,validationData,()=>Navigator.pop(context),null,[]);
    }
  }

  validationData()async{
    if(controllerFarm.text.isNotEmpty){
      await DbSqlite().saveFarm(controllerFarm.text,context);
    }else{
      showSnackBarModel(context, 'Digite o nome da fazenda para avançar!', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Fixed.BG),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white70, Colors.black.withOpacity(0.7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                child: Image.asset(Fixed.LOGO)
              ),
              ButtomCustom(
                backgroundColor: Fixed.GREEN_SECOND,
                colorText: Fixed.GREEN_MAIN,
                text: 'ENTRAR',
                onPressed:enterButton,
                width: width*0.5,
              )
            ],
          ),
        )
      ),
    );
  }
}
