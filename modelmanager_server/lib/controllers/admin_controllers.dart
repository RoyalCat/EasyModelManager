import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../database/database.dart';
import 'controller.dart';

class StatisticController extends Controller
{
  final Database database;

  StatisticController(this.database);

  @override
  Future<bool> get(HttpRequest request) async {
    request.response.write(json.encode({
      "summarySize": database.getSummaryDataSize()
    }));
    return false;
  }
  
  @override
  Future<bool> post(HttpRequest request) {
    throw UnimplementedError();
  }
  
}