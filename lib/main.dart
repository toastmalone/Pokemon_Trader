import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
    _pokemonTrades.add("Ditto");
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
    var _dittoImage = Image.network("https://i.imgur.com/cq4crmv.png");
    return ListTile(
      leading: _dittoImage,
      title: Text(
        pokemon.toUpperCase(),
        style: _biggerFont,
      ),
    );
  }
}
