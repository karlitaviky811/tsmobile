

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/features/main/screens/tabs_page.dart';
import 'package:tsmobile/src/models/tickets_model.dart';
import 'package:tsmobile/src/providers/tikets_provider.dart';
import 'package:tsmobile/src/widgets/reservation_item.dart';

class Status {
  final int id;
  final String title;

  Status(this.id, this.title);
}

class TicketsListFiltered extends StatefulWidget {
  static const String route = 'technician-route';

  const TicketsListFiltered({super.key});

  @override
  _FilteredListScreenState createState() => _FilteredListScreenState();
}

class _FilteredListScreenState extends State<TicketsListFiltered> {
  List<ServiceTicket> filteredItems = [];
  List<Status> selectedTags = [];
  String searchQuery = "";

  List<Status> tags = [
    Status(0, "Todos"),
    Status(1, "Nuevos"),
    Status(4, "En Progreso"),
    Status(3, "Cerrado"),
  ];

  @override
  void initState() {
    super.initState();
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    
    // Seleccionar "Todos" por defecto
    selectedTags.add(tags.firstWhere((tag) => tag.title == "Todos"));
    
    ticketProvider.loadTickets().then((_) {
      setState(() {
        filteredItems = filterItems(ticketProvider.tickets, selectedTags, searchQuery);
      });
    });
  }

  void updateFilteredItems() {
    setState(() {
      final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
      filteredItems = filterItems(ticketProvider.tickets, selectedTags, searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF3F5FD),
        title: Text(
          'Servicios',
          style: AppStyle.txtPoppinsRegular18Black,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TabsPage()),
            );
          },
        ),
      ),
      body: ticketProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Buscar por título",
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                          updateFilteredItems();
                        });
                      },
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: tags.map((tag) {
                        return FilterChip(
                          label: Text(
                            tag.title,
                            style: TextStyle(
                              fontSize: 16.0,
                              height: 1.4,
                              fontWeight: FontWeight.normal,
                              color: selectedTags.contains(tag)
                                  ? Colors.white
                                  : const Color(0xff051937),
                            ),
                          ),
                          selected: selectedTags.contains(tag),
                          checkmarkColor: Colors.white,
                          selectedColor: const Color(0xff051937),
                          onSelected: (bool selected) {
                            setState(() {
                              if (tag.title == "Todos") {
                                selectedTags.clear();
                                selectedTags.add(tag);
                              } else {
                                if (selectedTags.any((tag) => tag.title == "Todos")) {
                                  selectedTags.removeWhere((tag) => tag.title == "Todos");
                                }
                                if (selected) {
                                  selectedTags.add(tag);
                                } else {
                                  selectedTags.remove(tag);
                                }
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
                                    left: 18.25,
                                    top: 14,
                                    bottom: 14,
                                    right: 15.75),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: const Color(0xffEEEFF1)),
                                ),
                                child: ReservationItemElement(
                                    ticket: filteredItems[index]),
                              ),
                              if (index < filteredItems.length - 1)
                                const SizedBox(
                                  height: 10,
                                ),
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

List<ServiceTicket> filterItems(List<ServiceTicket> items, List<Status> selectedTags, String searchQuery) {
  if (selectedTags.any((tag) => tag.title == "Todos")) {
    return items.where((item) => item.title.contains(searchQuery)).toList(); // Si "Todos" está seleccionado, filtrar por título
  }
  return items.where((item) {
    return selectedTags.any((tag) => item.status == tag.id) && item.title.contains(searchQuery); // Filtrar por id de estatus y título
  }).toList();
}
