import 'dart:io';
import 'package:carga_camionetas/Widgets/datatable_widget.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class VehicleListWidget extends StatelessWidget {
  final Map<String, List<Vehicle>> vehicles;

  const VehicleListWidget({super.key, required this.vehicles});

  Future<void> _downloadExcel(BuildContext context, String date, List<Vehicle> vehicles) async {
    String safeDate = date.replaceAll("/", "-");
    
    Directory directory = Directory('/storage/emulated/0/Download');
    
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    
    final Style headerStyle = workbook.styles.add('HeaderStyle');
    headerStyle.bold = true;
    List<String> headers = [
      "ID", "PATENTE", "TECNICO", "EMPRESA", "ORDEN", "LIMPIEZA", 
      "AGUA", "RUEDA DE AUXILIO", "ACEITE", "CRIQUE", "LLAVE CRUZ",
      "FECHA", "EXTINTOR", "CANDADO", "COMENTARIO"
    ];

    for (int col = 0; col < headers.length; col++) {
      sheet.getRangeByIndex(1, col + 1).setText(headers[col]);
      sheet.getRangeByIndex(1, col + 1).cellStyle = headerStyle;
       
    }

    for (int row = 0; row < vehicles.length; row++) {
      Vehicle v = vehicles[row];
      List<dynamic> rowData = [
        row + 1, 
        v.patent, 
        v.technician, 
        v.company, 
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
      int currentWidth = sheet.getColumnWidthInPixels(col + 1); // Returns int
      sheet.setColumnWidthInPixels(col + 1, currentWidth + 20); // Add 20 pixels (int)
    }
    sheet.autoFilters.filterRange = sheet.getRangeByName('B1:D1');

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    
    final String fileName = '${directory.path}/$safeDate.xlsx';
    final File file = File(fileName);
    
    await file.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    
    OpenFile.open(fileName);
  }



  @override
  Widget build(BuildContext context) {
    return ListView(
      children: vehicles.entries.map((entry) {
        final String date = entry.key;
        final List<Vehicle> vehicles = entry.value;
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.black, width: 1.0),
          ),
          child: ExpansionTile(
            
            tilePadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            trailing: IconButton(
              icon: Icon(Icons.download),
              onPressed: () => _downloadExcel(context, date, vehicles),
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