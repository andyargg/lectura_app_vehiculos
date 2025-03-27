import 'dart:io';
import 'package:carga_camionetas/Widgets/datatable_widget.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';

class VehicleListWidget extends StatelessWidget {
  final Map<String, List<Vehicle>> vehicles;

  const VehicleListWidget({super.key, required this.vehicles});

  Future<void> _downloadEmptyExcel(BuildContext context, String date) async {
    try {
      // Reemplazar '/' en la fecha por '-'
      String safeDate = date.replaceAll("/", "-");

      // Obtener la carpeta de almacenamiento externo
      Directory directory = Directory('/storage/emulated/0/Download');
      directory ??= await getApplicationDocumentsDirectory();

      // Crear el directorio si no existe
      String filePath = '${directory.path}/$safeDate.xlsx';
      File file = File(filePath);
      await file.create(recursive: true); // Asegurar que el directorio existe

      var excel = Excel.createExcel();
      excel['Hoja1'].cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
          .value = "Archivo vacío";

      await file.writeAsBytes(excel.encode()!);

      print("guardado en ${filePath}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Archivo guardado en: $filePath"))
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al exportar: $e"))
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: vehicles.entries.map((entry) {
        final String date = entry.key;
        final List<Vehicle> vehicles = entry.value;
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.black, width: 1.0),
          ),
          child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            trailing: IconButton(
              icon: Icon(Icons.download),
              onPressed: () => _downloadEmptyExcel(context, date),
            ),
            title: Text(
              date,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.black
              ),
            ),
            leading: Icon(Icons.calendar_today, color: Colors.blueGrey),
            backgroundColor: Colors.white,
            childrenPadding: EdgeInsets.only(bottom: 12.0),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: DatatableWidget(vehicles: vehicles))
            ],
          ),
        );
      }).toList(),
    );
  }
}
