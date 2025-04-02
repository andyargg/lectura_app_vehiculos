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
  bool _isAscending = true;

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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al cargar vehículos: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Reporte de vehiculos",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2C5282),
        elevation: 4,
        centerTitle: true,
      ),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isAscending = !_isAscending;
                      _sortByDate(vehicles, ascending: _isAscending);
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF2C5282),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Ordenar por fecha",
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(width: 5,),
                      Icon(
                        _isAscending ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.white,
                      )
                    ]
                  ),
                ),
              ),
            ),
            Expanded(
              child: vehicles.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFF97316),
                      )
                    )
                  : VehicleListWidget(vehicles: _mapVehiclesByDate(vehicles)),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<Vehicle>> _mapVehiclesByDate(List<Vehicle> vehicles) {
    _sortByDate(vehicles, ascending: _isAscending); // ¡Pasa _isAscending aquí!
    final Map<String, List<Vehicle>> groupedVehicles = {};

    for (final vehicle in vehicles) {
      final date = DateFormat('dd/MM/yyyy').format(vehicle.date.toDate());
      groupedVehicles.putIfAbsent(date, () => []).add(vehicle);
    }
    return groupedVehicles;
  }

  void _sortByDate(List<Vehicle> vehicles, {bool ascending = true}) {
    vehicles.sort((a, b) {
      final dateA = a.date.toDate();
      final dateB = b.date.toDate();
      return ascending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });
  }
}