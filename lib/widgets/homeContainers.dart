import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:doctor/widgets/doctorOptions.dart';
import 'package:doctor/widgets/doctorSearch.dart';
import 'package:doctor/main.dart';

class DoctorInfo extends StatelessWidget {
  final String Name;
  final String Speciality;
  final String location;
  final String picture;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;
  final String Experience;
  final String Patients;

  const DoctorInfo({Key? key, required this.Name,required this.Speciality,
    required this.location, required this.picture, this.onTap, this.onDoubleTap,
    this.onLongPress, required this.Experience, required this.Patients}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:(){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
            DoctorOptions(name: Name, speciality: Speciality, pic: picture,
                patients: Patients, experience: Experience, follow: '1.53K',location:location

            )
        ));
      } ,
      onDoubleTap:onDoubleTap ,
      onLongPress:onLongPress ,
      child: Container(
          width: w_s*72.22,height: h_s*20.625,
          decoration: BoxDecoration(
              color: Colors.pink,
              borderRadius:BorderRadius.circular(10)
          ),
          child:Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              VerticalDivider(width: 1,indent: 80,endIndent:30,thickness: 2,color: Colors.white,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  Text("Have interraction with other\nSpecialist Doctor?",style:TextStyle(fontSize:14,fontWeight:FontWeight.bold,color:Colors.white)),
                //  Text("Specialist Doctor?",style:TextStyle(fontSize:14,fontWeight:FontWeight.bold,color:Colors.white)),
                  SizedBox(height:40),
                  // VerticalDivider(width: 1,indent: 80,endIndent:20,thickness: 2,color: Colors.white,),
                  Text("Dr. $Name",style:TextStyle(fontSize:14,fontWeight:FontWeight.bold,color:Colors.white,)),
                  Text("$Speciality",style:TextStyle(fontSize:14,color:Colors.white)),
                  Text("$location",style:TextStyle(fontSize:14,color:Colors.white))




                ],
              ),
              SizedBox(width: w_s*13.89,height:h_s*13.75,
                  child: Image.asset("./assets/images/$picture",fit: BoxFit.fill,width: 50,height:110))
            ],
          )
      ),
    );
  }
}


class DoctorCategories extends StatelessWidget {
  final IconData icon;
  final String role;
  final void Function()? onTap;
  const DoctorCategories({Key? key, required this.icon, required this.role, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:(){
      Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {return   DoctorSearch(cardvalue: "$role",);}
      ));} ,
      child: Container(
        margin: EdgeInsets.only(left: 10,right: 10),
          width:w_s*27.78,height:h_s*12.5,
          decoration:BoxDecoration(color:Colors.white, borderRadius:BorderRadius.circular(10)),
          child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Icon(icon,color:Colors.pink),
                SizedBox(height:10),
                Text("$role",style:TextStyle(fontWeight:FontWeight.bold,fontSize:12))

              ]
          )
      ),
    );
  }
}


class DoctorPick extends StatelessWidget {
  final String Name;
  final String Speciality;
final void Function()? onTap;
final void Function()? onDoubleTap;
final void Function()? onLongPress;
  final String Experience;
  final String Patients;
  final double rating;
  final String picture;
  final String location;
  const DoctorPick({Key? key, required this.Name,required this.Speciality,
    required this.picture, required this.Experience, required this.Patients,
    required this.rating, this.onTap, this.onDoubleTap, this.onLongPress, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:(){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
        DoctorOptions(name: Name, speciality: Speciality, pic: picture,
          patients: Patients, experience: Experience, follow: '1.53K',location:location

        )
        ));
      } ,
      onDoubleTap:onDoubleTap ,
      onLongPress:onLongPress ,
      child: Container(
          width: 260,height: h_s*23.15,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:BorderRadius.circular(10)
          ),
          child:Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //VerticalDivider(width: 1,indent: 80,endIndent:30,thickness: 2,color: Colors.white,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                 // Text("Looking For Your Desire\nSpecialist Doctor?",style:TextStyle(fontSize:14,fontWeight:FontWeight.bold,color:Colors.white)),
                  //  Text("Specialist Doctor?",style:TextStyle(fontSize:14,fontWeight:FontWeight.bold,color:Colors.white)),
                  // VerticalDivider(width: 1,indent: 80,endIndent:20,thickness: 2,color: Colors.white,),
                  Text("Dr. $Name",style:TextStyle(fontSize:14,fontWeight:FontWeight.bold,color:Colors.black,)),
                  Text("$Speciality",style:TextStyle(fontSize:14,color:Colors.black)),
               RatingBar.builder(
                 initialRating: rating,
                  minRating: 1,
               direction: Axis.horizontal,
                   allowHalfRating: true,
                itemCount: 5,
                itemSize: 15,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                 itemBuilder: (context, _) => Icon(
                   Icons.star,
               color: Colors.amber,
                  ),
                onRatingUpdate: (rating) {
                   print(rating);},),
                  SizedBox(height:15),
                  Text("Experience\n$Experience",style:TextStyle(fontSize:14,color:Colors.black)),
                  SizedBox(height:10),
                  Text("Patients\n$Patients",style:TextStyle(fontSize:14,color:Colors.black))

                ],
              ),
              SizedBox(width: 50,height:140,
                  child: Image.asset("./assets/images/$picture",fit: BoxFit.fill,width: 50,height:140))
            ],
          )
      ),
    );
  }
}

class PatientsAvailableOnline extends StatelessWidget {
  final String Name;
  final String Number;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;
  final String Experience;
  final String Patients;

  final String picture;
  final String location;
  const PatientsAvailableOnline({Key? key, required this.Name,required this.Number,
    required this.picture, required this.Experience, required this.Patients,
     this.onTap, this.onDoubleTap, this.onLongPress, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:(){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
            DoctorOptions(name: Name, speciality: Number, pic: picture,
                patients: Patients, experience: Experience, follow: '1.53K',location:location

            )
        ));
      } ,
      onDoubleTap:onDoubleTap ,
      onLongPress:onLongPress ,
      child: Container(
          width: double.infinity,//height: 100,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:BorderRadius.circular(10)
          ),
          child:ListTile(
            minLeadingWidth: 10.0,
            minVerticalPadding: 5.0,
            horizontalTitleGap: 40,
            leading:SizedBox(width: 60,height: 60,
              child: CircleAvatar(
                backgroundImage:Image.asset("./assets/images/$picture",fit: BoxFit.cover).image ,
              ),
            ) ,
            title: Text("$Name",style:TextStyle(fontSize:16,fontWeight:FontWeight.bold,color:Colors.black,)),
            subtitle: Text("\n$Number",style:TextStyle(fontSize:16,color:Colors.black)),
            //Text("$location",style:TextStyle(fontSize:12,color:Colors.black)),


          )
      ),

    );
  }
}

class DoctorArea extends StatelessWidget {
  final String Name;
  final String Speciality;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;
  final String picture;
  final String location;
  const DoctorArea({Key? key, required this.Name,required this.Speciality,
    required this.picture, this.onTap, this.onDoubleTap, this.onLongPress,
    required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:(){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
            DoctorOptions(name: Name, speciality: Speciality, pic: picture,
                patients: "755", experience: "3 Years", follow: '1.53K',location:location
            )
        ));
      } ,
      onDoubleTap:onDoubleTap ,
      onLongPress:onLongPress ,
      child: Container(
          width: double.infinity,//height: 100,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:BorderRadius.circular(10)
          ),
          child:ListTile(
            minLeadingWidth: 10.0,
            minVerticalPadding: 5.0,
           horizontalTitleGap: 40,
           leading:SizedBox(width: 60,height: 60,
             child: CircleAvatar(
               backgroundImage:Image.asset("./assets/images/$picture",fit: BoxFit.cover).image ,
             ),
           ) ,
            title: Text("Dr. $Name",style:TextStyle(fontSize:16,fontWeight:FontWeight.bold,color:Colors.black,)),
            subtitle: Text("$Speciality\n\n$location",style:TextStyle(fontSize:16,color:Colors.black)),
              //Text("$location",style:TextStyle(fontSize:12,color:Colors.black)),


          )
      ),
    );
  }
}
