import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived.dart';
import 'package:todo/modules/done.dart';
import 'package:todo/modules/tasks.dart';
import 'package:todo/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit():super(AppIntialState());
  static AppCubit get(context){
    return BlocProvider.of(context);
    
  }
  int val = 0; 
  late Database database;
  bool isBottomSheetShown = false;

  IconData fabicon = Icons.edit;

  List<Map> tasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];
  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];

  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  void ChangeIndex(int index){
    val=index;
    emit(AppChangeNavBar());
  }
  void createDataBase() async {
     openDatabase(
      'TODO.db',
      version: 1,
      onCreate: (database, version) async {
        print('DataBase Created');
        await database.execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT)');
        print('Tables Created');
      },
      onOpen: (database) {
        getDataFromDataBase(database);
        print('DataBase Opened');
      },
    ).then((value) {
      database=value;
      emit(AppCreateDataBase());
    });
  }

   insertToDataBase(
      {required title, required time, required date}) async {
     await database.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks(title,time,date,status) VALUES("$title","$time","$date","new")')
          .then((value) {
             print('$value success insert');
             emit(AppInsertDataBase());
              getDataFromDataBase(database);
             }
             )
          .catchError((error) {
        print('error when insert ${error.toString()}');
      });
    });
  }

void getDataFromDataBase(database)  {
  tasks=[];
  doneTasks=[];
  archivedTasks=[];
    emit(AppGetDataBaseLoading());
     database.rawQuery('SELECT * FROM tasks').then((value) {
            value.forEach((element) {
              if(element['status']=='new'){
                tasks.add(element);
              }
              else if(element['status']=='done'){
                doneTasks.add(element);
              }
              else if(element['status']=='archive'){
                archivedTasks.add(element);
              }
              });
              print(tasks);
              print(doneTasks);
              print(archivedTasks);
            emit(AppGetDataBase());
            
        });
  }
  void changeBootomSheetState(
    {required bool isShow,required IconData icon}
  ){
    isBottomSheetShown=isShow;
    fabicon=icon;
    emit(AppChangeBottomSheet());
  }
 void updateData(
    {
      required String status,
      required int id,
    }
  ){
     database.rawUpdate(
    'UPDATE tasks SET status = ? WHERE id = ?',
    [status, id]).then((value) {
      getDataFromDataBase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData(
    {
      required int id,
    }
  ){
     database.rawDelete('DELETE FROM tasks WHERE id = ?',
      [id])
     .then((value) {
      getDataFromDataBase(database);
      emit(AppDeleteDatabaseState());
    });
  }
}