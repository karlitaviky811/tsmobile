import 'package:flutter/material.dart';
import 'package:tsmobile/src/features/main/widgets/collapsable_list.dart';

class ExpandableOptions extends StatelessWidget {
  const ExpandableOptions({Key? key}) : super(key: key);

  static const String route = 'detail-ticket-route';
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar: AppBar(
        title: Text('Detalle ticket'),
        leading: IconButton( icon: Icon(Icons.arrow_back), onPressed: () { Navigator.pop(context); }),
      ),
        body: const CollapsibleList()

      );
  }
}
