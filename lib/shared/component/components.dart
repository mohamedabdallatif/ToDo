import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';

Widget buildTaskItem(Map model,context){
 return Dismissible(
   key:  Key(model['id'].toString()),
   onDismissed: (direction) {
     AppCubit.get(context).deleteData(id: model['id']);
   },
   child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children:  [
              CircleAvatar(
              radius: 40.0,
              child: Text('${model['time']}'),
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${model['title']}',
                  style:const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                   Text('${model['date']}',
                  style:const TextStyle(color: Colors.grey),),
                ],
              ),
            )
            ,const SizedBox(width: 10,),
            IconButton(onPressed: (){
              AppCubit.get(context).updateData(status: 'done', id: model['id']);
            }
            , icon: const Icon(Icons.check_box)),
            IconButton(onPressed: (){
              AppCubit.get(context).updateData(status: 'archive', id: model['id']);
            }
            , icon: const Icon(Icons.archive)),
          ],
        ),
      ),
 );
}

Widget tasksBuilder({required List<Map> tasks,required context}){
  return ConditionalBuilder(
          condition: tasks.isNotEmpty,
          builder: (BuildContext context) { 
            return ListView.separated(
          itemBuilder: ((context, index) {
               return   buildTaskItem(tasks[index],context);
          }), 
               separatorBuilder: ((context, index) {
           return Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey[300],
           );
               }),
          itemCount: tasks.length);
           },
          fallback: (BuildContext context) {return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const[
                Icon(Icons.menu,size: 100,color: Colors.grey,),
                Text('NO tasks',style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),)
              ],
            ),
          );  },
        );
}