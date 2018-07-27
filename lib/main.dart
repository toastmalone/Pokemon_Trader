
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pokemon_trader_flutter/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';

String cUser;

void main() {
  runApp(MaterialApp(
    title: 'Pokemon GO Trader',
    theme: ThemeData(
      primaryColor: Colors.red,
    ),
    initialRoute: '/login',
    routes: {
      '/': (context) => AvailablePokemonTrades(),
      '/Login': (context) => LoginScreen(),
      '/Post': (context) => CreatePost(),
      '/Manage': (context) => ManagePosts(),
      '/Create': (context) => CreatePost(),
    },
  ));
}

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;
  @override
  State createState() => new LoginScreenState();
}
class LoginScreenState extends State<LoginScreen>{


  TextEditingController userIDController = new TextEditingController();
  String verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Pokemon Trader'),
      ),
      //start of login tree
      body: Center(

        child: new Container(
              margin: const EdgeInsets.all(10.0),
              color: const Color.fromRGBO(255, 104, 112, 10.0),
              width: 300.0,
              height: 110.0,
              child: Center(
                child:  RaisedButton(onPressed: () async{

                  final FirebaseUser currentUser =  await googleSignIn();
                  cUser = currentUser.displayName;
                  print("done");
                    if(currentUser.displayName != null){
                   Navigator.pushNamed(context, '/');
                    }
                  },
                  child: Text('Login'),
                ),
              ),
            ),
      ),
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

    return appBarTemplate(_buildAvailablePokemon(), context);
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

class CreatePost extends StatefulWidget {
  @override
  State createState() => new CreatePostState();
}
class CreatePostState extends State<CreatePost> {
  @override
  Widget build(BuildContext context){
    return new Text("post temp");
  }

}

class ManagePosts extends StatefulWidget{
  @override
  State createState() => new ManagePostsState();
}
class ManagePostsState extends State <ManagePosts>{
  @override
  Widget build(BuildContext context){
    return new Text("post manager");
  }
}

Scaffold appBarTemplate (Widget _body, BuildContext _context){
  Choice _selectedChoice = choices[0];

  void _select (Choice choice) {
    _selectedChoice = choice;
    Navigator.pushNamed(_context, '/' + _selectedChoice.title);
  }
  return Scaffold(
    appBar: AppBar(
      title: Text("Pokemon GO Trader"),
      actions: <Widget>[
        PopupMenuButton<Choice>(
          onSelected: _select,
          itemBuilder: (BuildContext context) {
            return choices.map((Choice choice) {
              return PopupMenuItem<Choice>(
                value: choice,
                child: Text(choice.title),
              );
            }).toList();
          },
        ),
      ],
    ),
    body: _body,
  );
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice> [
  const Choice(title: 'Forum', icon: IconData(0xe875, fontFamily: 'MaterialIcons')),
  const Choice(title: 'Create', icon: IconData(0xe616, fontFamily: 'MaterialIcons')),
  const Choice(title: 'Manage', icon: IconData(0xe616, fontFamily: 'MaterialIcons')),
  const Choice(title: 'Message', icon: IconData(0xe0c9, fontFamily: 'MaterialIcons')),
  const Choice(title: 'SignOut', icon: IconData(0xe879, fontFamily: 'MaterialIcons')),
];