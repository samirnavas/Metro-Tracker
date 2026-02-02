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
<<<<<<< HEAD
  // Logic to handle Android Emulator (10.0.2.2) vs others (localhost)
  String wsUrlString = 'ws://localhost:8080';
  
  if (!kIsWeb) {
    if (Platform.isAndroid) {
      wsUrlString = 'ws://10.0.2.2:8080';
    }
  }
  
  final wsUrl = Uri.parse(wsUrlString);
=======
  // Note: For Android Emulator use 'ws://10.0.2.2:8080'
  // For Android Physical Device, use your computer's local IP (e.g., 192.168.1.5)
  // For iOS Simulator and Web use 'ws://localhost:8080'

  // Using local IP for Android physical device connectivity
  final wsUrl =
      Uri.parse('ws://192.168.10.231:8080'); // Change to localhost for web
>>>>>>> 9b040dcf2cf97350f7da21bb943f73795f744148
  sl.registerLazySingleton<WebSocketChannel>(
    () => WebSocketChannel.connect(wsUrl),
  );
  */
}
