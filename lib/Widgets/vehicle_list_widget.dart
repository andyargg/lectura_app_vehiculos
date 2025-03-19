import 'package:carga_camionetas/Widgets/datatable_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';

class VehicleListWidget extends StatelessWidget {
  final Map<String, List<Vehicle>> vehicles;

  const VehicleListWidget({super.key, required this.vehicles});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: vehicles.entries.map((entry) {
        final String date = entry.key;
        final List<Vehicle> vehicles = entry.value;

        return ExpansionTile(
          title: Text("Fecha: $date"),
          children: vehicles.map((vehicle) {
            return ExpansionTile(
              title: Text("Patente: ${vehicle.patent}"),
              children: [
                DatatableWidget(vehicles: [vehicle],)
              ],
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  
}