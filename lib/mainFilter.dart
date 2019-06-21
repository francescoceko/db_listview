import 'package:db_listview/database/bo/Item.dart';
import 'package:db_listview/database/dao/ItemDao.dart';
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
      home: FilteredListWidget(),
    );
  }
}

class FilteredListWidget extends StatefulWidget{

  @override
  createState() => _MyHomePageState();

}

class _MyHomePageState extends State<FilteredListWidget>{

  String filterText = "";

  @override
  Widget build(BuildContext context) {
    final itemNumController = TextEditingController();
    //final itemNumController = TextEditingController(text: filterText);
    //final itemNumController = TextEditingController.fromValue(new TextEditingValue(text: filterText,selection: new TextSelection.collapsed(offset: filterText.length)));


    void _searchChanged(String text) {
      debugPrint(text);
      setState(() {
        filterText = text;
      });
    }

    void _submitted(String text) {
      debugPrint("Subitted $text");
      setState(() {
        filterText = text;
      });
    }

    void _navigateToItemDetails(BuildContext ctx, Item item) {
      if(Navigator.of(ctx).canPop()){
        Navigator.of(ctx).pop();
      }
      Navigator.of(ctx).push(MaterialPageRoute(builder: (BuildContext context){
        return Scaffold(
          appBar: AppBar(
            title: Text(item.itemId),
          ),
          body: Text("Details of Item ${item.itemDesc}", ),
        );
      }));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Main Filter"),
        ),
        body: new Column(
          children: <Widget>[
            TextField(
              maxLength: 50,
              onChanged: _searchChanged,
              onSubmitted: _submitted,
              controller: itemNumController,
              decoration: InputDecoration(
                  hintText: 'Please enter a search term',
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10)),
            ),
            new Flexible(
              child: FutureBuilder <List<Item>>(
                  future: ItemDao.queryFilterRows(filterText),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        final item = snapshot.data[index];
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
                                        keyboardType: TextInputType.number,
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
                      },
                    );
                  }
              ),
            ),
          ],
        ));
  }
}


