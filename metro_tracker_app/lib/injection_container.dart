import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'features/bus_tracking/data/repositories/bus_repository_impl.dart';
import 'features/bus_tracking/domain/repositories/bus_repository.dart';
import 'features/bus_tracking/presentation/bloc/map_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Bus Tracking
  
  // Bloc
  sl.registerFactory(() => MapBloc(busRepository: sl()));

  // Repository
  sl.registerLazySingleton<BusRepository>(
    () => BusRepositoryImpl(channel: sl()),
  );

  // External
  // Connect to the mock backend we created (ws://localhost:8080)
  // Note: For Android Emulator use 'ws://10.0.2.2:8080'
  // For iOS Simulator use 'ws://localhost:8080'
  final wsUrl = Uri.parse('ws://10.0.2.2:8080'); // Defaulting to Android Emulator localhost
  sl.registerLazySingleton<WebSocketChannel>(
    () => WebSocketChannel.connect(wsUrl),
  );
}
