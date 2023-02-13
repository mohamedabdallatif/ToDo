import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/component/components.dart';
import 'package:todo/shared/cubit/states.dart';

import '../shared/cubit/cubit.dart';
class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) { 
        return tasksBuilder(tasks: AppCubit.get(context).archivedTasks, context: context);
       },
      
    );
  }
}