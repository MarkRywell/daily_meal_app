import 'package:daily_meal_app/models/query_builder.dart';
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

  checkPermissions() async {
    var status = await Permission.camera.status;

    if(status.)

  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: FutureBuilder(
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
                          Container(
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
                      SliverAppBar(
                        title: Text("Daily Meal"),
                        centerTitle: true,
                        backgroundColor: Colors.greenAccent,
                      )
                    ],
                    body: ListView.builder(
                        itemCount: mealsList.length,
                        itemBuilder: (context, index) {

                          final meal = mealsList[index];

                          return ListTile(
                            title: meal.date,
                          );
                        }
                    )
                );

              }
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: Icon(Icons.fastfood_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}