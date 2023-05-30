import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:image_picker/image_picker.dart';


import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;


class ProductoPage extends StatefulWidget {
  const ProductoPage({super.key});
  @override
  State<ProductoPage> createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {

  final formKey     = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<FormState>();

  ProductosBloc? productosBloc;
  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  XFile? foto;

  @override
  Widget build(BuildContext context) {

    productosBloc = Provider.productosBloc(context);


    final prodData = ModalRoute.of(context)!.settings.arguments as ProductoModel?;
    if ( prodData != null ) {
      producto = prodData;
    }
   
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto, 
            ),
          IconButton(
            icon: Icon( Icons.camera_alt),
            onPressed: _tomarFoto, 
            )
        ]
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _mostrarFoto(),
                  _crearNombre(),
                  _crearPrecio(),
                  _crearDisponible(),
                  _crearBoton(),
                ],
            ),
          ),
        )
      ),
    );

  }

  Widget _crearNombre() {

    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText:  'Producto'
      ),
      onSaved: (value) => producto.titulo = value,
      validator: (value) {
        if ( value!.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );

  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText:  'Precio'
      ),
      onSaved: (value) => producto.valor = double.parse(value!),
      validator: (value) {

        if ( utils.isNumeric(value!) ) {
          return null;
        } else {
          return 'Sólo números';
        }

      },
    );
  }

  Widget _crearDisponible() {

    return SwitchListTile(
      value: producto.disponible!, 
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value)=> setState(() {
        producto.disponible = value;
      }),
      );

  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        backgroundColor: Colors.deepPurple,       
      ),   
      label: Text('Guardar', style: TextStyle(color: Colors.white),),
      icon: Icon(Icons.save),
      onPressed: ( _guardando ) ? null : _submit,
    );
  }

  void _submit() async {


    if( !formKey.currentState!.validate() ) return;

    formKey.currentState!.save();
  
    setState(() { _guardando = true; });
    // print( producto.titulo );  // print( producto.valor );  // print( producto.disponible );
    File file = File(foto!.path);
    if ( foto != null ) {
      producto.fotoUrl = await productosBloc?.subirFoto(file);
    }



    if ( producto.id == null ) {
      productosBloc?.agregarProducto(producto);
    } else {
      productosBloc?.editarProducto(producto);
    }

    // setState(() { _guardando = false; });
    mostrarSnackbar('Registro guardado');

    Navigator.pop(context);

  }


    void mostrarSnackbar( String mensaje) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text( mensaje ),
          duration: Duration(milliseconds: 1500),

        ),
        );

    }


Widget _mostrarFoto() {
 
    if (producto.fotoUrl != null) {
 
      return FadeInImage(
        image: NetworkImage( producto.fotoUrl! ),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      );
 
    } else {
 
      if( foto != null ){
        File file = File(foto!.path);
        return Image.file(
          file,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }


_seleccionarFoto() async{

 _procesarImagen(ImageSource.gallery);

}


_tomarFoto() {

 _procesarImagen(ImageSource.camera);
 
}

_procesarImagen(ImageSource origen) async {
final ImagePicker _picker = ImagePicker();
 foto  = await _picker.pickImage(
    source: origen
  );

    if ( foto != null ) {
      producto.fotoUrl = null;
    }      

    setState(() {});

}

}