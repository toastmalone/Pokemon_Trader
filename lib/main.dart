import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon GO Trader',
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      home: Home (),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State createState() => new FirstScreen();
}
class FirstScreen extends State<Home>{

  TextEditingController userIDController = new TextEditingController();

  File jsonFile;
  Directory dir;
  String fileName = "JSONFile.json";
  bool fileExists = false;

  Map<String, dynamic> fileContent;

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      if (fileExists) this.setState(() => fileContent = JSON.decode(jsonFile.readAsStringSync()));
    });
  }

  @override
  void dispose() {
    userIDController.dispose();
    super.dispose();
  }

  void createFile(Map<String, dynamic> content, Directory dir, String fileName) {
    print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(content));
  }

  void writeToFile(String key, String value) {
    print("Writing to file!");
    Map<String, dynamic> content = {key: value};
    if (fileExists) {
      print("File exists");
      Map<String, dynamic> jsonFileContent = json.decode(jsonFile.readAsStringSync());
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(JSON.encode(jsonFileContent));
    } else {
      print("File does not exist!");
      createFile(content, dir, fileName);
    }
    this.setState(() => fileContent = JSON.decode(jsonFile.readAsStringSync()));
    print(fileContent);
  }
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
            new Text(fileContent.toString()),
            new Container(
              margin: const EdgeInsets.all(10.0),
              color: const Color.fromRGBO(255, 104, 112, 10.0),
              width: 300.0,
              height: 110.0,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    children: <Widget>[
                      new TextField(
                        controller: userIDController,
                        decoration: null,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: new RaisedButton(onPressed: () {

                          writeToFile("user", userIDController.text);
                         /* Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SecondScreen()),
                          );*/
                        },
                          child: Text('Login'),
                        ),
                      )
                    ],
                  ),
                ),
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
