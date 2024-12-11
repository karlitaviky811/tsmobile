import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/features/main/screens/location_card.dart';
import 'package:tsmobile/src/widgets/maps_test.dart';
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
    return SingleChildScrollView(
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalles del Cliente',
                style: AppStyle.txtPoppinsSemiBold18Black,
              ),
              const SizedBox(height: 16),
                  _buildEditableDetailRow(context, 'Dirección:', address),
              _buildPhoneDetailRow(context, 'Teléfono:', phoneNumber),
              _buildDetailRowLarge('Correo:', email),
              _buildDetailRowLarge('Ubicación:', geolocation),
              LocationCard(
                initialCoordinates: LatLng(10.4806, -66.9036),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableDetailRow(
      BuildContext context, String label, String value) {
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
                  style: AppStyle.txtPoppinsSemiBold16Black,
                ),
                Text(
                  value,
                  style: AppStyle.txtPoppinsRegular14Black,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () => _editarDireccion(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneDetailRow(
      BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label ', style: AppStyle.txtPoppinsSemiBold16Black),
          Expanded(
              child: Text(value, style: AppStyle.txtPoppinsRegular14Black)),
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.green),
            onPressed: () => _llamarTelefono(value),
          ),
          IconButton(
            icon: const Icon(Icons.message, color: Colors.green),
            onPressed: () => _enviarMensajeWhatsApp(value),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowLarge(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100, // Ajusta el ancho según sea necesario
            child: Text(
              label,
              style: AppStyle.txtPoppinsBold14Black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppStyle.txtPoppinsRegular14Black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100, // Ajusta el ancho según sea necesario
            child: Text(
              label,
              style: AppStyle.txtPoppinsBold14Black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppStyle.txtPoppinsRegular14Black,
              overflow:
                  TextOverflow.ellipsis, // Añadir si deseas manejar texto largo
            ),
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
        TextEditingController addressController =
            TextEditingController(text: address);

        return AlertDialog(
          title: const Text('Editar Dirección'),
          content: TextField(
            controller: addressController,
            decoration: const InputDecoration(
              hintText: 'Ingrese nueva dirección',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
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

  
}

class MapsDteail extends StatelessWidget {
  const MapsDteail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double latitude = 41.0;
    double longitude = 29.0;
    double zoomLevel = 8.0;
    double zoom = 0;
    /* if (zoomLevel.isFinite) {
      int zoom = zoomLevel.toInt(); // Utiliza el valor de zoom convertido
    } else {
      print('Error: Nivel de zoom no válido');
    }*/
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(latitude, longitude),
        initialZoom: zoomLevel,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
      ],
    );
  }
}
