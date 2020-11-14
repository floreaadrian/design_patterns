import 'package:design_patterns/fact_model.dart';
import 'package:design_patterns/poxy_design/db_interface.dart';

import '../db_creator.dart';

class DbProxy implements DbInteface {
  @override
  Future<String> addFact(String fact) async {
    fact = fact.replaceAll('"', '\'');
    final sql = '''INSERT INTO ${DBCreator.itemTable}
    (
      ${DBCreator.fact}
    )
    VALUES
    (
      "$fact"
    )
    ''';
    try {
      await db.rawInsert(sql);
    } catch (e) {
      print(e);
      return null;
    }
    return fact;
  }

  @override
  Future<void> deleteFact(int id) async {
    final sql =
        '''DELETE FROM ${DBCreator.itemTable} WHERE ${DBCreator.id} = $id''';
    print('''delete with id->$id''');
    try {
      await db.rawDelete(sql);
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  @override
  Future<List<FactModel>> getAllFacts() async {
    final sql = '''SELECT * FROM ${DBCreator.itemTable}''';
    final data = await db.rawQuery(sql);
    List<FactModel> list = List();
    for (var elem in data) {
      FactModel item = FactModel.fromJson(elem);
      list.add(item);
    }
    return list;
  }
}
