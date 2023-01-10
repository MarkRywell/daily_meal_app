import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class AddMeal extends StatefulWidget {

  const AddMeal({Key? key}) : super(key: key);

  @override
  State<AddMeal> createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {

  var formKey = GlobalKey<FormState>();

  File? image;
  String? filePath;

  DateTime date = DateTime.now();
  String? breakfastFoodType;
  String? lunchFoodType;
  String? dinnerFoodType;

  TextEditingController breakfastController = TextEditingController();
  TextEditingController lunchController = TextEditingController();
  TextEditingController dinnerController = TextEditingController();

  Future <ImageSource?> chooseMedia() async {

    var source = await showDialog(
        context: context,
        builder: (BuildContext context) {

          Size size = MediaQuery.of(context).size;

          return AlertDialog(
              content: Container(
                width: size.width * 0.7,
                height: 100,
                child: Column(
                  children: [
                    Container(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context, ImageSource.camera);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera),
                            SizedBox(width: 20),
                            Text("Camera")
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context, ImageSource.gallery);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo),
                            SizedBox(width: 20),
                            Text("Gallery")
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
          );
        }
    );
    if(source == null) {
      return null;
    };
    pickImage(source);
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
          source: source,
          maxWidth: 200,
          maxHeight: 200
      );

      if(image == null) return;

      final imagePerm = await saveImage(image.path);
      filePath = imagePerm.path;

      print(filePath);

      setState(() => this.image = imagePerm);

    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

  Future <File> saveImage (String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = path.basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.green[100],

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Container(
                    width: size.width,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.grey,
                          width: 1
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('Meal Date',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black.withOpacity(0.6)
                              ),),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text('${date.month}/${date.day}/${date.year}',
                              style: const TextStyle(
                                  fontSize: 16
                              ),),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal
                            ),
                              onPressed: () async {
                                DateTime? newDate = await showDatePicker(
                                    context: context,
                                    initialDate: date,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100)
                                );
                                if(newDate == null){
                                  return;
                                }
                                setState(() {
                                  date = newDate;
                                });
                              },
                              child: const Icon(Icons.calendar_month)),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: ExpansionTile(
                      title: Text("Breakfast"),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: TextFormField(
                          controller: breakfastController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Food Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                            )
                          ),
                          validator: (value) {
                            return value == null || value.isEmpty ? "Complete breakfast details" : null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: DropdownButtonFormField(
                          hint: const Text("Food Type"),
                          dropdownColor: Colors.green[50],
                          borderRadius: BorderRadius.circular(20),
                          items: const [
                            DropdownMenuItem(
                              value: "Fruits and Vegetables",
                              child: Text("Fruits and Vegetables"),
                            ),
                            DropdownMenuItem(
                              value: "Starchy Food",
                              child: Text("Starchy Food"),
                            ),
                            DropdownMenuItem(
                              value: "Dairy",
                              child: Text("Dairy"),
                            ),
                            DropdownMenuItem(
                              value: "Protein",
                              child: Text("Protein"),
                            ),
                            DropdownMenuItem(
                              value: "Fat",
                              child: Text("Fat"),
                            ),
                          ],
                          onChanged: (value) {
                            breakfastFoodType = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: SizedBox(
                            height: 50,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          chooseMedia();
                                        },
                                        icon: const Icon(Icons.upload, color: Colors.teal),
                                        iconSize: 40,
                                        color: Colors.blue
                                    ),
                                    const Padding(
                                        padding: EdgeInsetsDirectional.only(top: 5)),
                                    const Text(
                                      "Upload Photo",
                                      style: TextStyle(fontSize: 20),
                                    )
                                  ],
                                )
                            )
                        ),
                      ),
                      image != null ?
                      Container(
                        constraints: BoxConstraints(
                            minHeight: 150,
                            maxWidth: 150
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)
                        ),
                        child: Image.file(image!), height: 200, width: 200,):
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black)
                        ),
                        child: Center(
                            child: Text("No image selected")),
                        height: 200,
                        width: 200,
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 40,
                            width: size.width * 0.5,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal
                              ),
                              onPressed: () {

                              },
                              child: Text("Add Breakfast",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                              ),),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: ExpansionTile(
                    title: Text("Lunch"),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: TextFormField(
                          controller: breakfastController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: "Food Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)
                              )
                          ),
                          validator: (value) {
                            return value == null || value.isEmpty ? "Complete lunch details" : null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: DropdownButtonFormField(
                          hint: const Text("Food Type"),
                          dropdownColor: Colors.green[50],
                          borderRadius: BorderRadius.circular(20),
                          items: const [
                            DropdownMenuItem(
                              value: "Fruits and Vegetables",
                              child: Text("Fruits and Vegetables"),
                            ),
                            DropdownMenuItem(
                              value: "Starchy Food",
                              child: Text("Starchy Food"),
                            ),
                            DropdownMenuItem(
                              value: "Dairy",
                              child: Text("Dairy"),
                            ),
                            DropdownMenuItem(
                              value: "Protein",
                              child: Text("Protein"),
                            ),
                            DropdownMenuItem(
                              value: "Fat",
                              child: Text("Fat"),
                            ),
                          ],
                          onChanged: (value) {
                            breakfastFoodType = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: SizedBox(
                            height: 50,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          chooseMedia();
                                        },
                                        icon: const Icon(Icons.upload, color: Colors.teal),
                                        iconSize: 40,
                                        color: Colors.blue
                                    ),
                                    const Padding(
                                        padding: EdgeInsetsDirectional.only(top: 5)),
                                    const Text(
                                      "Upload Photo",
                                      style: TextStyle(fontSize: 20),
                                    )
                                  ],
                                )
                            )
                        ),
                      ),
                      image != null ?
                      Container(
                        constraints: BoxConstraints(
                            minHeight: 150,
                            maxWidth: 150
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)
                        ),
                        child: Image.file(image!), height: 200, width: 200,):
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black)
                        ),
                        child: Center(
                            child: Text("No image selected")),
                        height: 200,
                        width: 200,
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 40,
                            width: size.width * 0.5,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal
                              ),
                              onPressed: () {

                              },
                              child: Text("Add Dinner",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15
                                ),),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: ExpansionTile(
                    title: Text("Dinner"),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: TextFormField(
                          controller: breakfastController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: "Food Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)
                              )
                          ),
                          validator: (value) {
                            return value == null || value.isEmpty ? "Complete dinner details" : null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: DropdownButtonFormField(
                          hint: const Text("Food Type"),
                          dropdownColor: Colors.green[50],
                          borderRadius: BorderRadius.circular(20),

                          items: const [
                            DropdownMenuItem(
                              value: "Fruits and Vegetables",
                              child: Text("Fruits and Vegetables"),
                            ),
                            DropdownMenuItem(
                              value: "Starchy Food",
                              child: Text("Starchy Food"),
                            ),
                            DropdownMenuItem(
                              value: "Dairy",
                              child: Text("Dairy"),
                            ),
                            DropdownMenuItem(
                              value: "Protein",
                              child: Text("Protein"),
                            ),
                            DropdownMenuItem(
                              value: "Fat",
                              child: Text("Fat"),
                            ),
                          ],
                          onChanged: (value) {
                            breakfastFoodType = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: SizedBox(
                            height: 50,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          chooseMedia();
                                        },
                                        icon: const Icon(Icons.upload, color: Colors.teal),
                                        iconSize: 40,
                                        color: Colors.blue
                                    ),
                                    const Padding(
                                        padding: EdgeInsetsDirectional.only(top: 5)),
                                    const Text(
                                      "Upload Photo",
                                      style: TextStyle(fontSize: 20),
                                    )
                                  ],
                                )
                            )
                        ),
                      ),
                      image != null ?
                      Container(
                        constraints: BoxConstraints(
                            minHeight: 150,
                            maxWidth: 150
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)
                        ),
                        child: Image.file(image!), height: 200, width: 200,):
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black)
                        ),
                        child: Center(
                            child: Text("No image selected")),
                        height: 200,
                        width: 200,
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 40,
                            width: size.width * 0.5,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal
                              ),
                              onPressed: () {

                              },
                              child: Text("Add Dinner",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15
                                ),),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 40,
                      width: size.width * 0.5,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal
                        ),
                        onPressed: () {

                        },
                        child: Text("Add Meal",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          ),),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
