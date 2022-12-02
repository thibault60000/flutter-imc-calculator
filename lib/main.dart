import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer' as developer;

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
  double? weight;
  int? radioSelected;
  double age = 18;
  double size = 170.0;
  bool gender = false;

  int? calories;
  int? caloriesWithActivity;

  Map mapAcitivities = {0: "Faible", 1: "Modéré", 2: "Intense"};

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (() => FocusScope.of(context).requestFocus(FocusNode())),
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              backgroundColor: setMainColor(),
            ),
            body: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      addPadding(),
                      customText(
                          "Remplissez tous les champs pour obtenir votre besoin journalier en calories"),
                      addPadding(),
                      Card(
                          elevation: 10.0,
                          child: Column(
                            children: [
                              addPadding(),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                              addPadding(),
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
                              addPadding(),
                              customText(
                                  "Votre taille est de ${size.toInt()} cm",
                                  color: setMainColor()),
                              addPadding(),
                              Slider(
                                  value: size,
                                  min: 80.0,
                                  max: 215.0,
                                  activeColor: setMainColor(),
                                  label: size.toString(),
                                  onChanged: (double d) {
                                    setState(() {
                                      size = d;
                                    });
                                  }),
                              addPadding(),
                              TextField(
                                keyboardType: TextInputType.number,
                                onChanged: (String text) {
                                  setState(() {
                                    weight = double.parse(text);
                                  });
                                },
                                decoration: const InputDecoration(
                                    labelText: "Entrez votre poids en Kg"),
                              ),
                              addPadding(),
                              customText("Fréquence d'activité sportive"),
                              addPadding(),
                              rowActivities()
                            ],
                          )),
                      addPadding(),
                      ElevatedButton(
                          onPressed: calculate,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: setMainColor(),
                              foregroundColor: Colors.white),
                          child: customText('Calculer', color: Colors.white)),
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

  Padding addPadding() {
    return const Padding(padding: EdgeInsets.only(top: 20.0));
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

  Row rowActivities() {
    List<Widget> list = [];

    mapAcitivities.forEach(((key, value) => list.add(
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          customText(value),
          Radio(
              value: key,
              groupValue: radioSelected,
              onChanged: (i) {
                setState(() {
                  radioSelected = i!;
                });
              })
        ]))));

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: list);
  }

  void calculate() {
    developer.log('Calculate');

    if (weight != null && radioSelected != null) {
      developer.log('OK');
      if (gender) {
        calories =
            (66.47 + (13.75 * weight!) + (5.0 * size) - (6.75 * age)).toInt();
      } else {
        calories =
            (655.095 + (9.5634 * weight!) + (1.8496 * size) - (4.6756 * age))
                .toInt();
      }

      switch (radioSelected) {
        case 0:
          caloriesWithActivity = (calories! * 1.2).toInt();
          break;
        case 1:
          caloriesWithActivity = (calories! * 1.55).toInt();
          break;
        case 2:
          caloriesWithActivity = (calories! * 1.9).toInt();
          break;
        default:
          caloriesWithActivity = calories;
          break;
      }

      setState(() {
        alertConfirm();
      });
    } else {
      developer.log('PAS OK');
      alertError();
    }
  }

  Future<void> alertConfirm() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (builder) {
          return SimpleDialog(
            title:
                customText("Votre besoin en calories", color: setMainColor()),
            contentPadding: const EdgeInsets.all(10.0),
            children: [
              addPadding(),
              customText("Votre besoin de base est de ${calories} calories"),
              addPadding(),
              customText(
                  "Votre besoin avec activité sportive est de ${caloriesWithActivity} calories"),
              addPadding(),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(builder);
                  },
                  child: customText("OK", color: Colors.white))
            ],
          );
        });
  }

  Future<void> alertError() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (builder) {
          return AlertDialog(
            title: customText('Erreur'),
            content: customText("Tous les champs doivent être remplis"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(builder);
                  },
                  child: customText("OK", color: Colors.red))
            ],
          );
        });
  }
}
