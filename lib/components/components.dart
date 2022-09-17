import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/shared/cubit/cubit.dart';

Widget buildtaskitem(Map model,context) => Dismissible(
  key: Key('${model['id']}'),
  onDismissed: (direcrion){
    AppCubit.get(context).DeleteFromDataBase(id: model['id']);
  },
  child:   Container(
    color: AppCubit.get(context).iSDark?Colors.black:Colors.white,
    child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
    children: [
     CircleAvatar(
    backgroundColor: Colors.blue,
    radius: 40.0,
    child: Text('${model['time']}',
    style: TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white
    ),
    ),
    ),
     SizedBox(
    width: 20.0,
    ),
     Expanded(
      child:   Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
      Text('${model['title']}',
      style: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
        color: AppCubit.get(context).iSDark?Colors.white:Colors.black
      ),
      ),
      SizedBox(
      height: 7.0,
      ),
      Text('${model['date']}',
      style: TextStyle(
      color: Colors.grey
      ),
      )
      ],
      ),
    ),
     SizedBox(
        width: 20.0,
      ),
      IconButton(
          onPressed: ()
          {
          AppCubit.get(context).UpdateDataBase(status: 'done', id: model['id']);
          },
          icon: Icon(Icons.check_circle,
          color: Colors.blue,
          )
      ),
      IconButton(
          onPressed: (){
            AppCubit.get(context).UpdateDataBase(status: 'archived', id: model['id']);
          },
          icon: Icon(Icons.arrow_circle_down_outlined,
            color: AppCubit.get(context).iSDark?Colors.white:Colors.black,
          )
      )
    ],
    ),
    ),
  ),
);