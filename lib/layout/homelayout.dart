import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled/modules/ArchivedTasks/ArchivedTaskScreen.dart';
import 'package:untitled/modules/DoneTasks/DoneTaskScreen.dart';
import 'package:untitled/modules/NewTask/NewTaskScreen.dart';
import 'package:untitled/shared/cubit/cubit.dart';
import 'package:untitled/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  var titlecontroller =TextEditingController();
  var timecontroller = TextEditingController();
  var datecontroller =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>AppCubit()..CreateDataBase(),
      child: BlocConsumer<AppCubit,AppState>(
        listener:(context,state){
          if(state is InsertDataBaseState)
          {
            Navigator.pop(context);
          }
        } ,
        builder:(context,state){
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
                title: Text('Tasks App'),
              backgroundColor: AppCubit.get(context).iSDark?Colors.black:Colors.blue,
              actions: [
                IconButton(onPressed: ()
                {
                  if(AppCubit.get(context).iSDark){
                    AppCubit.get(context).iSDark = false;
                    AppCubit.get(context).DarkMode();
                  }
                  else{
                    AppCubit.get(context).iSDark = true;
                    AppCubit.get(context).DarkMode();
                  }
                },
                    icon: Icon(Icons.dark_mode_outlined))
              ],
            ),
            body: Container(
              color: AppCubit.get(context).iSDark?Colors.black:Colors.white,
                child: AppCubit.get(context).screens[AppCubit.get(context).currentstate]),
            floatingActionButton: FloatingActionButton(onPressed: ()
            {
              if(AppCubit.get(context).IsBottomSheetShown==true){
                if(formkey.currentState!.validate()){
                  AppCubit.get(context).InsertToDataBase(title: titlecontroller.text, date: datecontroller.text, time: timecontroller.text);
                }
              }
              else{
                scaffoldkey.currentState!.showBottomSheet((context) =>
                    Container(
                      color: AppCubit.get(context).iSDark?Colors.black:Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Form(
                          key: formkey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller:titlecontroller ,
                                keyboardType:TextInputType.text ,
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'title must not be empty';
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: 'Task title',
                                  labelStyle: TextStyle(
                                    color: AppCubit.get(context).iSDark?Colors.white:Colors.black,
                                  ),
                                  prefixIcon: Icon(Icons.title,
                                  color: AppCubit.get(context).iSDark?Colors.white:Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              TextFormField(
                                controller:timecontroller ,
                                keyboardType:TextInputType.datetime ,
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'time must not be empty';
                                  }
                                },
                                onTap: (){
                                  showTimePicker(context: context,
                                      initialTime: TimeOfDay.now()
                                  ).then((value) {
                                    timecontroller.text=value!.format(context).toString();
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Task Time',
                                  labelStyle: TextStyle(
                                      color: AppCubit.get(context).iSDark?Colors.white:Colors.black
                                  ),
                                  prefixIcon: Icon(Icons.watch_later_outlined,
                                  color: AppCubit.get(context).iSDark?Colors.white:Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              TextFormField(
                                controller:datecontroller ,
                                keyboardType:TextInputType.datetime ,
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'date must not be empty';
                                  }
                                },
                                onTap: (){
                                  showDatePicker(context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2025-12-30')
                                  ).then((value) {
                                    datecontroller.text=DateFormat.yMMMd().format(value!);
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Task date',
                                  labelStyle: TextStyle(
                                      color: AppCubit.get(context).iSDark?Colors.white:Colors.black
                                  ),
                                  prefixIcon: Icon(Icons.calendar_today_rounded,
                                  color:AppCubit.get(context).iSDark?Colors.white:Colors.black ,
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                    elevation: 15.0
                ).closed.then((value) {
                  AppCubit.get(context).changeBottomSheetState(isShown: false, icon: Icons.edit);
                });
                AppCubit.get(context).changeBottomSheetState(isShown: true, icon: Icons.add);
              }
            },
              child: Icon(AppCubit.get(context).fabicon,
              color: AppCubit.get(context).iSDark?Colors.black:Colors.white,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: AppCubit.get(context).iSDark?Colors.black:Colors.white,
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).currentstate,
              onTap: (index)
              {
                AppCubit.get(context).changeNavBar(index);
              },
              items:
              [
                BottomNavigationBarItem(icon: Icon(Icons.menu,
                  color: AppCubit.get(context).iSDark?Colors.white:Colors.black,
                ),
                    label: 'Tasks',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline_sharp,
                color: AppCubit.get(context).iSDark?Colors.white:Colors.black,
                ),
                    label: 'Done'
                ),
                BottomNavigationBarItem(icon: Icon(Icons.archive_outlined,
                  color: AppCubit.get(context).iSDark?Colors.white:Colors.black,
                ),
                    label: 'Archived'
                )
              ],
              unselectedItemColor: AppCubit.get(context).iSDark?Colors.white:Colors.black,
            ),
          );
        }
      ),
    );
  }
}
