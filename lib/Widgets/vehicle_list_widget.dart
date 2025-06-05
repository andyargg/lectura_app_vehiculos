import 'dart:io';
import 'package:carga_camionetas/Widgets/datatable_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class VehicleListWidget extends StatefulWidget {
  final Map<String, List<Vehicle>> vehicles;

  final void Function(String) onDeleteVehicle;
  const VehicleListWidget({super.key, required this.vehicles, required this.onDeleteVehicle,});
  @override
  State<VehicleListWidget> createState() => _VehicleListWidgetState();
}

class _VehicleListWidgetState extends State<VehicleListWidget> {

  Future<void> _downloadExcel(BuildContext context, String date, List<Vehicle> vehicles) async {
    final BuildContext capturedContext = context;
    try {
      String safeDate = date.replaceAll("/", "-");

      final Directory? downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        throw Exception("No se pudo obtener la carpeta de Descargas.");
      }

      final String filePath = '${downloadsDir.path}/$safeDate.xlsx';

      final xlsio.Workbook workbook = xlsio.Workbook();
      final xlsio.Worksheet sheet = workbook.worksheets[0];

      final xlsio.Style headerStyle = workbook.styles.add('HeaderStyle');
      headerStyle.bold = true;

      // ACTUALIZADO: Agregamos los nuevos campos
      List<String> headers = [
        "ID", "PATENTE", "TECNICO", "EMPRESA", "MECANICA GENERAL", 
        "CAMBIO ACEITE", "CAMBIO CORREA", "ORDEN", "LIMPIEZA", 
        "AGUA", "RUEDA DE AUXILIO", "ACEITE", "CRIQUE", "LLAVE CRUZ",
        "FECHA", "EXTINTOR", "CANDADO", "COMENTARIO"
      ];

      for (int col = 0; col < headers.length; col++) {
        sheet.getRangeByIndex(1, col + 1).setText(headers[col]);
        sheet.getRangeByIndex(1, col + 1).cellStyle = headerStyle;
      }

      for (int row = 0; row < vehicles.length; row++) {
        Vehicle v = vehicles[row];
        
        // Helper function para formatear fechas
        String formatDate(DateTime? date) {
          return date != null ? DateFormat('dd/MM/yyyy').format(date) : "N/A";
        }
        
        // ACTUALIZADO: Agregamos los nuevos campos
        List<dynamic> rowData = [
          row + 1, 
          v.patent, 
          v.technician, 
          v.company, 
          v.generalMechanics ?? "N/A",           // AGREGADO
          formatDate(v.oilChange),               // AGREGADO
          formatDate(v.motorBeltChange),         // AGREGADO
          v.order, 
          v.cleanliness, 
          v.water, 
          v.spareTire, 
          v.oil, 
          v.jack, 
          v.crossWrench,
          DateFormat('dd/MM/yyyy').format(v.date.toDate()), 
          v.fireExtinguisher, 
          v.lock, 
          v.comment
        ];

        for (int col = 0; col < rowData.length; col++) {
          sheet.getRangeByIndex(row + 2, col + 1).setText(rowData[col].toString());
        }
      }

      for (int col = 0; col < headers.length; col++) {
        sheet.autoFitColumn(col + 1);
        int currentWidth = sheet.getColumnWidthInPixels(col + 1);
        sheet.setColumnWidthInPixels(col + 1, currentWidth + 20);
      }

      sheet.autoFilters.filterRange = sheet.getRangeByName('B1:D1');

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      final File file = File(filePath);
      await file.create(recursive: true);
      await file.writeAsBytes(bytes, flush: true);

      if (mounted) {
        SnackBarWidget.showSuccess(capturedContext, "Descargado correctamente en Descargas");
      }

      await OpenFile.open(file.path);

    } catch (e) {
      if (mounted) {
        SnackBarWidget.showError(capturedContext, "Error al descargar: $e");
      }
    }
  }

  void _confirmDelete(BuildContext context, String date) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Confirmar eliminacion',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        content: Text(
          '¿Estas seguro de eliminar el vehiculo?',
          style: TextStyle(
            fontSize: 16
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: Colors.grey
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              widget.onDeleteVehicle(date);
              Navigator.pop(context);
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(
                color: Colors.red
              ),
            )
          )

        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.vehicles.entries.map((entry) {
        
        final String date = entry.key;
        final List<Vehicle> vehicles = entry.value;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          color: const Color(0xFFF3F4F6),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
          ),

          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            trailing: Row(
              mainAxisSize: MainAxisSize.min, // Para que no ocupe todo el espacio
              children: [
                IconButton(
                  icon: const Icon(Icons.download_rounded, color: Color(0xFFF97316)),
                  onPressed: () => _downloadExcel(context, date, vehicles),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () => _confirmDelete(context, date),
                ),
              ],
            ),
            
            title: Text(
              date,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Color(0xFF2C5282)
              ),
            ),
            
            leading: const Icon(Icons.calendar_today, color: Color(0xFFF97316)),
            backgroundColor: const Color.fromRGBO(226, 232, 240, 0.3),
            childrenPadding: const EdgeInsets.only(bottom: 12.0),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: DatatableWidget(vehicles: vehicles)
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}