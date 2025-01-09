import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/features/main/screens/detail_ticket_accept_decline_view.dart';
import 'package:tsmobile/src/features/main/screens/tabs_page.dart';
import 'package:tsmobile/src/features/main/screens/ticket_accepted_progress.dart';
import 'package:tsmobile/src/models/tickets_model.dart';
import 'package:tsmobile/src/providers/tikets_provider.dart';
import 'package:tsmobile/src/widgets/reservation_item.dart';

class Status {
  final int id;
  final String? title;

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
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  int _currentPage = 1;
  int? _selectedCardIndex;

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
    
    ticketProvider.loadTickets(page: _currentPage).then((_) {
      setState(() {
        filteredItems = filterItems(ticketProvider.tickets, selectedTags, searchQuery, context);
      });
    });

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
        _loadMoreTickets();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreTickets() async {
    if (!_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
        _currentPage++;
      });

      final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
      await ticketProvider.loadTickets(page: _currentPage);
      setState(() {
        filteredItems = filterItems(ticketProvider.tickets, selectedTags, searchQuery, context);
        _isLoadingMore = false;
      });
    }
  }

  void updateFilteredItems() {
    setState(() {
      final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
      filteredItems = filterItems(ticketProvider.tickets, selectedTags, searchQuery, context);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedCardIndex = index;
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
      body: ticketProvider.isLoading && _currentPage == 1
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 40, // Ajustar la altura del input de búsqueda
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: "Buscar por título",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Ajustar el padding del contenido
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                            updateFilteredItems();
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: tags.map((tag) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: FilterChip(
                              label: Text(
                                tag.title ?? 'Customer name',
                                style: const TextStyle(
                                  fontSize: 14.0, // Tamaño de fuente más pequeño
                                  height: 1.2,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black, // Color de las letras a negro
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Padding más pequeño
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0), // Bordes redondeados
                                side: BorderSide.none, // Quitar el borde
                              ),
                              backgroundColor: selectedTags.contains(tag) ? const Color(0xfffbdb04) : Colors.transparent, // Color de fondo
                              selectedColor: const Color(0xfffbdb04), // Color de fondo cuando está seleccionado
                              checkmarkColor: Colors.black, // Color de la marca de verificación
                              selected: selectedTags.contains(tag),
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
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: filteredItems.length + (_isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == filteredItems.length) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          return GestureDetector(
                            onTap: () {
                              _onItemTapped(index);
                              Future.delayed(const Duration(milliseconds: 200), () {
                                // Navegar al siguiente widget después de un pequeño retraso
                                if (filteredItems[index].status == 1) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TicketDetailPageView(
                                          ticketId: filteredItems[index].id.toString()),
                                    ),
                                  ).then((_) {
                                    // Mantener el borde amarillo al volver
                                    setState(() {});
                                  });
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TicketAcceptedProgressDetailPage(
                                          ticketId: filteredItems[index].id.toString()),
                                    ),
                                  ).then((_) {
                                    // Mantener el borde amarillo al volver
                                    setState(() {});
                                  });
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Card(
                                color: Colors.white, // Establecer el color del Card a blanco
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: _selectedCardIndex == index
                                        ? const Color(0xfffbdb04)
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: TicketItem(
                                    ticket: filteredItems[index],
                                    onTap: () => _onItemTapped(index),
                                  ),
                                ),
                              ),
                            ),
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

List<ServiceTicket> filterItems(List<ServiceTicket> items, List<Status> selectedTags, String searchQuery, BuildContext context) {
  List<ServiceTicket> filteredItems;
  if (selectedTags.any((tag) => tag.title == "Todos")) {
    filteredItems = items.where((item) => item.title.toLowerCase().contains(searchQuery.toLowerCase()) || item.id.toString().contains(searchQuery.toLowerCase()) ).toList();
  } else {
  filteredItems = items.where((item) { return selectedTags.any((tag) => item.status == tag.id) && (item.title.toLowerCase().contains(searchQuery.toLowerCase()) || item.id.toString().contains(searchQuery)); }).toList();
  }

  /*/if (filteredItems.isEmpty) {
    filteredItems = fetchFilteredItems(searchQuery, context);
  }*/

  return filteredItems;
}
/*
List<ServiceTicket> fetchFilteredItems(String searchQuery, BuildContext context) {
  // Aquí puedes implementar la lógica para hacer la petición y obtener los elementos filtrados
  // Este es solo un ejemplo
  var providerTickets = Provider.of<TicketProvider>(context, listen: false);
  final filter 
  providerTickets.searchTicketByTag(searchQuery, filter)
  List<ServiceTicket> fetchedItems = [
    // Elementos obtenidos de la petición
  ];

  return fetchedItems;
}
*/