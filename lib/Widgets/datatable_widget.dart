import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';
import 'package:intl/intl.dart';

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
          child: Theme(
            
            data: Theme.of(context).copyWith(
              dataTableTheme: DataTableThemeData(
                headingTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                  fontSize: 12,
                ),
                dataTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ),
            child: DataTable(
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _isAscending,
              columns: _createDataColumn(),
              rows: _createDataRow(filteredVehicles),
            ),
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
              child: Text(value.toUpperCase()),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCompany = newValue!;
            });
          },
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          underline: SizedBox.shrink(),
        ),
      ),
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
    final indexedVehicles = filteredVehicles.asMap().entries.toList();
    return indexedVehicles.map((entry){
      final index = entry.key + 1; 
      final e = entry.value;

      return DataRow(cells: [
        DataCell(Text(index.toString())),
        DataCell(Text(e.patent.toString())),
        DataCell(Text(e.technician.toString())),
        DataCell(Text(e.company.toString())),
        DataCell(Text(e.order.toString())),
        DataCell(Text(e.cleanliness.toString())),
        DataCell(Text(e.water.toString())),
        DataCell(Text(e.spareTire.toString())),
        DataCell(Text(e.oil.toString())),
        DataCell(Text(e.jack.toString())),
        DataCell(Text(e.crossWrench.toString())),
        DataCell(
          Text(DateFormat('dd/MM/yyyy').format(e.date.toDate())),
        ),
        DataCell(Text(e.fireExtinguisher.toString())),
        DataCell(Text(e.lock.toString())),
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
        DataCell(Text(e.comment.toString())),
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
