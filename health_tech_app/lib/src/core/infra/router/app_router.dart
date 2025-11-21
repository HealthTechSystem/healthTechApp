import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


final _rootKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

GoRouter buildRouter() {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: "/home", // login é a página inicial
    debugLogDiagnostics: true,
    routes: [

    ]);}
