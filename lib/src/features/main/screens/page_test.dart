import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RepairLogFormTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TestLogForm();
  }
}

class TestLogForm extends StatefulWidget {
  @override
  _TestLogFormState createState() => _TestLogFormState();
}

class _TestLogFormState extends State<TestLogForm> {
  final List<RepairForm> formularios = [RepairForm()];

  void agregarFormulario() {
    setState(() {
      formularios.add(RepairForm());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...formularios
                    .map(
                        (formulario) => formulario.buildForm(context, setState))
                    .toList(),
              ],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: agregarFormulario,
          child: Text("Agregar nueva fila"),
        ),
      ],
    );
  }
}

class RepairForm {
  DateTime? fechaSeleccionada;
  String? servicioSeleccionado;
  String? insumoSeleccionado;
  bool necesitaRepuesto = false;
  TextEditingController repuestoController = TextEditingController();
  List<XFile>? imagenes;

  void guardarFormulario() {
    print("Fecha seleccionada: $fechaSeleccionada");
    print("Servicio seleccionado: $servicioSeleccionado");
    print("Insumo seleccionado: $insumoSeleccionado");
    print("Necesita repuesto: $necesitaRepuesto");
    if (necesitaRepuesto) {
      print("Descripción del repuesto: ${repuestoController.text}");
      imagenes?.forEach((img) {
        print("Imagen: ${img.path}");
      });
    }
    // Aquí puedes agregar la lógica para guardar los datos en una base de datos o enviarlos a un servidor
  }

  Widget buildForm(BuildContext context, StateSetter setState) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text("Fecha:"),
              trailing: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != fechaSeleccionada) {
                    setState(() {
                      fechaSeleccionada = picked;
                    });
                  }
                },
              ),
              subtitle: Text(
                  fechaSeleccionada?.toLocal().toString().split(' ')[0] ??
                      "Selecciona una fecha"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Servicios",
                  border: OutlineInputBorder(),
                ),
                value: servicioSeleccionado,
                onChanged: (String? newValue) {
                  setState(() {
                    servicioSeleccionado = newValue;
                  });
                },
                items: <String>['Servicio 1', 'Servicio 2']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Insumos",
                  border: OutlineInputBorder(),
                ),
                value: insumoSeleccionado,
                onChanged: (String? newValue) {
                  setState(() {
                    insumoSeleccionado = newValue;
                  });
                },
                items: <String>['Insumo 1', 'Insumo 2']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            CheckboxListTile(
              title: Text("¿Necesita repuesto?"),
              value: necesitaRepuesto,
              onChanged: (bool? value) {
                setState(() {
                  necesitaRepuesto = value ?? false;
                });
              },
            ),
            if (necesitaRepuesto) ...[
              TextField(
                controller: repuestoController,
                decoration: InputDecoration(
                  labelText: "Describa el repuesto",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () async {
                  final ImagePicker _picker = ImagePicker();
                  final List<XFile>? pickedFiles =
                      await _picker.pickMultiImage();
                  setState(() {
                    if (pickedFiles != null) imagenes = pickedFiles;
                  });
                },
                child: Text("Subir imágenes"),
              ),
              imagenes != null
                  ? Column(
                      children: imagenes!
                          .map((file) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Image.file(File(file.path), height: 100),
                              ))
                          .toList(),
                    )
                  : Container(),
            ],
            ElevatedButton(
              onPressed: guardarFormulario,
              child: Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}
