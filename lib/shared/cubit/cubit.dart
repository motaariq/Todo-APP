import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled/modules/ArchivedTasks/ArchivedTaskScreen.dart';
import 'package:untitled/modules/DoneTasks/DoneTaskScreen.dart';
import 'package:untitled/modules/NewTask/NewTaskScreen.dart';
import 'package:untitled/shared/cubit/states.dart';

class AppCubit extends Cubit<AppState>{
  AppCubit() : super(AppInitialState());
  static AppCubit get(context)=>BlocProvider.of(context);
  late Database database;
  bool iSDark = false;
  int currentstate =0;
  bool IsBottomSheetShown = false;
  IconData fabicon =Icons.edit;
  List<Map> newtasks =[];
  List<Map> donetasks =[];
  List<Map> archivedtasks =[];

  List<Widget> screens =
  [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];

  void changeNavBar(int index){
    currentstate=index;
    emit(AppNavBarState());
  }
  void changeBottomSheetState({required bool isShown,required IconData icon})
  {
    IsBottomSheetShown = isShown;
    fabicon = icon;
    emit(NavBarState());
  }

  void CreateDataBase()
  {
    openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database,version)
        {
          print('database created');
          database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)').then((value)
          {
            print('table Created');
          }
          ).catchError((error){
            print('Error While Creating Table${error.toString()}');
          });
        },
        onOpen: (database){
          GetDataFromDataBase(database);
          print('database opened');
        }
    ).then((value) {
      database = value;
      emit(CreateDataBaseState());
    });
  }

 InsertToDataBase({required title,required date,required time}) async
  {
    await database.transaction((txn)async
    {
      await txn.rawInsert('INSERT INTO tasks (title,date,time,status) VALUES("$title","$date","$time","new")').then((value) {
        print('$value inserted successfully');
        emit(InsertDataBaseState());
        GetDataFromDataBase(database);
      }).catchError((error){
        print('error while inserting ${error.toString()}');
      });
    }
    );
  }

 void GetDataFromDataBase(database){
    newtasks = [];
    donetasks=[];
    archivedtasks=[];
     database.rawQuery('SELECT *  FROM tasks').then((value) {
       value.forEach((element)
       {
         if(element['status']== 'new'){
           newtasks.add(element);
         }
         else if(element['status']=='done'){
           donetasks.add(element);
         }
         else{
           archivedtasks.add(element);
         }
       });
       emit(GetDataBaseState());
     });
  }

  void UpdateDataBase({required String status,required int id}){
     database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status',id]
    ).then((value) {
      GetDataFromDataBase(database);
      emit(UpdateDataBaseState());
     });
  }

  void DeleteFromDataBase({required int id})async{
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      GetDataFromDataBase(database);
      emit(DeleteDataBaseState());
    });

  }
  void DarkMode(){
    emit(DarkModeState());
    emit(NavBarState());
  }
}