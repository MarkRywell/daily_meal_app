class MealDay {

  int? id;
  final String date;
  int? breakfast;
  int? lunch;
  int? dinner;

  MealDay({
    this.id,
    required this.date,
    this.breakfast,
    this.lunch,
    this.dinner
  });

  factory MealDay.fromMapObject(Map <String, Object?> json) {
    return MealDay(
      id: json['id'] as int?,
      date: json['date'] as String,
      breakfast: json['breakfast'] as int,
      lunch: json['lunch'] as int,
      dinner: json['dinner'] as int,
    );
  }

  Map <String, dynamic> toMap() {
    return {
      'id' : id,
      'date' : date,
      'breakfast' : breakfast,
      'lunch' : lunch,
      'dinner' : dinner
    };
  }

}