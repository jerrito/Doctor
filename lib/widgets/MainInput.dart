import 'package:flutter/material.dart';


class MainInput extends StatelessWidget {
 final Widget? prefixIcon;
 final Widget? suffixIcon;
 final Widget? icon;
 final String? hintText;
 final Text? label;
 final String? obscure;
 final String? initialValue;
 final bool obscureText;

 final String? Function(String?)? validator;
 final  TextEditingController? controller;
 final TextInputType? keyboardType;
 final void Function(String)? onChanged;
  const MainInput({Key? key, this.prefixIcon, this.suffixIcon,this.icon, this.label,
    this.keyboardType,  this.obscure,  required this.obscureText, this.controller,
    this.hintText, this.validator, this.initialValue, this.onChanged,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      autofocus: false,
      initialValue: initialValue,
      validator: validator,
      controller:controller,
      keyboardType: keyboardType,
    obscuringCharacter:'•',
      obscureText: obscureText,
      cursorColor: Colors.black54,
      decoration: InputDecoration(
          iconColor: Colors.amberAccent,
        hintText: hintText,
        enabledBorder:OutlineInputBorder(
            borderSide:const BorderSide(color:Colors.black54,width:2,style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(20)
        ),
          focusedBorder:OutlineInputBorder(
              borderSide:const BorderSide(color:Colors.amberAccent,width:2,style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(20)
          ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
          label: label,
       labelStyle: TextStyle(color: Colors.black),
        border:OutlineInputBorder(
          borderSide:const BorderSide(color:Colors.black54,width:2,style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(20)
        )
        // ) RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(5),
        // )
      ),

    );
  }
}

class SecondaryInput extends StatelessWidget {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? icon;
  final String? hintText;
  final Text? label;
  final String? obscure;
  final String? initialValue;
  final bool obscureText;

  final String? Function(String?)? validator;
  final  TextEditingController? controller;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  const SecondaryInput({Key? key, this.prefixIcon, this.suffixIcon,this.icon, this.label,
    this.keyboardType,  this.obscure,  required this.obscureText, this.controller,
    this.hintText, this.validator, this.initialValue, this.onChanged,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white,),
      onChanged: onChanged,
      autofocus: true,
      textAlignVertical: TextAlignVertical(y:1),
      textInputAction: TextInputAction.send,
      initialValue: initialValue,
      validator: validator,
      controller:controller,
      keyboardType: keyboardType,
      obscuringCharacter:'•',
      obscureText: obscureText,
      cursorColor: Colors.pink,
      decoration: InputDecoration(
          iconColor: Colors.amberAccent,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
//         enabledBorder: UnderlineInputBorder(
//
//         ),
//         border:  UnderlineInputBorder(
//           borderSide: BorderSide(color:Colors.pink,width: 1,style:BorderStyle.solid),
// borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0))
//         ),


        // ) RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(5),
        // )
      ),

    );
  }
}
