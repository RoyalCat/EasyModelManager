import 'dart:io';

import 'controllers/admin_controllers.dart';
import 'controllers/authorisation.dart';
import 'controllers/model_controllers.dart';
import 'controllers/model_upload.dart';
import 'controllers/restricted_controller.dart';
import 'database/database.dart';
import 'router.dart';

class ModelManagerChannel {
  final Database _database = Database(databaseDirectory: Directory("./database"));
  final Router _router = Router();

  @override
  ModelManagerChannel() {
    _router.route('/signup', [SignupController(_database),]);

    _router.route('/login', [
      RestrictedController(_database),
      LoginController(),
    ]);

    _router.route('/get_models_list', [
      RestrictedController(_database),
      ModelsListController(_database),
    ]);

    _router.route('/upload_model_version', [
      RestrictedController(_database),
      ModelUploadController(_database),
    ]);

    _router.route('/new_model', [
      RestrictedController(_database),
      AddNewModelController(_database),
    ]);


    _router.route('/admin/login', [
      RestrictedController(_database, isAdminOnly: true),
      LoginController(),
    ]);

    _router.route('/admin/get_statistic', [
      RestrictedController(_database, isAdminOnly: true),
      StatisticController(_database),
    ]);
  }

  void handle(HttpRequest request) => _router.handle(request);
}
