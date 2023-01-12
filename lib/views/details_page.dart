import 'dart:io';

import 'package:daily_meal_app/models/meal_day.dart';
import 'package:flutter/material.dart';

class MealDetails extends StatefulWidget {

  final MealDay meal;
  final List foods;

  const MealDetails({
    required this.meal,
    required this.foods,
    Key? key}) : super(key: key);

  @override
  State<MealDetails> createState() => _MealDetailsState();
}

class _MealDetailsState extends State<MealDetails> {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.withOpacity(0.4),
        elevation: 0,
        title: Text(widget.meal.date,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54
            )),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,
            color: Colors.grey[700],),
        ),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.foods.length,
          itemBuilder: (context, index) {

            final food = widget.foods[index][1];

            return Container(
                margin: const EdgeInsets.all(20),
                width: size.width * 0.8,
                height: size.height * 0.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.lightGreen[100],
                    border: Border.all(color: Colors.black12)
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      width: size.width * 0.8,
                      height: size.height * 0.38,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: FileImage(File(food.photo)),
                              fit: BoxFit.fill
                          )
                      ),
                    ),
                    Text(food.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24
                        )),
                    Text(widget.foods[index][0],
                        style: const TextStyle(
                            fontSize: 16
                        )),
                    Text(food.foodType,
                      style: const TextStyle(
                          fontSize: 12
                      ),)
                  ],
                )
            );
          }),
    );
  }
}
