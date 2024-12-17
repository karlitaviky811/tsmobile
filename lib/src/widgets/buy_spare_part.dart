import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class BuySparePart extends StatefulWidget {
  final Map<String, dynamic> reparacion;

  BuySparePart({required this.reparacion});

  @override
  _BuySparePartState createState() => _BuySparePartState();
}

class _BuySparePartState extends State<BuySparePart> {
  final ImagePicker _picker = ImagePicker();
  List<String> imagePaths = [];
  late Map<String, dynamic> reparacion;

  @override
  void initState() {
    super.initState();
    reparacion = Map<String, dynamic>.from(widget.reparacion);
  }

  Future<void> _pickImage(BuildContext context, String imageType) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (imagePaths.length < 5) {
          imagePaths.add(pickedFile.path);
          reparacion[imageType] = pickedFile.path;  // Actualizar el mapa mutable
        } else {
          _showToast(context, 'Solo se pueden cargar hasta 5 imágenes');
        }
      });
    }
  }

  void _showToast(BuildContext context, String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Compra de Repuesto'),
      children: [
        TextField(
          decoration: const InputDecoration(labelText: 'Nombre del repuesto'),
          onChanged: (value) {
            setState(() {
              reparacion['nombreRepuesto'] = value;
            });
          },
        ),
        TextField(
          decoration: const InputDecoration(labelText: 'Monto del repuesto'),
          onChanged: (value) {
            setState(() {
              reparacion['montoRepuesto'] = value;
            });
          },
        ),
        TextField(
          decoration: const InputDecoration(labelText: 'Presupuesto del repuesto'),
          onChanged: (value) {
            setState(() {
              reparacion['presupuestoRepuesto'] = value;
            });
          },
        ),
        ElevatedButton(
          onPressed: () async {
            if (imagePaths.length < 5) {
              await _pickImage(context, 'imagenPresupuestoRepuesto${imagePaths.length}');
            } else {
              _showToast(context, 'Solo se pueden cargar hasta 5 imágenes');
            }
          },
          child: const Text('Adjuntar imágenes'),
        ),
        if (imagePaths.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Imágenes cargadas:', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Wrap(
                children: imagePaths.map((path) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.file(
                      File(path),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario de Reparación',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Formulario de Reparación'),
        ),
        body: Center(
          child: BuySparePart(
            reparacion: {
              'nombreRepuesto': '',
              'montoRepuesto': '',
              'presupuestoRepuesto': '',
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
