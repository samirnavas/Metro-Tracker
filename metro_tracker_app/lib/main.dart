import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/bus_tracking/presentation/bloc/map_bloc.dart';
import 'features/bus_tracking/presentation/bloc/map_event.dart';
import 'features/bus_tracking/presentation/pages/map_page.dart';
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
          create: (_) => di.sl<MapBloc>()..add(LoadMapEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'KMRL Metro Tracker',
        theme: ThemeData(
          // Premium aesthetic colors
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF005696), // KMRL Blue
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const MapPage(),
      ),
    );
  }
}
