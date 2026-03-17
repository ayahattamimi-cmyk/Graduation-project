class SquareModel {

  final String name;

  SquareModel({
    required this.name,
  });

  factory SquareModel.fromJson(Map<String,dynamic> json){

    return SquareModel(
      name: json["square_name"],
    );
  }
}