import 'package:daily_meal_app/models/food.dart';
import 'package:daily_meal_app/models/meal_day.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class QueryBuilder {

  QueryBuilder.privateContructor();

  static final QueryBuilder instance = QueryBuilder.privateContructor();

  static Database? _database;

  Future <Database> getDatabase () async {

    return _database ??= await initDatabase();
  }

  Future <Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'daily_meal.db');
    return await openDatabase(
        path,
      version: 1,
      onCreate: onCreate,
    );
  }

  Future onCreate(Database db, int version) async {

    await db.execute('''
      CREATE TABLE foods(id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT, foodType TEXT, photo TEXT)
    ''');

    await db.execute('''
      CREATE TABLE meal_days(id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT, breakfast INTEGER, lunch INTEGER, dinner INTEGER,
      FOREIGN KEY(breakfast) REFERENCES foods(id),
      FOREIGN KEY(lunch) REFERENCES foods(id),
      FOREIGN KEY(dinner) REFERENCES foods(id))
    ''');
  }

  Future <dynamic> mealDays() async {

    Database db = await instance.getDatabase();

    final List<Map<String, dynamic>> map = await db.query('meal_days');

    return map.isNotEmpty ?
        List.generate(map.length, (i) {
          return MealDay(
            id: map[i]['id'],
            date: map[i]['date'],
            breakfast: map[i]['breakfast'],
            lunch: map[i]['lunch'],
            dinner: map[i]['dinner'],
        );
        }) : [];
  }

  Future <dynamic> food(int id) async {

    Database db = await instance.getDatabase();

    final List<Map<String, dynamic>> map = await db.query('foods', where: "id = ?", whereArgs: [id]);

    return map.isNotEmpty ? Food.fromMapObject(map[0]) : null;
  }

  Future addMeal (MealDay meal) async {

    Database db = await instance.getDatabase();

    int status = await db.insert('meal_days',meal.toMap());

    return status;
  }


  Future addFood (Food food) async {

    Database db = await instance.getDatabase();

    int status = await db.insert('foods', food.toMap());

    status != 0 ?

  }

}