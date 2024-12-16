import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/models/visit_model.dart';
import 'package:tsmobile/src/providers/visit_provider.dart';
import 'dart:io';
import 'package:tsmobile/src/widgets/repair_card_log.dart';

class RepairLogFormData extends StatefulWidget {
  final String ticketId;

  RepairLogFormData({required this.ticketId});

  @override
  _RepairLogFormDataState createState() => _RepairLogFormDataState();
}

class _RepairLogFormDataState extends State<RepairLogFormData> {
  final ImagePicker _picker = ImagePicker();
  late Future<void> _fetchVisitsFuture;

  @override
  void initState() {
    super.initState();
    _fetchVisitsFuture = _fetchVisits();
  }

  Future<void> _fetchVisits() async {
    final visitProvider = Provider.of<VisitProvider>(context, listen: false);
    await visitProvider.fetchVisits(widget.ticketId);
  }

  Future<void> _selectDate(BuildContext context, Visit visit) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: visit.visitDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != visit.visitDate) {
      setState(() {
        visit.visitDate = picked;
      });
    }
  }

  Future<void> _pickImage(BuildContext context, Visit visit, String tipo) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (tipo == 'solicitud') {
          visit.imageSolicitud = pickedFile.path;
        } else if (tipo == 'presupuesto') {
          visit.imagePresupuesto = pickedFile.path;
        } else if (tipo == 'reparacion') {
          visit.imageReparacion = pickedFile.path;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _fetchVisitsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Consumer<VisitProvider>(
            builder: (context, visitProvider, child) {
              if (visitProvider.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white,
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Bitácora de visitas',
                          textAlign: TextAlign.left,
                          style: AppStyle.txtPoppinsMedium18Black,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: visitProvider.visits.length + 1,
                          itemBuilder: (context, index) {
                            if (index == visitProvider.visits.length) {
                              return Column(
                                children: [
                                  Center(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xff051937),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      onPressed: _agregarNuevaReparacion,
                                      icon: const Icon(Icons.add, color: Colors.white),
                                      label: const Text('Añadir nueva reparación',
                                          style: TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ],
                              );
                            }

                            final visit = visitProvider.visits[index];

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ExpansionTile(
                                title: Text(visit.title.isEmpty
                                    ? 'Nueva reparación'
                                    : visit.title),
                                children: [
                                  /*RepairLogCard(
                                    visit: visit,
                                  ),*/
                                  Container()
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  void _agregarNuevaReparacion() {
    final visitProvider = Provider.of<VisitProvider>(context, listen: false);
    setState(() {
      visitProvider.visits.add(
        Visit(
          id: 0,
          title: 'Nueva reparación',
          type: 1,
          ticketId: 0,
          visitDate: DateTime.now(),
          reprogramming: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    });
  }
}
