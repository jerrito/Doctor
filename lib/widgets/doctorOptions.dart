import 'package:flutter/material.dart';
import 'package:doctor/widgets/MainButton.dart';
import 'package:doctor/main.dart';
import 'package:doctor/widgets/doctorAppointment.dart';

class DoctorOptions extends StatefulWidget {
  final String name;final String speciality;final String pic;
  final String patients;final String experience;final String follow;final String location;
  const DoctorOptions({Key? key, required this.name, required this.speciality,
    required this.pic, required this.patients, required this.experience,
    required this.follow, required this.location}) : super(key: key);

  @override
  State<DoctorOptions> createState() => _DoctorOptionsState();
}

class _DoctorOptionsState extends State<DoctorOptions> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(10),
          child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        IconButton(icon:Icon(Icons.arrow_back_ios_new_outlined),
                        onPressed:(){
                          Navigator.pop(context);
                        }),
                        Text("Dr. ${widget.name}",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                        Text("")
                      ]),
             Flexible(
            child: ListView(
                children: [  Container(width: double.infinity,height:h_s*37.5,
                      color: Color.fromRGBO(210, 230, 250, 0.2),
                      child: Center(
                        child:Image.asset("./assets/images/${widget.pic}",
                            width: double.infinity,height:h_s*37.5)
                      ),
                    ),
                    SizedBox(height:20),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      SizedBox(width: w_s*30.56,height:h_s*6.25, child:
                      IconLabelButton(label: "Voice call",icon:Icon(Icons.phone,color:Colors.white) ,
                          onPressed: (){},backgroundColor: Colors.lightGreen ,color: Colors.lightGreen)),
                      SizedBox(width:w_s*30.56,height:h_s*6.25, child: IconLabelButton(label: "Video call",
                          icon:Icon(Icons.video_call_outlined,color:Colors.white),
                          onPressed: (){},backgroundColor:Colors.purple, color: Colors.purple)),
                      SizedBox(width:w_s*30.56,height:h_s*6.25, child: IconLabelButton(label: "Message",
                          icon:Icon(Icons.message,color:Colors.white),
                          onPressed: (){},backgroundColor:Colors.orange, color: Colors.orange)),
                     // SizedBox(width: 100, child: MainButton(child: TextButton.icon(onPressed: (){}, icon: Icon(Icons.video_call_outlined), label: Text("Video Call")), onPressed: (){}, color: Colors.blue)),
                      //SizedBox(width: 100, child: MainButton(child: TextButton.icon(onPressed: (){}, icon: Icon(Icons.phone), label: Text("")), onPressed: (){}, color: Colors.orange)),
                    ],),
                    SizedBox(height:20),
                    Align(alignment: Alignment.centerLeft,
                        child: Text("${widget.speciality}",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16))),
                    Align(alignment: Alignment.centerLeft,
                        child: Text("${widget.location}",style:TextStyle(fontSize: 16))),
                    SizedBox(height:10),
                    Align(alignment: Alignment.centerLeft,child: Text("About ${widget.name}",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16))),
                    Align(alignment: Alignment.centerLeft,child: Text("Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, "
                    )),
                    SizedBox(height:10),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:[
                        Column(children:[Text("Patients"),Text("${widget.patients}",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16))]),
                        Column(children:[Text("Experience"),Text("${widget.experience}",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16))]),
                        Column(children:[Text("Reviews"),Text("2.54K",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16))])
                      ]
                    ),
                    SizedBox(height:h_s*2.5),
                    SecondaryButton(child: Text("Book an Appointment"), onPressed: (){
                      Navigator.push(context,  MaterialPageRoute(builder: (context)=>
                          DoctorAppointment(name: '${widget.name}', speciality: '${widget.speciality}',
                            patients: '${widget.patients}', location: '${widget.location}',)
                      ));
                    }, color: Colors.pink, backgroundColor:Colors.pink,foregroundColor:Colors.white,)
                ],),
             ),

         ] ),


        ),
      ),
    );
  }
}
