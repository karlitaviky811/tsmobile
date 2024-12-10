import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/features/main/screens/tabs_page.dart';
import 'package:tsmobile/src/models/tickets_model.dart';
import 'package:tsmobile/src/services/service_ticket_service.dart';

import 'package:tsmobile/src/widgets/reservation_item.dart';

class TicketsListFiltered extends StatefulWidget {
  static const String route = 'technician-route';

  const TicketsListFiltered({super.key});

  @override
  _FilteredListScreenState createState() => _FilteredListScreenState();
}

class _FilteredListScreenState extends State<TicketsListFiltered> {
  List<ServiceTicket> items = [];
  List<String> selectedTags = [];
  List<ServiceTicket> filteredItems = [];
  bool _isLoading = true;

  final TicketService _ticketService = TicketService();

 

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    try {
      final items = await _ticketService.fetchServiceTickets();
      setState(() {
        this.items = items;
        filteredItems = items;
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to load items: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void updateFilteredItems() {
    setState(() {
      filteredItems = filterItems(items, selectedTags);
    });
  }

  @override
  Widget build(BuildContext context) {
      final dataTickets = Provider.of<TicketService>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF3F5FD),
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
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
                          label: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 16.0,
                              height: 1.4,
                              fontWeight: FontWeight.normal,
                              color: selectedTags.contains(tag)
                                  ? Colors.white
                                  : Color(0xff051937),
                            ),
                          ),
                          selected: selectedTags.contains(tag),
                          checkmarkColor: Colors.white,
                          selectedColor: Color(0xff051937),
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
                              if (index < items.length - 1)
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

List<ServiceTicket> filterItems(List<ServiceTicket> items, List<String> selectedTags) {
  return items.where((item) {
    return selectedTags.any((tag) => item.title.contains(tag)); // Ajusta la lógica de filtrado según tus datos
  }).toList();
}
