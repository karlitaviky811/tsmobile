import 'package:flutter/material.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/features/main/screens/profile_user.dart';
import 'package:tsmobile/src/features/main/screens/tecnico_rating_card.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Configuraciones Generales',
            style: AppStyle.txtPoppinsRegular18Black),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildSectionHeader('Cuenta'),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Perfil'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileUser()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.star),
                    title: const Text('Calificaciones'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TecnicoRatingCard(
                                  technicianName: 'Carlos Pérez',
                                  overallRating: 4.5,
                                  ticketRatings: const [
                                    const {
                                      'ticketId': 'TICKET12345',
                                      'rating': 5,
                                      'date':
                                          '2024-11-20', // Verifica que la clave sea 'date'
                                      'clientName':
                                          'Ana González', // Verifica que la clave sea 'clientName'
                                      'comment': 'Servicio excelente y rápido',
                                    },
                                    {
                                      'ticketId': 'TICKET12346',
                                      'rating': 4,
                                      'date':
                                          '2024-11-18', // Verifica que la clave sea 'date'
                                      'clientName':
                                          'Luis Martínez', // Verifica que la clave sea 'clientName'
                                      'comment':
                                          'Buen servicio, pero podría mejorar la puntualidad',
                                    },
                                    {
                                      'ticketId': 'TICKET12347',
                                      'rating': 3,
                                      'date':
                                          '2024-11-15', // Verifica que la clave sea 'date'
                                      'clientName':
                                          'María Rodríguez', // Verifica que la clave sea 'clientName'
                                      'comment':
                                          'Servicio aceptable, pero hubo un retraso significativo',
                                    },
                                  ],
                                )),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Cerrar sesión'),
                    onTap: () {
                      // Lógica para darse de baja
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirmar cerrar sesión'),
                            content: const Text(
                                '¿Estás seguro de que quieres cerrar sesión?'),
                            actions: [
                              TextButton(
                                child: const Text('Cancelar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Confirmar'),
                                onPressed: () {
                                  // Lógica para confirmar baja
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const Divider(),
                  _buildSectionHeader('Notificaciones'),
                  SwitchListTile(
                    title: const Text('Habilitar Notificaciones'),
                    value: true,
                    onChanged: (bool value) {
                      // Lógica para habilitar/deshabilitar notificaciones
                    },
                  ),
                  const Divider(),
                  _buildSectionHeader('Contacto con Atención al Cliente'),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Llamar a Atención al Cliente'),
                    onTap: () {
                      // Lógica para llamar a atención al cliente
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Enviar Correo a Atención al Cliente'),
                    onTap: () {
                      // Lógica para enviar correo a atención al cliente
                    },
                  ),
                  const Divider(),
                  _buildSectionHeader('Políticas de Seguridad'),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Ver Políticas de Seguridad'),
                    onTap: () {
                      // Lógica para ver políticas de seguridad
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Políticas de Seguridad'),
                            content: const SingleChildScrollView(
                              child: Text(
                                'Aquí puedes incluir tus políticas de seguridad...\n\n'
                                '1. Protección de Datos\n'
                                '2. Uso de Contraseñas Seguras\n'
                                '3. Políticas de Privacidad\n'
                                '4. Seguridad en la Transferencia de Datos\n'
                                '5. Mantenimiento de la Seguridad\n\n'
                                'Asegúrate de revisar y entender todas las políticas de seguridad antes de continuar.',
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Cerrar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
