
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pokemon_trader_flutter/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Pokemon GO Trader',
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      home: new Home(title: 'Pokemon Trader Login'),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;
  @override
  State createState() => new FirstScreen();
}

class FirstScreen extends State<Home>{

  Future<String> _message = new Future<String>.value('');
  TextEditingController _smsCodeController = new TextEditingController();
  TextEditingController userIDController = new TextEditingController();
  String verificationId;

  final String testSmsCode = '888888';
  final String testPhoneNumber = '+1 775-683-7319';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Pokemon Trader'),
      ),
      //start of login tree
      body: Center(

        child: Column(
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.all(10.0),
              color: const Color.fromRGBO(255, 104, 112, 10.0),
              width: 300.0,
              height: 110.0,
              child: Column(
                children: <Widget>[
                  new TextField(
                    controller: userIDController,
                    decoration: null,
                  ),
                  new RaisedButton(onPressed: () async{

                        final FirebaseUser currentUser =  await googleSignIn();
                        print(currentUser.displayName);
                        print("done");

                   /* Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondScreen()),
                    );*/
                  },
                    child: Text('Login'),
                  ),
                  new FutureBuilder<String>(
                  future: _message,
                  builder: (_, AsyncSnapshot<String> snapshot) {
                    return new Text(snapshot.data ?? '',
                        style: const TextStyle(
                            color: const Color.fromARGB(255, 0, 155, 0)));
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}
class SecondScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon GO Trader',
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      home: AvailablePokemonTrades(),
    );
  }
}
class AvailablePokemonTrades extends StatefulWidget {
  @override
  createState() => AvailablePokemonTradesState();
}
class AvailablePokemonTradesState extends State<AvailablePokemonTrades> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _pokemonTrades = <String>[];

  @override
  Widget build(BuildContext context) {
    _pokemonTrades.add("charmander");
    print(_pokemonTrades.length);

    return Scaffold(
      appBar: AppBar(
        title: Text("Pokemon GO Trader"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: null,
          ),
        ],
      ),
      body: _buildAvailablePokemon(),
    );
  }

  Widget _buildAvailablePokemon() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        // Add a one-pixel-high divider widget before each row in theListView.
        if (i.isOdd) {
          return Divider();
        }
        final index = i ~/ 2;
        print("Index: " + index.toString());
        print("I: " + i.toString());
        return _buildRow(_pokemonTrades[0]);
      },
      itemCount: _pokemonTrades.length * 2,
      addRepaintBoundaries: true,
    );
  }

  Widget _buildRow(String pokemon) {
    return new FutureBuilder(
      future: getPokemonSprite(pokemon),
      initialData: "Doot...",
      builder: (BuildContext context, AsyncSnapshot<String> text) {
        var _spriteURL = text.data;
        print(_spriteURL);
        Image _pokemonSprite = Image.network(_spriteURL.toString());
        return ListTile(
          leading: _pokemonSprite,
          title: Text(
            pokemon.toUpperCase(),
            style: _biggerFont,
          ),
        );
      },
    );
  }

  Future<String> getPokemonSprite(String pokemon) async
  {
    var url = "https://pokeapi.co/api/v2/pokemon/" + pokemon + "/";
    print("URL " + url);
    var spriteURL;
    await http.get(url)
        .then((response) {
      Map<String, dynamic> _pokemonSprite = json.decode(response.body);
      //print(_pokemonSprite['sprites']['front_default']);
      spriteURL = _pokemonSprite['sprites']['front_default'];
      print(spriteURL);
    });
    print(spriteURL);
    return spriteURL;
  }
}
