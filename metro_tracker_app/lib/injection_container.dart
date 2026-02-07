import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'features/metro_tracking/data/datasources/vehicle_remote_data_source.dart';
import 'features/metro_tracking/data/repositories/vehicle_repository_impl.dart';
import 'features/metro_tracking/domain/repositories/vehicle_repository.dart';
import 'features/metro_tracking/presentation/bloc/vehicle_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Metro Tracking

  // Bloc
  sl.registerFactory(() => VehicleBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<VehicleRepository>(
    () => VehicleRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<VehicleRemoteDataSource>(
    () => VehicleRemoteDataSourceImpl(channel: sl()),
  );

  // External - WebSocket
  // Logic to handle Android Emulator (10.0.2.2) vs others (localhost)
  String wsUrlString = 'ws://localhost:8080';

  if (!kIsWeb) {
    if (Platform.isAndroid) {
      // 10.0.2.2 is special alias to your host loopback interface (127.0.0.1)
      wsUrlString = 'ws://10.0.2.2:8080';
    }
  }

  final wsUrl = Uri.parse(wsUrlString);

  sl.registerLazySingleton<WebSocketChannel>(
    () => WebSocketChannel.connect(wsUrl),
  );
}
