import 'dart:async';
import 'dart:io';

abstract class Controller
{
  Future<bool> get (HttpRequest request);
  Future<bool> post(HttpRequest request);
}