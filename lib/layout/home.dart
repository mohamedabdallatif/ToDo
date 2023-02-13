import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:todo/modules/archived.dart';
import 'package:todo/modules/done.dart';
import 'package:todo/modules/tasks.dart';
import 'package:todo/shared/component/constants.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

var scaffoldKey = GlobalKey<ScaffoldState>();
var formKey = GlobalKey<FormState>();

class HomeLayout extends StatefulWidget {


  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  

  
  var titleController = TextEditingController();

  var timeController = TextEditingController();

  var dateController = TextEditingController();

  /* @override
  void initState() {
    createDataBase();
    super.initState();
  } */
  @override
  Widget build(BuildContext context) {
    
    return 
         BlocProvider(
           create: (BuildContext context) { return AppCubit()..createDataBase(); },
           child: BlocConsumer<AppCubit,AppStates>(
             listener: (BuildContext context, state) {  },
             builder: (BuildContext context, Object? state) { 
              AppCubit cubit=AppCubit.get(context);
              return Scaffold(
                   key: scaffoldKey,
                   appBar: AppBar(title: Text(cubit.titles[cubit.val])),
                   body: state  is   AppGetDataBaseLoading?const Center(child: CircularProgressIndicator()) 
                  : cubit.screens[cubit.val],
                   floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    if (formKey.currentState!.validate()) {

                      cubit.insertToDataBase(title: titleController.text,
                       time: timeController.text,
                        date: dateController.text);
                        Navigator.pop(context);
                    }
                  } else {
                  /*  cubit.changeBootomSheetState(isShow: cubit.isBottomSheetShown,
                    icon: cubit.fabicon); */
                    cubit.changeBootomSheetState(isShow: true, icon: Icons.add);
                    scaffoldKey.currentState
                        ?.showBottomSheet((context) {
                          return SingleChildScrollView(
                            child: Container(
                              color: Colors.grey[300],
                              padding: const EdgeInsets.all(20.0),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: titleController,
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'title can\'t br empty';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        label: Text('Task title'),
                                        prefixIcon: Icon(Icons.title),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: timeController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'time can\'t br empty';
                                        }
                                        return null;
                                      },
                                      onTap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) {
                                          timeController.text =
                                              value!.format(context).toString();
                                        });
                                      },
                                      keyboardType: TextInputType.datetime,
                                      decoration: const InputDecoration(
                                        label: Text('Task time'),
                                        prefixIcon: Icon(Icons.timelapse_outlined),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: dateController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'date can\'t br empty';
                                        }
                                        return null;
                                      },
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate:
                                                    DateTime.parse('2022-10-01'))
                                            .then((value) {
                                          dateController.text =
                                              DateFormat.yMMMd().format(value!);
                                        });
                                      },
                                      keyboardType: TextInputType.datetime,
                                      decoration: const InputDecoration(
                                        label: Text('Task Date'),
                                        prefixIcon:
                                            Icon(Icons.calendar_month_outlined),
                                        border: OutlineInputBorder(),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                        .closed
                        .then((value) {
                          cubit.changeBootomSheetState(isShow: false,
                    icon: Icons.edit);
                        });
                        
                  }
                },
                child: Icon(cubit.fabicon)),
                   bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.val,
                onTap: ((value) {
                  cubit.ChangeIndex(value);
                }),
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline), label: 'Done'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive), label: 'Archived')
                ]),
                 );
              },
           ),
         );  
  }

  
}
