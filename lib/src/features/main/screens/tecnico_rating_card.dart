import 'package:flutter/material.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';

class TecnicoRatingCard extends StatelessWidget {
  final String technicianName;
  final double overallRating;
  final List<Map<String, dynamic>> ticketRatings;

  TecnicoRatingCard({
    required this.technicianName,
    required this.overallRating,
    required this.ticketRatings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.white,
        title: Text('Calificaciones del Técnico', style: AppStyle.txtPoppinsRegular18Black),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            }),
        
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Card(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTechnicianHeader(),
                  Divider(),
                  _buildOverallRating(),
                  SizedBox(height: 16),
                  _buildTicketRatings(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicianHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          technicianName,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Icon(Icons.star, color: Colors.amber, size: 24),
      ],
    );
  }

  Widget _buildOverallRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Calificación General:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 8.0),
        Icon(Icons.star, color: Colors.amber, size: 20),
        SizedBox(width: 4.0),
        Text(
          overallRating.toStringAsFixed(1),
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildTicketRatings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ticketRatings.map((ticket) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ticket: ${ticket['ticketId']}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Fecha: ${ticket['date']}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Cliente: ${ticket['clientName']}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Comentario: ${ticket['comment']}',
                      style: TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  SizedBox(width: 4.0),
                  Text(
                    ticket['rating'].toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
