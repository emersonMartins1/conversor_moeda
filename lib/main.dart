import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  runApp(MaterialApp(
    home: const Home(),
    theme: ThemeData(
      hintColor: Colors.green,
      primaryColor: Colors.white,
    ),
  ));
}

Future<Map> getData() async {
  String request = 'https://api.hgbrasil.com/finance?format=json&key=c7fa0317';

  var url = Uri.parse(request);
  http.Response response = await http.get(url);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  late double cotacaoDolarReal;
  late double cotacaoEuroDolar;

  void _clearAll() {
    realController.clear();
    dolarController.clear();
    euroController.clear();
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double real = double.parse(text);
    dolarController.text = (real / cotacaoDolarReal).toStringAsFixed(2);
    euroController.text = (real / cotacaoEuroDolar).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double dolar = double.parse(text);
    realController.text = (dolar * cotacaoDolarReal).toStringAsFixed(2);
    euroController.text =
        (dolar * cotacaoDolarReal / cotacaoEuroDolar).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double euro = double.parse(text);
    realController.text = (euro * cotacaoEuroDolar).toStringAsFixed(2);
    dolarController.text =
        (euro * cotacaoEuroDolar / cotacaoDolarReal).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Conversor de moeda"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text(
                  'Aguarde...',
                  style: TextStyle(color: Colors.green, fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Ops, houve uma falha ao buscar os dados',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                cotacaoDolarReal =
                    snapshot.data!['results']['currencies']['USD']['buy'];
                cotacaoEuroDolar =
                    snapshot.data!['results']['currencies']['EUR']['buy'];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.attach_money,
                        size: 180,
                        color: Colors.green,
                      ),
                      buildTextField(
                        'Reais',
                        'R\$ ',
                        realController,
                        _realChanged,
                      ),
                      const Divider(),
                      buildTextField(
                        'Doláres',
                        'US\$ ',
                        dolarController,
                        _dolarChanged,
                      ),
                      const Divider(),
                      buildTextField(
                        'Euros',
                        '€ ',
                        euroController,
                        _euroChanged,
                      ),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(
    String label,
    String prefix,
    TextEditingController textEditingController,
    Function(String text) function) {
  return TextField(
    controller: textEditingController,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.green),
      border: const OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: const TextStyle(
      color: Colors.green,
      fontSize: 25,
    ),
    onChanged: function,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
  );
}
