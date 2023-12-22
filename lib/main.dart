import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slash_task/Bloc/DataStructures.dart';
import 'package:slash_task/Bloc/ProductsBloc.dart';
import 'package:slash_task/Screens/LandingPage.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(
    BlocProvider(
      create: (context) => ProductsBloc(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF191919),
      ),
      home: const LandingPage(),
    );
  }
}
