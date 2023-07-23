import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DatePickup with ChangeNotifier {
  DateTime _curDate = new DateTime.now();
  DateTime get curDate => _curDate;
  String _strDate = "";
  String get strDate => _strDate;
  late String _verses = "";
  String get verses => _verses;
  List<dynamic> _bibleList = [];
  List<dynamic> get bibleList => _bibleList;

  void pick_date(pickedDate) {
    _curDate = pickedDate;
    String _strDate = pickedDate.toString();
    if(_strDate.length > 0){
      List<String> tmp = _strDate.split(' ')[0].split('-');
      String m  = (int.tryParse(tmp[1])).toString();
      String d = (int.tryParse(tmp[2])).toString();
      _strDate = "m${m}d$d";
    }
    _strDate = _strDate;
    pick_bible(_strDate);
    notifyListeners();
  }

  void pick_bible(strDate) async{
    String jsonString = await rootBundle.loadString('./assets/json/readthrBible.json');
    final jsonResponse = json.decode(jsonString);
    print(jsonResponse[strDate]);
    _bibleList = jsonResponse[strDate]["contents"];
    for(int i = 0 ; i < _bibleList.length ; i++)
    {
        List<dynamic> book = _bibleList[i]["paragraphs"][0];
        for(int j = 0 ; i < book.length ; j++)
        {
          String verse = book[i]["content"];
          _verses = _verses + verse + '\n';
          print(_verses);
        }
    }
  }
}

