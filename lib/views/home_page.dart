import 'package:daily_meal_app/models/query_builder.dart';
import 'package:daily_meal_app/views/add_meal.dart';
import 'package:daily_meal_app/views/details_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List mealsList = [];
  PermissionStatus permissionStatus = PermissionStatus.denied;

  checkPermissions() async {

    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage
    ].request();

    if(statuses[Permission.camera] == PermissionStatus.granted &&
        statuses[Permission.storage] == PermissionStatus.granted) {
      setState(() {
        permissionStatus = PermissionStatus.granted;
      });
    }
   else if (statuses[Permission.camera] == PermissionStatus.permanentlyDenied ||
       statuses[Permission.storage] == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }

  }

  @override
  void initState() {
    checkPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: permissionStatus.isDenied ?
      Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/error.json'),
              const Text("User Permission Required to Access the App",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                ),)
            ],
          )
      ) : FutureBuilder(
        future: QueryBuilder.instance.mealDays(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      padding: const EdgeInsets.only(bottom: 10),
                      child: const Icon(Icons.error_outline,
                          size: 100,
                          color: Colors.redAccent
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("Database Error: Problem Fetching Data",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            height: 1.5,
                            fontSize: 20
                        ),),
                    )
                  ],
                ),
              );
            }
            if (snapshot.hasData) {

              if (snapshot.data!.isEmpty) {
                return Center(
                  child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.2,
                            child: Lottie.asset('assets/foods.json'),
                          ),
                          const Text("You got no meals",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                              ))
                        ],
                      )
                  ),
                );
              }
              else {
                mealsList.isEmpty ? mealsList = snapshot.data! : null;

                return NestedScrollView(
                  floatHeaderSlivers: true,
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      const SliverAppBar(
                        title: Text("Daily Meal"),
                        centerTitle: true,
                        backgroundColor: Colors.greenAccent,
                      )
                    ],
                    body: ListView.builder(
                        itemCount: mealsList.length,
                        itemBuilder: (context, index) {

                          final meal = mealsList[index];

                          return Card(
                            key: UniqueKey(),
                            child: ListTile(
                              title: Text(meal.date),
                              onTap: () async {

                                List foods = [];

                                if(meal.breakfast != null) {
                                  var breakfastFood = await QueryBuilder.instance.food(meal.breakfast);

                                  foods.add(['Breakfast', breakfastFood]);
                                }
                                if(meal.lunch != null) {
                                  var lunchFood = await QueryBuilder.instance.food(meal.lunch);

                                  foods.add(['Lunch', lunchFood]);
                                }
                                if(meal.dinner != null) {
                                  var dinnerFood = await QueryBuilder.instance.food(meal.dinner);

                                  foods.add(['Dinner', dinnerFood]);
                                }

                                Navigator.push(context,
                                MaterialPageRoute(builder: (context)=> MealDetails(meal: meal, foods: foods)));
                              },
                            ),
                          );
                        }
                    )
                );

              }
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: permissionStatus == PermissionStatus.denied ? null :
      FloatingActionButton(
        onPressed: () async {
          var newMeal = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => const AddMeal()));

          if(newMeal == null) {
            return;
          }

          int status = await QueryBuilder.instance.addMeal(newMeal);

          status != 0 ?  setState(() { mealsList.add(newMeal); }) : null;

        },
        child: const Icon(Icons.fastfood_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}