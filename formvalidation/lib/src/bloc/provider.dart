import 'package:flutter/material.dart';

import 'package:formvalidation/src/bloc/login_bloc.dart';
export 'package:formvalidation/src/bloc/login_bloc.dart';

import 'package:formvalidation/src/bloc/productos_bloc.dart';
export 'package:formvalidation/src/bloc/productos_bloc.dart';


class Provider extends InheritedWidget {

  final loginBloc      = new LoginBloc();
  final _productosBloc = new ProductosBloc();


  static Provider? _instancia;

  factory Provider( {required Key key, required Widget  child} ){
   
    if ( _instancia == null){
      _instancia = new Provider._internal( key: key, child: child );
    }
    
    return _instancia!;

  }

  Provider._internal ({required Key key, required Widget  child} )
  : super(key: key, child: child);


  

  // Provider( {required Key key, required Widget  child} )
  // : super(key: key, child: child);
  

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
  
  static LoginBloc of ( BuildContext context ){
   return context.dependOnInheritedWidgetOfExactType<Provider>()!.loginBloc;
  }

  static ProductosBloc productosBloc ( BuildContext context ){
   return context.dependOnInheritedWidgetOfExactType<Provider>()!._productosBloc;
  }

}