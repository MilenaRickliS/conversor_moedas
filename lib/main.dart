import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert';

//configurar api
const requisicao = 'https://api.hgbrasil.com/finance?format=json-cors&key=eb722219';

void main() {
  runApp(
    MaterialApp(
      home: Home(),
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        hintColor: Colors.amber,
        primaryColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}

Future<Map> getData() async{
  http.Response response = await http.get(Uri.parse(requisicao));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() =>  HomeState();
}

class  HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  double dolar = 0;
  double euro = 0;

  void _realChanged(String text){
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text){
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar/euro).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro/dolar).toStringAsFixed(2);
  }

  void _limpar(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _limpar,
          ),
        ],
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          // Verifica o estado da conexão com a API e exibe diferentes widgets de acordo
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Dados ...",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao Carregar Dados ...",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150.0,
                        color: Colors.amber,
                      ),
                      TextField(
                        controller: realController,
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0,
                        ),
                        decoration: InputDecoration(
                          labelText: "Reais",
                          labelStyle: TextStyle(
                            color: Colors.amber,
                            fontSize: 20.0,
                          ),
                          border: OutlineInputBorder(),
                          prefixText: "R\$",
                        ),
                        onChanged: _realChanged,
                        keyboardType: TextInputType.number,
                      ),
                      Divider(),
                      TextField(
                        controller: dolarController,
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0,
                        ),
                        decoration: InputDecoration(
                          labelText: "Doláres",
                          labelStyle: TextStyle(
                            color: Colors.amber,
                            fontSize: 20.0,
                          ),
                          border: OutlineInputBorder(),
                          prefixText: "US\$",
                        ),
                        onChanged: _dolarChanged,
                        keyboardType: TextInputType.number,
                      ),
                      Divider(),
                      TextField(
                        controller: euroController,
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0,
                        ),
                        decoration: InputDecoration(
                          labelText: "Euros",
                          labelStyle: TextStyle(
                            color: Colors.amber,
                            fontSize: 20.0,
                          ),
                          border: OutlineInputBorder(),
                          prefixText: "€",
                        ),
                        onChanged: _euroChanged,
                        keyboardType: TextInputType.number,
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

