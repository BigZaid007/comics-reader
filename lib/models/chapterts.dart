class Chapters
{
   List<String>? links;
   String? name;

  Chapters({this.links, this.name});


   Chapters.fromjson(Map<String,dynamic> json)
   {
      name = json['Name'];
      if(json['Links'] != null)
        links=json['Links'].cast<String>();
   }

  Map <String,dynamic> toJson()
  {
      Map<String, dynamic> data = Map<String,dynamic>();
      data['Links'] = links;
      data['Name'] = name;
      return data;
  }
}