import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/components/components.dart';
import 'package:untitled/shared/cubit/cubit.dart';
import 'package:untitled/shared/cubit/states.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
    listener: (context,state){},
      builder: (context,state){
      return ListView.separated(
          itemBuilder: (context,index)=>buildtaskitem(AppCubit.get(context).newtasks[index],context),
          separatorBuilder: (context,index)=>Padding(
            padding: const EdgeInsetsDirectional.only(
                start: 30.0,
                end: 30.0
            ),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
          ),
          itemCount: AppCubit.get(context).newtasks.length
      );
      },
    );
  }
}
