import 'package:flutter/material.dart';

class HomeScreenData extends StatelessWidget {
  final int newTicketsCount;
  final int inProgressTicketsCount;
  final int historicalTicketsCount;
  final List<Visit> upcomingVisits;

  HomeScreenData({
    required this.newTicketsCount,
    required this.inProgressTicketsCount,
    required this.historicalTicketsCount,
    required this.upcomingVisits,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Tickets'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTicketCard('Nuevos', Icons.new_releases, [Colors.pink.shade100, Colors.orange.shade100], newTicketsCount, () {
                    // Acción al presionar la tarjeta
                  }),
                  _buildTicketCard('En Proceso', Icons.work, [Colors.blue.shade100, Colors.green.shade100], inProgressTicketsCount, () {
                    // Acción al presionar la tarjeta
                  }),
                  _buildTicketCard('Históricos', Icons.history, [Colors.purple.shade100, Colors.blue.shade100], historicalTicketsCount, () {
                    // Acción al presionar la tarjeta
                  }),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Próximas Visitas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: upcomingVisits.length,
              itemBuilder: (context, index) {
                final visit = upcomingVisits[index];
                return ListTile(
                  leading: const Icon(Icons.date_range),
                  title: Text(visit.clientName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha: ${visit.date}'),
                      Text('Ubicación: ${visit.location}'),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard(String title, IconData icon, List<Color> gradientColors, int count, VoidCallback onPressed) {
    return Expanded(
      child: Card(
        child: InkWell(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Icon(icon, size: 50, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Visit {
  final String date;
  final String clientName;
  final String location;

  Visit({required this.date, required this.clientName, required this.location});
}


