import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:doctor/widgets/MainButton.dart';
import 'package:doctor/widgets/MainInput.dart';
import 'package:doctor/main.dart';

class ContainerProfileInfo extends StatelessWidget {

  const ContainerProfileInfo({Key? key,required this.title, required this.onPressed}) : super(key: key);
final String title;
final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container( padding:EdgeInsets.all(10),
      height: h_s*8.75,width: double.infinity,
      decoration: BoxDecoration(
          color:Colors.white,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${title}",style:TextStyle(fontWeight:FontWeight.bold,fontSize:16)),
            IconButton(icon:Icon(Icons.edit,color:Colors.pink),
                onPressed:onPressed)] ),
    );
  }
}

class BottomSheetContainer extends StatelessWidget {
  final Key? keys;
  final String? initialValue;
  final TextEditingController? controller;
  final  void Function()? onPressed;
  final void Function(String)? onChanged;
  const BottomSheetContainer({Key? key, this.keys, this.initialValue, this.onPressed,
     this.controller, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width:double.infinity,
        height:h_s*75,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        margin: EdgeInsets.all(10),
        child: Form(
          key:keys,
          child: Column(
              children:[
                Expanded(
                  child: ListView(children:[
                    SizedBox(height:10),
                    Center(child: Text("Edit your profile",style:TextStyle(fontWeight:FontWeight.bold,fontSize:18))),

                    MainInput(obscureText: false,
                      initialValue: initialValue,
                      controller: controller,
                      onChanged: onChanged,
                      suffixIcon: IconButton(icon:Icon(Icons.edit),
                        onPressed: (){

                        },),

                    ),
                  ]),
                ),
                SecondaryButton(child: Text("Confirm"), onPressed: onPressed, color: Colors.pink,backgroundColor: Colors.pink,foregroundColor: Colors.white),
                SizedBox(height:10)

              ]
          ),
        )

    );
  }
}

class DialogProfile extends StatelessWidget {
  const DialogProfile({Key? key, this.initialValue, this.profileType,
    this.onPressed, this.onChanged, this.keys, this.validator, this.keyboardType}) : super(key: key);
final String? initialValue;
final String? profileType;
final void Function()? onPressed;
final  void Function(String)? onChanged;
final  String? Function(String?)? validator;
final TextInputType? keyboardType;
  final Key? keys;
  @override
  Widget build(BuildContext context) {
    return Form(
      key:keys,
      child: SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.all(10),
          backgroundColor: Colors.black54,
          children:[
            Text("Change your $profileType",style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold)),
            SecondaryInput(obscureText: false,
              initialValue: initialValue,
              keyboardType: keyboardType,
              onChanged: onChanged,
              validator: validator,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:[
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text("Cancel")),
                  TextButton(onPressed:onPressed, child: Text("Save"))
                ])
          ]),);
  }
}

class DialogLoading extends StatelessWidget {
  const DialogLoading({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.all(10),
        backgroundColor: Colors.black54,
        children:[
    Center(child: SpinKitFadingCube(
    color: Colors.pink,
      size: 30.0,
    ))
          ]
    );
  }
}