import 'package:carga_camionetas/Pages/data_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    );
    runApp(const MainApp());
  } catch (e) {
    debugPrint('Error inicializando: $e');
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Text('Error inicializando')))));
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DataPage(), 
    );
  }
}