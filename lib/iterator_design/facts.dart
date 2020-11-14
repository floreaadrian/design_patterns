import 'dart:convert';

import 'package:http/http.dart';

class Facts {
  List<String> _factsList = [];
  String _apiUrl = 'https://uselessfacts.jsph.pl/random.json?language=en';

  Iterator createIterator() {
    return new Iterator(this);
  }

  Future<String> _fetchOne() async {
    var response = await get(_apiUrl);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var body = jsonDecode(response.body);
      return body["text"];
    }
    return null;
  }

  Future<void> fetchMore() async {
    for (int i = 0; i < 5; ++i) {
      String gotOne = await _fetchOne();
      _factsList.add(gotOne);
    }
  }
}

class Iterator {
  Facts _facts;
  int index;

  Iterator(Facts facts) {
    _facts = facts;
  }

  void first() {
    index = 0;
  }

  void next() {
    if (!isDone()) {
      index++;
    }
  }

  bool isDone() {
    return index == (_facts._factsList.length - 1);
  }

  String curentItem() {
    return _facts._factsList[index];
  }
}
