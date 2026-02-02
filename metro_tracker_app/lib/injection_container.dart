import 'package:get_it/get_it.dart';
import 'features/bus_tracking/data/repositories/mock_local_bus_repository.dart';
import 'features/bus_tracking/domain/repositories/bus_repository.dart';
import 'features/bus_tracking/presentation/bloc/map_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Bus Tracking

  // Bloc
  sl.registerFactory(() => MapBloc(busRepository: sl()));

  // Repository
  // SWITCHED TO LOCAL MOCK to avoid 'npm' dependency for now
  // sl.registerLazySingleton<BusRepository>(
  //   () => BusRepositoryImpl(channel: sl()),
  // );

  // Use local mock generator
  sl.registerLazySingleton<BusRepository>(
    () => MockLocalBusRepository(),
  );

  // External - WebSocket not needed for local mock
  /*
  // Connect to the mock backend we created (ws://localhost:8080)
  // Logic to handle Android Emulator (10.0.2.2) vs others (localhost)
  String wsUrlString = 'ws://localhost:8080';
  
  if (!kIsWeb) {
    if (Platform.isAndroid) {
      wsUrlString = 'ws://10.0.2.2:8080';
    }
  }
  
  final wsUrl = Uri.parse(wsUrlString);
  sl.registerLazySingleton<WebSocketChannel>(
    () => WebSocketChannel.connect(wsUrl),
  );
  */
}
