class Food {

  final int id;
  final String name;
  final String foodType;
  String? photo;

  Food({
    required this.id,
    required this.name,
    required this.foodType,
    this.photo
  });

  factory Food.fromMapObject(Map <String, Object?> json) {
    return Food(
      id: json['id'] as int,
      name: json['name'] as String,
      foodType: json['foodType'] as String,
      photo: json['photo'] as String
    );
  }

  Map <String, dynamic> toMap() {
    return {
      'id' : id,
      'name' : name,
      'foodType' : foodType,
      'photo' : photo
    };
  }

}