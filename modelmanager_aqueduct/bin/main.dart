import 'package:modelmanager_aqueduct/modelmanager_aqueduct.dart';

Future<void> main() async {
  final app = Application<ModelManagerChannel>()
      ..options.configurationFilePath = "config.yaml"
      ..options.port = 666;

  final count = Platform.numberOfProcessors ~/ 2;
  await app.start(numberOfInstances: count > 0 ? count : 1);

  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}