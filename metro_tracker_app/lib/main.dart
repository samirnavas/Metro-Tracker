import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/metro_tracking/presentation/bloc/vehicle_bloc.dart';
import 'features/metro_tracking/presentation/bloc/vehicle_event.dart';
import 'features/metro_tracking/presentation/pages/map_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<VehicleBloc>()..add(StartTracking()),
        ),
      ],
      child: MaterialApp(
        title: 'Metro Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Premium aesthetic colors
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6A1B9A), // Metro Purple
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: const MapPage(),
      ),
    );
  }
}
