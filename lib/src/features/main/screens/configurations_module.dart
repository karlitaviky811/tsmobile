import 'package:flutter/material.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Configuraciones Generales', style: AppStyle.txtPoppinsRegular18Black),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildSectionHeader('Notificaciones'),
                  SwitchListTile(
                    title: Text('Habilitar Notificaciones'),
                    value: true,
                    onChanged: (bool value) {
                      // Lógica para habilitar/deshabilitar notificaciones
                    },
                  ),
                  Divider(),
                  _buildSectionHeader('Contacto con Atención al Cliente'),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('Llamar a Atención al Cliente'),
                    onTap: () {
                      // Lógica para llamar a atención al cliente
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text('Enviar Correo a Atención al Cliente'),
                    onTap: () {
                      // Lógica para enviar correo a atención al cliente
                    },
                  ),
                  Divider(),
                  _buildSectionHeader('Cuenta'),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Darse de Baja'),
                    onTap: () {
                      // Lógica para darse de baja
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirmar Baja'),
                            content: Text('¿Estás seguro de que quieres darte de baja?'),
                            actions: [
                              TextButton(
                                child: Text('Cancelar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Confirmar'),
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
                  Divider(),
                  _buildSectionHeader('Políticas de Seguridad'),
                    ListTile(
              leading: Icon(Icons.security),
              title: Text('Ver Políticas de Seguridad'),
              onTap: () {
                // Lógica para ver políticas de seguridad
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Políticas de Seguridad'),
                      content: SingleChildScrollView(
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
                          child: Text('Cerrar'),
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
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
