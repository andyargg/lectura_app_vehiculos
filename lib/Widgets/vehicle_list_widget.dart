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
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.black, width: 1.0),
          ),
          child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            title: Text(
              date,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.black
              ),
            ),
            leading: Icon(Icons.calendar_today, color: Colors.blueGrey,),
            backgroundColor: Colors.white,
            childrenPadding: EdgeInsets.only(bottom: 12.0),

            children: [
              //Casi no visible pero por las dudas
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