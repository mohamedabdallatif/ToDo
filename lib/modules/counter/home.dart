import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/modules/counter/cubit/cubit.dart';
import 'package:todo/modules/counter/cubit/states.dart';
class MyHomePage extends StatelessWidget {



   const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {return CounterCubit(); },
      child: BlocConsumer<CounterCubit,CounterStates>(
        listener: (BuildContext context, Object? state) { 
          if(state is CounterMinusState){print('minus state${state.counter}');}
          if(state is CounterPlusState){print('plus state${state.counter}');}
         },
        builder: (BuildContext context, state) { 
          return Scaffold(
          appBar: AppBar(title: const Text('Counter'),),
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: (){
                 CounterCubit.get(context).Minus();
                }, child: const Text('Minus',style:  TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                const SizedBox(width: 10,),
                 Text('${CounterCubit.get(context).counter}',
                 style: const TextStyle(fontSize: 40,fontWeight: FontWeight.bold)),
                 const SizedBox(width: 10,),
                TextButton(onPressed: (){
                  CounterCubit.get(context).Plus();
                }, child:  const Text('Plus',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold))),
              ],
            ),
          ),
        );
         },
        
      ),
    );
  }
}