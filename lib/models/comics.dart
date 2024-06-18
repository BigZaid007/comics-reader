import 'dart:math';

import 'package:epic/models/chapterts.dart';

class Comic
{
  String? name;
  String? image;
  String? category;
  List<Chapters>? chapterts;

  Comic({this.name,this.image,this.category,this.chapterts});

  //fromjson

  Comic.fromjson(Map<String,dynamic> json)
  {
    name = json['Name'];
    image = json['Image'];
    category = json['Category'];
    if(json['Chapters'] != null)
    {
      chapterts = <Chapters>[];
      json['Chapters'].forEach((e) => 
      chapterts!.add(Chapters.fromjson(e))
      );
    }
  }

  //tojson

  Map<String,dynamic> tojson()
  {
    Map<String , dynamic> data = Map<String,dynamic>();

    data['Name'] = name;
    data['Image'] = image;
    data['Category'] = category;
    if(chapterts !=null)
    {
      data['Chapters'] = chapterts!.map((e) => e.toJson()).toList();
    }



    return data;
  }

}