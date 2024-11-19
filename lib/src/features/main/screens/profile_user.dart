import 'package:flutter/material.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';

class ProfileUser extends StatefulWidget {
  static const String route = 'profile-ticket-route';

  const ProfileUser({super.key});
  @override
  _EditProfileWidgetState createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<ProfileUser> {
  final _formKey = GlobalKey<FormState>();
  String _name = 'Andrea Torres';
  String _email = 'andreat@gmail.com';
  String _phone = '+5804244984474';
  final _nameController = TextEditingController(text: 'Andrea Torres');
  final _emailController = TextEditingController(text: 'andreat@gmail.com');
  final _addressController = TextEditingController(text: 'Agencia Valencia');
  final _companyController =
      TextEditingController(text: 'Martínez y asociados');
  final _ubicationController = TextEditingController(text: 'Agencia Valencia');
  final _phoneController = TextEditingController(text: '+5804244984474');
  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Aquí puedes agregar la lógica para actualizar el perfil
      print(
          'Perfil actualizado: Nombre: $_name, Email: $_email, Teléfono: $_phone');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Perfil', style: AppStyle.txtPoppinsRegular18Black),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hola, Andrea', style: AppStyle.txtPoppinsRegular18Black),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Información de la cuenta',
                          style: AppStyle.txtPoppinsRegular18Black,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          prefixIcon: Icon(Icons.person),
                        ),
                        onSaved: (value) => _name = value!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingresa tu nombre';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        onSaved: (value) => _email = value!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingresa tu email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Dirección',
                          prefixIcon: Icon(Icons.room),
                        ),
                        onSaved: (value) => _email = value!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingresa tu dirección';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _companyController,
                        decoration: const InputDecoration(
                          labelText: 'Empresa',
                          prefixIcon: Icon(Icons.apartment_sharp),
                        ),
                        onSaved: (value) => _email = value!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingresa tu empresa';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _ubicationController,
                        decoration: const InputDecoration(
                          labelText: 'Sucursal',
                          prefixIcon: Icon(Icons.email),
                        ),
                        onSaved: (value) => _email = value!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingresa tu sucursal';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Teléfono',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        onSaved: (value) => _phone = value!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingresa tu teléfono';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 80),
                      ElevatedButton.icon(
                        onPressed: _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff051937),
                          minimumSize: const Size(150, 50), // Tamaño del botón
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          // Cambia este color al que desees onPrimary: Colors.white, // Color del texto del botón
                        ),
                        label: const Text(
                          'Guardar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
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
