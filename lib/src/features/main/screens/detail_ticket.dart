import 'package:flutter/material.dart';
import 'package:tsmobile/src/features/main/widgets/collapsable_list.dart';

class ExpandableOptions extends StatelessWidget {
  const ExpandableOptions({super.key});

  static const String route = 'detail-ticket-route';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detalle ticket'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Stack(children: [Container(), const CollapsibleList()]));
  }
}
