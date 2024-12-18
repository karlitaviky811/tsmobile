import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:tsmobile/src/models/visit_model.dart';
import 'package:tsmobile/src/widgets/repair_log_card_original.dart';
import 'package:tsmobile/src/widgets/request_part_visit.dart';


class EditVisitPage extends StatefulWidget {
  final Visit visit;
  
  var type;
  
  String ticketId;

  EditVisitPage({super.key,
  
      required this.visit,
      required this.type,
      required String this.ticketId});

  @override
  _EditVisitPageState createState() => _EditVisitPageState();
}

class _EditVisitPageState extends State<EditVisitPage> {
  late TextEditingController _titleController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.visit.title);
    _dateController = TextEditingController(text: widget.visit.visitDate.toLocal().toString().split(' ')[0]);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.visit.visitDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != widget.visit.visitDate) {
      setState(() {
        widget.visit.visitDate = picked;
        _dateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.type == 'Nuevo' ? 'Agregar Nueva Reparación' : 'Editar Reparación'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Información General'),
              Tab(text: 'Solicitudes de Repuesto'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RepairLogCard(reparacion: {}, visit: widget.visit, type: widget.type
            , ticketId: widget.ticketId),
            RepuestoScreen(visit:  widget.visit,),
          ],
        ),
      ),
    );
  }

}