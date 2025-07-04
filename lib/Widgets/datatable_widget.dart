import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';
import 'package:intl/intl.dart';

  import 'dart:io';
  import 'package:image/image.dart' as img;
  import 'package:path_provider/path_provider.dart';
  import 'package:path/path.dart' as path;

class DatatableWidget extends StatefulWidget {
  final List<Vehicle> vehicles;

  const DatatableWidget({super.key, required this.vehicles});

  @override
  State<DatatableWidget> createState() => _DatatableWidgetState();
}

class _DatatableWidgetState extends State<DatatableWidget> {
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();
  int? _sortColumnIndex; 
  bool _isAscending = true; 

  String _selectedCompany = "Ninguno";

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }


  // Convierte cualquier imagen a JPG (recomendado para HEIC)
  Future<File> convertToJPG(File originalFile) async {
    final bytes = await originalFile.readAsBytes();
    final decodedImage = img.decodeImage(bytes);

    if (decodedImage == null) {
      throw Exception('No se pudo decodificar la imagen');
    }

    final jpgBytes = img.encodeJpg(decodedImage);
    final tempDir = await getTemporaryDirectory();
    final newPath = path.join(tempDir.path, '${DateTime.now().millisecondsSinceEpoch}.jpg');
    final newFile = File(newPath);
    return await newFile.writeAsBytes(jpgBytes);
  }

  @override
  Widget build(BuildContext context) {
    final filteredVehicles = _selectedCompany == "Ninguno"
        ? widget.vehicles
        : widget.vehicles.where((e) => e.company.toUpperCase() == _selectedCompany.toUpperCase()).toList();

    return SafeArea(
      child: Scrollbar(
        thumbVisibility: true,
        controller: _horizontalController,
        
        child: SingleChildScrollView(
          controller: _horizontalController,
          scrollDirection: Axis.horizontal,

          child: DataTable(
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _isAscending,
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
              fontSize: 15,
            ),

            dataTextStyle: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
            ),
            
            dataRowColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return const Color(0xFFF97316);
                }
                return Colors.white; 
              },
            ),
            border: TableBorder.all(
              color: const Color(0xFF1E3A8A),
              width: 0.5,
            ),
            columns: _createDataColumn(),
            rows: _createDataRow(filteredVehicles),
          ),
        ),
      ),
    );
  }

  void _sort<T extends Comparable<T>>(T Function(Vehicle vehicle) getField, int columnIndex) {
    setState(() {
      _isAscending = (_sortColumnIndex == columnIndex) ? !_isAscending : true;
      _sortColumnIndex = columnIndex;
      widget.vehicles.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return _isAscending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
      });
    });
  }


  

  List<DataColumn> _createDataColumn(){
    return [
      DataColumn(label: Text("ID")),
      DataColumn(
        label: Text("PATENTE"),
        onSort: (columnIndex, _) => _sort((vehicle) => vehicle.patent, columnIndex),
      ),
      DataColumn(
        label: Text("TECNICO"),
        onSort: (columnIndex, _) => _sort((vehicle) => vehicle.technician, columnIndex),
      ),
      DataColumn(
        label: DropdownButton<String>(
          value: _selectedCompany,
          items: ["Ninguno", "Tecnoquil", "Comunikil", "Tecnomdv"].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: const Color(0xFF1E3A8A),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCompany = newValue!;
            });
          },
          underline: SizedBox.shrink(),
        ),
      ),
      DataColumn(label: Text("MECANICA GENERAL")), 
      DataColumn(label: Text("CAMBIO ACEITE")),     
      DataColumn(label: Text("CAMBIO CORREA")),
      DataColumn(label: Text("VTV")),
      DataColumn(label: Text("CUBIERTAS")),
      DataColumn(label: Text("ORDEN")),
      DataColumn(label: Text("LIMPIEZA")),
      DataColumn(label: Text("AGUA")),
      DataColumn(label: Text("RUEDA DE AUXILIO")),
      DataColumn(label: Text("ACEITE")),
      DataColumn(label: Text("CRIQUE")),
      DataColumn(label: Text("LLAVE CRUZ")),
      DataColumn(label: Text("FECHA")),
      DataColumn(label: Text("EXTINTOR")),
      DataColumn(label: Text("CANDADO")),
      DataColumn(label: Text("IMAGEN")),
      DataColumn(label: Text("COMENTARIO")),
    ];
  }

  List<DataRow> _createDataRow(List<Vehicle> filteredVehicles) {
    const textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
    
    DataCell textCell(String text) => DataCell(Text(text, style: textStyle));
    
    DataCell dateCell(DateTime? date) {
      if (date == null) return textCell("N/A");
      return DataCell(Text(
        DateFormat('dd/MM/yyyy').format(date),
        style: textStyle,
      ));
    }
    
    return filteredVehicles.asMap().entries.map((entry) {
      final index = entry.key + 1;
      final e = entry.value;
      
      return DataRow(cells: [
        textCell(index.toString()),
        textCell(e.patent.toString()),
        textCell(e.technician.toString()),
        textCell(e.company.toString()),
        textCell(e.generalMechanics ?? "N/A"),         
        dateCell(e.oilChange),                          
        dateCell(e.motorBeltChange),
        dateCell(e.vtv),
        dateCell(e.tires),
        textCell(e.order.toString()),
        textCell(e.cleanliness.toString()),
        textCell(e.water.toString()),
        textCell(e.spareTire.toString()),
        textCell(e.oil.toString()),
        textCell(e.jack.toString()),
        textCell(e.crossWrench.toString()),
        DataCell(Text(
          DateFormat('dd/MM/yyyy').format(e.date.toDate()),
          style: textStyle,
        )),
        textCell(e.fireExtinguisher.toString()),
        textCell(e.lock.toString()),
        DataCell(
          e.imageUrl != null
              ? GestureDetector(
                  onTap: () => _showImageLightbox(context, e.imageUrl!),
                  child: Image.network(
                    e.imageUrl!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(Icons.image_not_supported),
        ),
        textCell(e.comment.toString()),
      ]);
    }).toList();
  }
  void _showImageLightbox(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(10),
        child: GestureDetector(
          onTap: Navigator.of(context).pop,
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 2.0,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              width: 700,
              height: 600,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
              errorBuilder: (context, child, stackTrace){
                return Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 100,
                );
              },
            )
          ),
        ),
      )
    );
  }
}