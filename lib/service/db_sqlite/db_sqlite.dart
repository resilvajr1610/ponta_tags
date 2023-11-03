import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../widgets/show_snackbar_model.dart';

class DbSqlite{
  Future initialDB()async{
    final path = await getDatabasesPath();
    final local = join(path,'ponta.db');

    var db = await openDatabase(
        local,
        version: 1,
        onCreate: (db,newVersion){
          db.execute('CREATE TABLE IF NOT EXISTS FARM (ID_FARM INTEGER PRIMARY KEY AUTOINCREMENT, FARM TEXT);');
          db.execute('CREATE TABLE IF NOT EXISTS ANIMAL (ID_ANIMAL INTEGER PRIMARY KEY AUTOINCREMENT, TAG TEXT , ID_FARM INTEGER, FARM TEXT);');
        }
    );
    return db;
  }
  Future saveFarm(String farm, BuildContext context)async{
    Database db = await DbSqlite().initialDB();
    try{
      await db.insert('FARM', {'FARM': farm}).then((value){
        showSnackBarModel(context, 'Cadastrado com sucesso!', Colors.green);
        Navigator.of(context).pop();
        Navigator.pushNamed(context, '/animal');
      });
      print(await db.query('FARM'));
    }catch (e){
      showSnackBarModel(context, 'Erro: $e!', Colors.red);
    }
  }

  Future saveAnimal(Map<String,dynamic> data, BuildContext context)async{
    Database db = await DbSqlite().initialDB();
    try{
      await db.insert('ANIMAL', data).then((value){
        showSnackBarModel(context, 'Cadastrado com sucesso!', Colors.green);
      });
      print(await db.query('ANIMAL'));
    }catch (e){
      showSnackBarModel(context, 'Erro: $e!', Colors.red);
    }
  }

  dataFarm()async{
    Database db = await DbSqlite().initialDB();
    var query = "SELECT * FROM FARM";
    List list = await db.rawQuery(query);
    return list[0];
  }

  dataAnimal()async{
    Database db = await DbSqlite().initialDB();
    var query = "SELECT * FROM ANIMAL";
    List list = await db.rawQuery(query);
    return list;
  }

  queryAnimal(int id)async{
    Database db = await DbSqlite().initialDB();
    List list = await db.rawQuery("SELECT * FROM ANIMAL WHERE ID_ANIMAL = $id");
    return list[0];
  }
  updateAnimal(int id, String tag,BuildContext context)async{
    Database db = await DbSqlite().initialDB();
    await db.update('ANIMAL', {'TAG':tag},where: "ID_ANIMAL = $id");
    showSnackBarModel(context, 'Alterado com sucesso!', Colors.green);
  }
  deleteAnimal(int id, BuildContext context)async{
    Database db = await DbSqlite().initialDB();
    await db.delete('ANIMAL', where: "ID_ANIMAL = $id");
    showSnackBarModel(context, 'Deletado com sucesso!', Colors.green);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
  updateFarm(String farm,BuildContext context)async{
    Database db = await DbSqlite().initialDB();
    await db.update('FARM', {'FARM':farm},where: "ID_FARM = 1");
    showSnackBarModel(context, 'Alterado com sucesso!', Colors.green);
    Navigator.of(context).pop();
  }
}