import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo/layout/home.dart';
import 'package:todo/shared/bloc_observer.dart';

void main(List<String> args) {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'TODO',
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}