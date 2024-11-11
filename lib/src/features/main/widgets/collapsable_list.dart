import 'package:flutter/material.dart';

class CollapsibleList extends StatefulWidget {
  const CollapsibleList({super.key});

  @override
  _CollapsibleListState createState() => _CollapsibleListState();
}

class _CollapsibleListState extends State<CollapsibleList> {
  List<Item> _data = generateItems(5);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _data.map<Widget>((Item item) {
        return ExpansionTile(
          title: Text(item.headerValue),
          children: item.expandedValue.map<Widget>((String value) {
            return ListTile(
              title: Text(value),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
  });

  List<String> expandedValue;
  String headerValue;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Encabezado $index',
      expandedValue: List<String>.generate(3, (int j) => 'Elemento $index.$j'),
    );
  });
}
