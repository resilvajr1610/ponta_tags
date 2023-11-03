import 'package:ponta_tags/models/farm_model.dart';

//instancia da classe animal.

class AnimalModel{
  int id;
  String tag;
  FarmModel farmModel;

  AnimalModel({
    required this.id,
    required this.tag,
    required this.farmModel
  });
}