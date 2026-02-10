import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_colors.dart';
import 'features/metro_tracking/presentation/pages/root_screen.dart';
import 'features/metro_tracking/presentation/bloc/vehicle_bloc.dart';
import 'features/metro_tracking/presentation/bloc/vehicle_event.dart';
import 'features/metro_tracking/presentation/bloc/route_bloc.dart';

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
        BlocProvider(
          create: (_) => di.sl<RouteBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Metro Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: GoogleFonts.roboto().fontFamily,
          textTheme: GoogleFonts.robotoTextTheme(),
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            surface: AppColors.surface,
            error: Colors.redAccent,
          ),
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        home: const RootScreen(),
      ),
    );
  }
}
