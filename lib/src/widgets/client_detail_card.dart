import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class ClienteDetailCard extends StatelessWidget {
  final String address;
  final String phoneNumber;
  final String email;
  final String geolocation;
  final ValueChanged<String> onAddressChanged;

  ClienteDetailCard({
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.geolocation,
    required this.onAddressChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detalles del Cliente',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildEditableDetailRow(context, 'Dirección:', address),
            _buildPhoneDetailRow(context, 'Teléfono:', phoneNumber),
            _buildDetailRow('Correo:', email),
            _buildDetailRow('Geolocalización:', geolocation),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () => _editarDireccion(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: TextStyle(fontSize: 16))),
          IconButton(
            icon: Icon(Icons.phone, color: Colors.green),
            onPressed: () => _llamarTelefono(value),
          ),
          IconButton(
            icon: Icon(Icons.message, color: Colors.green),
            onPressed: () => _enviarMensajeWhatsApp(value),
          ),
        ],
      ),
    );
  }

  void _llamarTelefono(String phoneNumber) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }

  void _enviarMensajeWhatsApp(String phoneNumber) async {
    String whatsappUrl = "whatsapp://send?phone=$phoneNumber";
    await launchUrl(Uri.parse(whatsappUrl));
  }

  void _editarDireccion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController addressController = TextEditingController(text: address);

        return AlertDialog(
          title: Text('Editar Dirección'),
          content: TextField(
            controller: addressController,
            decoration: InputDecoration(
              hintText: 'Ingrese nueva dirección',
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () {
                onAddressChanged(addressController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
