import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:doctor/MainInput.dart';
import 'package:doctor/MainButton.dart';
import 'package:doctor/Size_of_screen.dart';
import 'package:doctor/bottomNavigation.dart';
import 'package:doctor/main.dart';
import 'package:doctor/homeContainers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:double_back_to_close/double_back_to_close.dart';


class DoctorsAvailable extends StatefulWidget {
  const DoctorsAvailable({Key? key}) : super(key: key);

  @override
  State<DoctorsAvailable> createState() => _DoctorsAvailableState();
}

class _DoctorsAvailableState extends State<DoctorsAvailable> {
  int indexed=0;
  bool search=false;
  bool searching=true;
  double searchWidth=150;
  bool onlineCheck=true;
  bool followingCheck=false;
  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DoubleBack(

        message: 'Tap again to exit app',

    child:Scaffold(
      // appBar: AppBar(
      //   leading: ,
      //   title: ,
      //   centerTitle: true,
      //   actions: [
      //
      //   ],
      // ),
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color.fromRGBO(210, 230, 250, 0.2),
                Color.fromRGBO(210, 230, 250, 0.2)],
                begin: Alignment.topLeft,end:Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.all(10),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                SizedBox(height:30),
                Container(alignment:Alignment.center,height:50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(child:Text("Patients", style: TextStyle(fontSize: 18,
                          fontWeight: FontWeight.bold, color:onlineCheck?Colors.pink: Colors.black)),
                        onPressed: () {
                          setState(() {
                            onlineCheck=true;
                            followingCheck=false;
                          });
                        },),
                      VerticalDivider(color:Colors.black,width: 1,indent: 15,endIndent: 12,thickness: 2,),
                      TextButton(child:Text("Recommended", style: TextStyle(fontSize: 18,
                          fontWeight: FontWeight.bold, color: followingCheck?Colors.pink :Colors.black)),
                        onPressed: () {
                          setState(() {
                            onlineCheck=false;
                            followingCheck=true;
                          });
                        },),
                    ],
                  ),
                ),

                SizedBox(height:20),
                Flexible(
                  child: ListView.builder(
                    itemCount: 20,
                    itemBuilder:(context,index){
                      return  PatientsAvailableOnline(Name: "Stephen Amoak",
                        Number: "0244444444", picture: "doctor_1.jpg",
                        Experience: "6 Years", Patients: "890",
                        location: 'Korle Bu',);
                  }

                  ),


    //                 children: [
    //                 DoctorsAvailableOnline(Name: "Esther \nObuobi", Speciality: "Cardiologist", picture: "doctor_1.jpg",
    //  Experience: "6 Years", Patients: "890",  location: 'Korle Bu',),
    //                 DoctorsAvailableOnline(Name: "Daniel \nAmissah", Speciality: "Psychiatric \nDoctor", picture: "doctor_2.jpg",
    // Experience: "6 Years", Patients: "1.21K", location: 'KATH',),
    //               DoctorsAvailableOnline(Name: "Freda Otu", Speciality: "Cardiologist", picture: "doctor_1.jpg",
    // Experience: "2 Years", Patients: "3.21K", location: 'UCC Hospital', ),
    //                   DoctorsAvailableOnline(Name: "Peter \nAtsu", Speciality: "Medicine \nSpecialist", picture: "doctor_2.jpg",
    // Experience: "12 Years", Patients: "1.92K", location: 'KATH', ),
    //                   DoctorsAvailableOnline(Name: "Priscilla \nSegbefia", Speciality: "Nuerologist", picture: "doctor_1.jpg",
    // Experience: "9 Years", Patients: "3.91K", location: 'St. Helena Clinic', ),
    //                   DoctorsAvailableOnline(Name: "Isaac \nAbanga", Speciality: "Pediatrician", picture: "doctor_2.jpg",
    // Experience: "1 Year", Patients: "932", location: 'Ridge Hospital', ),
    //               ],

                  ),




        ])),

        bottomNavigationBar: BottomNavBar()
    ));
  }


  List<Widget> items_2=[
    DoctorPick(Name: "Esther Obuobi", Speciality: "Cardiologist", picture: "doctor_1.jpg",
      Experience: "6 Years", Patients: "890", rating: 4, location: 'Korle Bu',),
    DoctorPick(Name: "Daniel Amissah", Speciality: "Psychiatric Doctor", picture: "doctor_2.jpg",
      Experience: "6 Years", Patients: "1.21K",rating: 3, location: 'KATH',),
    DoctorPick(Name: "Freda Otu", Speciality: "Cardiologist", picture: "doctor_1.jpg",
      Experience: "2 Years", Patients: "3.21K",rating: 5, location: 'UCC Hospital', ),
    DoctorPick(Name: "Peter Atsu", Speciality: "Medicine Specialist", picture: "doctor_2.jpg",
      Experience: "12 Years", Patients: "1.92K",rating:2.8, location: 'KATH', ),
    DoctorPick(Name: "Priscilla Segbefia", Speciality: "Nuerologist", picture: "doctor_1.jpg",
      Experience: "9 Years", Patients: "3.91K",rating: 4.5, location: 'St. Helena Clinic', ),
    DoctorPick(Name: "Isaac Abanga", Speciality: "Pediatrician", picture: "doctor_2.jpg",
      Experience: "1 Year", Patients: "932",rating: 3.7, location: 'Ridge Hospital', ),

  ];
}