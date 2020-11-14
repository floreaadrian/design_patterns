import 'package:design_patterns/fact_model.dart';

abstract class DbInteface {
  Future<String> addFact(String fact);
  Future<List<FactModel>> getAllFacts();
  Future<void> deleteFact(int id);
}
