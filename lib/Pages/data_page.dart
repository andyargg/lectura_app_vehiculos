import 'package:carga_camionetas/Widgets/vehicle_list_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_models/shared_models.dart';

class DataPage extends StatefulWidget {

  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  final VehicleRepository _repository = VehicleRepository(FirebaseFirestore.instance);
  List<Vehicle> vehicles = [];


  @override
  void initState() {
    super.initState();
    loadInitialData(); 
  }

  void loadInitialData() async {
    try {
      final loadedVehicles = await _repository.loadVehicles();
      
      setState(() {
        vehicles = loadedVehicles;
      });
    } catch (e) {
      return ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Vehículos por fecha",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 4,
        centerTitle: true,
        
      ),
      body: SafeArea(
        child: Card(
          child: vehicles.isEmpty
            ? Center(child: CircularProgressIndicator())
            : VehicleListWidget(vehicles: groupVehiclesByDate(vehicles)),
        ),
        
      ),
    );
  }

  
  Map<String, List<Vehicle>> groupVehiclesByDate(List<Vehicle> vehicles) {
    final Map<String, List<Vehicle>> groupedVehicles = {};

    for (final vehicle in vehicles) {
      final date = DateFormat('dd/MM/yyyy').format(vehicle.date.toDate());

      if (!groupedVehicles.containsKey(date)){
        groupedVehicles[date] = [];
      }
      groupedVehicles[date]!.add(vehicle);
    }
    return groupedVehicles;

  }
}