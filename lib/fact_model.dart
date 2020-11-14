class FactModel {
  final int id;
  final String fact;

  FactModel({this.id, this.fact});

  FactModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        fact = json["fact"];

  Map<String, dynamic> toJson() => {
        'id': id,
        'fact': fact,
      };

  @override
  String toString() {
    return fact;
  }
}
