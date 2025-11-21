import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:health_tech_app/src/core/infra/services/router/router_services.dart';



class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GetIt.I.get<RouterService>();

    return MaterialApp.router(
      title: 'Health Tech App',
      routerConfig: router(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
