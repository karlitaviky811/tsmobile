import 'package:flutter/material.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/features/main/screens/tab1_page.dart';
import 'package:tsmobile/src/features/main/screens/tabs_page.dart';
import 'package:tsmobile/src/utils/size.utils.dart';
import '../../../widgets/index.dart';

class ReservationsScreenCLient extends StatefulWidget {
  static const String route = 'technician-route';

  const ReservationsScreenCLient({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _FilteredListScreenState createState() => _FilteredListScreenState();
}

class _FilteredListScreenState extends State<ReservationsScreenCLient> {
  List<Item> items = [
    Item("Item 1", ["Nuevos", "tag2"]),
    Item("Item 2", ["Nuevos"]),
    Item("Item 3", ["En proceso", "tag3"]),
    Item("Item 4", ["tag1", "tag3"]),
  ];

  List<String> selectedTags = [];
  List<Item> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = items;
  }

  void updateFilteredItems() {
    setState(() {
      filteredItems = filterItems(items, selectedTags);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF3F5FD),
        title: Text(
          'Servicios',
          style: AppStyle.txtPoppinsRegular18Black,
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TabsPage()),
              );
            }),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: ["Nuevos", "En proceso", "Historico"].map((tag) {
                  return FilterChip(
                    label: Text(tag),
                    selected: selectedTags.contains(tag),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          selectedTags.add(tag);
                        } else {
                          selectedTags.remove(tag);
                        }
                        updateFilteredItems();
                      });
                    },
                  );
                }).toList(),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 18.25, top: 14, bottom: 14, right: 15.75),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xffEEEFF1)),
                          ),
                          child: const ReservationItem(),
                        ),
                        if (index < items.length - 1)
                          const SizedBox(
                            height: 10,
                          )
                        // Cambia el color del separador thickness: 1.0, // Cambia el grosor del separador
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Item> filterItems(List<Item> items, List<String> selectedTags) {
  return items.where((item) {
    return selectedTags.any((tag) => item.tags.contains(tag));
  }).toList();
}

class Item {
  final String name;
  final List<String> tags;

  Item(this.name, this.tags);
}
