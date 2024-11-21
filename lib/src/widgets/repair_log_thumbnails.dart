import 'package:flutter/material.dart';
import 'dart:io';

Widget buildImageThumbnails(Map<String, dynamic> reparacion) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Imágenes Añadidas:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            if (reparacion['imagenSolicitud'] != '')
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Stack(
                  children: [
                    Image.file(
                      File(reparacion['imagenSolicitud']),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          reparacion['imagenSolicitud'] = '';
                        },
                        child: Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
     
            reparacion['imagenPresupuesto'] != '' ?   Padding(
                padding: const EdgeInsets.all(4.0),
                child: Stack(
                  children: [
                    Image.file(
                      File(reparacion['imagenPresupuesto']),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          reparacion['imagenPresupuesto'] = '';
                        },
                        child: Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ): Container()
            ,
            if (reparacion['imagenReparacion'] != '')
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Stack(
                  children: [
                    Image.file(
                      File(reparacion['imagenReparacion']),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          reparacion['imagenReparacion'] = '';
                        },
                        child: Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ],
  );
}
