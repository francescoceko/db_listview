import 'package:db_listview/database/tables/Item.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: _MyHomePageState(),
    );
  }
}

class _MyHomePageState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final itemNumController = TextEditingController();
    final items = List<Item>.generate(
      10,
      (i) => Item("$i", "1", "800012345$i", "Item $i"),
    );

    void _changed(String text) {
      debugPrint(text);
    }

    void _submitted(String text) {
      debugPrint("Subitted $text");
    }

    void _navigateToItemDetails(BuildContext ctx, Item item) {
      if(Navigator.of(ctx).canPop()){
        Navigator.of(ctx).pop();
      }
      Navigator.of(ctx).push(MaterialPageRoute(builder: (BuildContext context){
        return Scaffold(
          appBar: AppBar(
            title: Text("Details"),
          ),
          body: Text("Pippo ${item.itemDesc}", ),
        );
      }));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Main"),
        ),
        body: new Column(
          children: <Widget>[
            TextField(
              maxLength: 50,
              onChanged: _changed,
              onSubmitted: _submitted,
              keyboardType: TextInputType.number,
              controller: itemNumController,
              decoration: InputDecoration(
                  hintText: 'Please enter a search term',
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10)),
            ),
            new Flexible(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return GestureDetector(
                    onTap: () {
                      _navigateToItemDetails(context, item);
                    },
                   child: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              "${item.itemDesc}" ,
                              style: Theme.of(context).textTheme.headline,
                            ),
                            Text(
                              "${item.itemId} - ${item.barcode}" ,
                              style: Theme.of(context).textTheme.subtitle,
                            ),
                          ],

                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            textAlign: TextAlign.center,
                          decoration: InputDecoration(
                          hintText: '0',
                            hintMaxLines: 1
                          )
                            ),
                        ),
                        ),
                    ],
                  )
                  );

//                    Row(
//                      children: <Widget>[
//                        ListTile(
//                          title: Text(
//                            item.itemDesc,
//                            style: Theme.of(context).textTheme.headline,
//                          )
//                      ]
//                  );
//                    ListTile(
//                    title: Text(
//                      item.itemDesc,
//                      style: Theme.of(context).textTheme.headline,
//                    ),
//                    onTap: () {
//                      _navigateToItemDetails(context, item);
//                    },
//                  );
                },
              ),
            ),
          ],
        ));
  }
}

class ItemListTile extends StatefulWidget {
  final Item item;
  @override
  createState() => _ItemListTileState();

  ItemListTile(this.item);
}

class _ItemListTileState extends State<ItemListTile>{
  var color = Colors.pink;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
      title: Text(
        widget.item.itemDesc,
        style: Theme.of(context).textTheme.headline,
      ),
      onTap: () {
        //_navigateToItemDetails(context, widget.item);
        setState(() {
          color = Colors.amber;
        });
      },
    ),
    color: color,
    );
  }
}
