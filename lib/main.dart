import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (() => FocusScope.of(context).requestFocus(FocusNode())),
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
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

  Text customText(String text, {color = Colors.black, fontSize = 15.0}) {
    return Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontSize: fontSize));
  }
}
