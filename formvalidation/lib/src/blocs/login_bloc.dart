import 'dart:async';
import 'package:formvalidation/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators{


  final _emailController    = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //Recuperar los datos del stream
  Stream<String> get emailStream    => _emailController.stream.transform( validarEmail );
  Stream<String> get passwordStream => _passwordController.stream.transform( validarPassword );

  Stream<bool> get formValidStream =>
       Rx.combineLatest2(emailStream, passwordStream, (e, p) => true); 

  //Insertar valores al stream
  Function(String) get ChangeEmail    => _emailController.sink.add;
  Function(String) get ChangePassword => _passwordController.sink.add;


  //Obtener el último valor ingresado a los streams
  String get email => _emailController.value;
  String get password => _passwordController.value;

  dispose(){
    _emailController.close();
    _passwordController.close();
  }

}





