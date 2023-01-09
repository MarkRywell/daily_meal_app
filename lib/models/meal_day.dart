class MealDay {

  final int id;
  final String date;
  int? breakfast;
  int? lunch;
  int? dinner;

  MealDay({
    required this.id,
    required this.date,
    this.breakfast,
    this.lunch,
    this.dinner
  });

}