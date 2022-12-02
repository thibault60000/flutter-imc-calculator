import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter IMC Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter IMC Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late double weight;
  late double age = 0;
  bool gender = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (() => FocusScope.of(context).requestFocus(FocusNode())),
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              backgroundColor: setMainColor(),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  customText(
                      "Remplissez tous les champs pour obtenir votre besoin journalier en calories"),
                  Card(
                      elevation: 10.0,
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                customText("Femme", color: Colors.pink),
                                Switch(
                                    value: gender,
                                    inactiveTrackColor: Colors.pink,
                                    activeColor: Colors.blue,
                                    onChanged: (bool b) {
                                      setState(() {
                                        gender = b;
                                      });
                                    }),
                                customText("Homme", color: Colors.blue)
                              ]),
                          ElevatedButton(
                              onPressed: () {
                                displayDatePicker();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: setMainColor(),
                                  foregroundColor: Colors.white),
                              child: customText(
                                  (age == 0)
                                      ? "Appuyer pour entrer votre age"
                                      : "Votre age est de ${age.toInt()} ans",
                                  color: Colors.white)),
                          TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (String text) {
                              setState(() {
                                weight = double.parse(text);
                              });
                            },
                            decoration: const InputDecoration(
                                labelText: "Entrez votre poids en Kg"),
                          )
                        ],
                      ))
                ]))));
  }

  Future<void> displayDatePicker() async {
    DateTime? choice = await showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.year,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    if (choice != null) {
      var diffInDays = DateTime.now().difference(choice).inDays;
      var years = (diffInDays / 365);
      setState(() {
        age = years;
      });
    }
  }

  Color setMainColor() {
    if (gender) {
      return Colors.blue;
    }
    return Colors.pink;
  }

  Text customText(String text, {color = Colors.black, fontSize = 15.0}) {
    return Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontSize: fontSize));
  }
}
