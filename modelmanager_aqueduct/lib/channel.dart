import 'package:modelmanager_aqueduct/database/database.dart';

import 'controllers/authorisation.dart';
import "controllers/restricted_controller.dart";

import 'modelmanager_aqueduct.dart';

class ModelManagerChannel extends ApplicationChannel {
  Database _database;

  @override
  Future prepare() async {
    _database = Database(databaseDirectory: Directory("./database"));
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router
      .route('/signup')
      .link(() => SignupController(_database));

    router
      .route('/login') 
      .link(() => RestrictedController(_database))
      .link(() => LoginController());

    return router;
  }
}