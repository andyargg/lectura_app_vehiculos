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

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scrollbar(
        thumbVisibility: true,
        controller: _horizontalController, 
        child: SingleChildScrollView(
          controller: _horizontalController,
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: _createDataColumn(),
            rows: _createDataRow(),
          ),
        ),
      ),
    );
  }
  
  List<DataColumn> _createDataColumn(){
    return [
      DataColumn(
        label: Text("PATENTE"),
      ),
      DataColumn(
        label: Text("TECNICO"),
      ),
      DataColumn(
        label: Text("EMPRESA"),
      ),
      DataColumn(
        label: Text("ORDEN"),
      ),
      DataColumn(
        label: Text("LIMPIEZA"),
      ),
      DataColumn(
        label: Text("AGUA"),
      ),
      DataColumn(
        label: Text("RUEDA DE AUXILIO"),
      ),
      DataColumn(
        label: Text("ACEITE"),
      ),
      DataColumn(
        label: Text("CRIQUE"),
      ),
      DataColumn(
        label: Text("LLAVE CRUZ"),
      ),
      DataColumn(
        label: Text("FECHA"),
      ),
      DataColumn(
        label: Text("EXTINTOR"),
      ),
      DataColumn(
        label: Text("CANDADO"),
      ),
      DataColumn(
        label: Text("IMAGEN"),
      ),
      DataColumn(
        label: Text("COMENTARIO"),
      ),
    ];
  }
  List<DataRow> _createDataRow() {
    return widget.vehicles.map((e){
        // print(e.date.toString());

        return DataRow(cells: [

          DataCell(
            Text(e.patent.toString()),
          ),
          DataCell(
            Text(e.technician.toString()),
          ),
          DataCell(
            Text(e.company.toString()),
          ),
          DataCell(
            Text(e.order.toString()),
          ),
          DataCell(
            Text(e.cleanliness.toString()),
          ),
          DataCell(
            Text(e.water.toString()),
          ),
          DataCell(
            Text(e.spareTire.toString()),
          ),
          DataCell(
            Text(e.oil.toString()),
          ),
          DataCell(
            Text(e.jack.toString()),
          ),
          DataCell(
            Text(e.crossWrench.toString()),
          ),
          DataCell(
            Text(
              DateFormat('dd/MM/yyyy').format(e.date.toDate()),
            )
          ),
          DataCell(
            Text(e.fireExtinguisher.toString()),
          ),
          DataCell(
            Text(e.lock.toString()),
          ),
          DataCell(
            e.imageUrl != null
                ? Image.network(
                    e.imageUrl!,
                    width: 50, 
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image_not_supported), 
          ),
          DataCell(
            Text(e.comment.toString()),
          ),
          
        ]);
      }
    ).toList();
  }
}


