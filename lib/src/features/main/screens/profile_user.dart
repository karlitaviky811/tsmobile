import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/features/main/screens/location_card.dart';
import 'package:tsmobile/src/providers/user_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tsmobile/src/services/user_service.dart';

class ProfileUser extends StatefulWidget {
  static const String route = 'profile-ticket-route';

  const ProfileUser({super.key});

  @override
  _EditProfileWidgetState createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<ProfileUser> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _companyController;
  late TextEditingController _ubicationController;
  late TextEditingController _phoneController;
  final MapController mapController = MapController();
  bool _isFormEnabled = false;
  bool _showSaveButton = false; // Variable para controlar la visibilidad del botón de guardar
  LatLng _selectedLocation =
      LatLng(10.1807, -68.0034); // Coordenadas de ejemplo

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.obatinUserData().then((_) {
      if (userProvider.user != null) {
        _nameController = TextEditingController(text: userProvider.user!.name);
        _emailController =
            TextEditingController(text: userProvider.user!.email);
        _addressController =
            TextEditingController(text: userProvider.user!.address);
        _companyController =
            TextEditingController(text: userProvider.user!.nameComercial);
        _ubicationController =
            TextEditingController(text: userProvider.user!.address);
        _phoneController =
            TextEditingController(text: userProvider.user!.phone);

        // Establecer la ubicación seleccionada a partir de las coordenadas del usuario
        setState(() {
          _selectedLocation = LatLng(double.parse(userProvider.user!.latitude),
              double.parse(userProvider.user!.longitude));
        });
      }
    });
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final serviceUser = new UserService();

      final Map<String, dynamic> data = {
        "User_name": _nameController.text,
        "Email": _emailController.text,
        "latitude": userProvider.user!.latitude,
        "longitude": userProvider.user!.longitude,
        "Address": _addressController.text,
        "Phone": _phoneController.text
      };
      await serviceUser.fetchUserDataUpdate(data);
      //userProvider.
      print(
          'Perfil actualizado: Nombre: ${_nameController.text}, Email: ${_emailController.text}, Teléfono: ${_phoneController.text}');
    }
  }

   @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

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
      body: userProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
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
                        Text('Hola, ${userProvider.user?.name ?? ''}',
                            style: AppStyle.txtPoppinsRegular18Black),
                        const SizedBox(height: 30),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Información de la cuenta',
                                      style: AppStyle.txtPoppinsRegular18Black),
                                  IconButton(
                                    icon: Icon(_showSaveButton ? Icons.edit_off : Icons.edit),
                                    onPressed: () {
                                      setState(() {
                                        _showSaveButton = !_showSaveButton;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Nombre',
                                  prefixIcon: Icon(Icons.person),
                                ),
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, ingresa tu teléfono';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              // Añadir el mapa aquí
                              LocationCard(),
                              const SizedBox(height: 20),
                              if (_showSaveButton)
                                ElevatedButton.icon(
                                  onPressed: _updateProfile,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff051937),
                                    minimumSize:
                                        const Size(150, 50), // Tamaño del botón
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                  ),
                                  label: const Text('Guardar',
                                      style: TextStyle(color: Colors.white)),
                                  icon: const Icon(Icons.save, color: Colors.white),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
