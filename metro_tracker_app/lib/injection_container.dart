import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'features/metro_tracking/data/datasources/vehicle_remote_data_source.dart';
import 'features/metro_tracking/data/datasources/route_remote_data_source.dart';
import 'features/metro_tracking/data/repositories/vehicle_repository_impl.dart';
import 'features/metro_tracking/data/repositories/route_repository_impl.dart';
import 'features/metro_tracking/domain/repositories/vehicle_repository.dart';
import 'features/metro_tracking/domain/repositories/route_repository.dart';
import 'features/metro_tracking/presentation/bloc/vehicle_bloc.dart';
import 'features/metro_tracking/presentation/bloc/route_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Metro Tracking

  // Bloc
  sl.registerFactory(() => VehicleBloc(repository: sl()));
  sl.registerFactory(() => RouteBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<VehicleRepository>(
    () => VehicleRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<RouteRepository>(
    () => RouteRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<VehicleRemoteDataSource>(
    () => VehicleRemoteDataSourceImpl(channel: sl()),
  );
  sl.registerLazySingleton<RouteRemoteDataSource>(
    () => RouteRemoteDataSourceImpl(
      client: sl(),
      baseUrl: sl<String>(),
    ),
  );

  // External - WebSocket & HTTP Configuration
  //
  // IMPORTANT: Configure based on your setup:
  //
  // For PHYSICAL Android Device:
  //   - Find your computer's IP address on the local network
  //     Windows: Open CMD and run "ipconfig" → Look for "IPv4 Address" (usually 192.168.x.x)
  //     Mac/Linux: Run "ifconfig" or "ip addr" → Look for your local IP
  //   - Replace 'YOUR_LOCAL_IP' below with your actual IP address
  //   - Make sure your phone and computer are on the SAME WiFi network
  //   - Example: 'http://192.168.1.100:8080'
  //
  // For Android EMULATOR:
  //   - Use '10.0.2.2' (special alias to access host machine from emulator)
  //   - Example: 'http://10.0.2.2:8080'
  //
  // For iOS Simulator or Web:
  //   - Use 'localhost'
  //   - Example: 'http://localhost:8080'

  const bool usePhysicalDevice = true; // Set to false if using Android Emulator
  const String localIpAddress =
      '192.168.29.247'; // Replace with YOUR computer's IP address

  String wsUrlString = 'ws://localhost:8080';
  String httpUrlString = 'http://localhost:8080';

  if (!kIsWeb) {
    if (Platform.isAndroid) {
      if (usePhysicalDevice) {
        // Physical Android device - use local network IP
        wsUrlString = 'ws://$localIpAddress:8080';
        httpUrlString = 'http://$localIpAddress:8080';
      } else {
        // Android Emulator - use special alias
        wsUrlString = 'ws://10.0.2.2:8080';
        httpUrlString = 'http://10.0.2.2:8080';
      }
    }
  }

  final wsUrl = Uri.parse(wsUrlString);

  sl.registerLazySingleton<WebSocketChannel>(
    () => WebSocketChannel.connect(wsUrl),
  );

  // HTTP Client
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Base URL for HTTP requests
  sl.registerLazySingleton<String>(() => httpUrlString);
}
