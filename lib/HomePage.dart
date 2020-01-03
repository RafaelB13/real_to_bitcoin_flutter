import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

var api_url = "https://api.hgbrasil.com/finance?format=json&key=7fa83a17";

var bitcoin;
var real;
String result = "";

Future<Map> getData() async {
  http.Response response = await http.get(api_url);
  return json.decode(response.body);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var realField = TextEditingController();
  var resultField = TextEditingController();

  void _realChanged(String text) {
    if (text.isEmpty)
      resultField.text = "";

    double real = double.parse(realField.text);

    resultField.text = (real / bitcoin).toStringAsFixed(8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe0e0e0),
      appBar: AppBar(
        title: Text(
          "Bitcoin To Real Converter",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff263238),
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Loading",
                  style: TextStyle(fontSize: 28),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error",
                    style: TextStyle(fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                bitcoin = snapshot.data["results"]["currencies"]["BTC"]["buy"];

                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Updated Value:",
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "R\$ " + bitcoin.toString(),
                          style: TextStyle(
                            fontSize: 37,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: TextField(
                            autofocus: false,
                            controller: realField,
                            onChanged: _realChanged,
                            style: TextStyle(fontSize: 20),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38, width: 2),
                                borderRadius: BorderRadius.circular(0)
                              ),
                                labelText: "Value in Real",
                                labelStyle: TextStyle(
                                    color: Colors.black38, fontSize: 25),
                                contentPadding: EdgeInsets.all(20),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0))),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: TextField(
                            enabled: false,
                            controller: resultField,
                            onChanged: _realChanged,
                            style: TextStyle(fontSize: 20),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: "Value in Bitcoin",
                                labelStyle: TextStyle(
                                    color: Colors.black38, fontSize: 25),
                                contentPadding: EdgeInsets.all(20),
                                hintText: "Insert a value",
                                hintStyle: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
          }
        },
      ),
    );
  }

}
