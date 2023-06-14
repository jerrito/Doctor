import 'package:doctor/widgets/MainButton.dart';
import 'package:doctor/constants/Size_of_screen.dart';
import 'package:doctor/widgets/bottomNavigation.dart';
import 'package:doctor/main.dart';
import 'package:doctor/databases/mongo.dart';
import 'package:doctor/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:double_back_to_close/double_back_to_close.dart';

class Appointments extends StatefulWidget {
  final DateTime date;
  final String time;
  final String doctorName;
  final String speciality;
  final String location;
  const Appointments({
    Key? key,
    required this.date,
    required this.time,
    required this.doctorName,
    required this.speciality,
    required this.location,
  }) : super(key: key);

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  GlobalKey<FormState> dropdownKey = GlobalKey<FormState>();

  @override
  void initState() {}
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

    child:SafeArea(
      child: Scaffold(
          body: Container(
            padding: EdgeInsets.all(10),
            color: Color.fromRGBO(210, 230, 250, 0.2),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              const Center(
                  child: Text("Appointments",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20))),
              // Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children:[
              //       // IconButton(icon:Icon(Icons.arrow_back_ios_new_outlined),
              //       //     onPressed:(){
              //       //       Navigator.pop(context);
              //       //     }),
              //       Text("My Appointment",style:TextStyle(fontWeight: FontWeight.bold,
              //           fontSize: 18)),
              //       Text("")
              //     ]),
              SizedBox(height: 20),
              FutureBuilder(
                  future: mongo.getAppointment(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      var appointmentList = snapshot.data.length;
                      return Flexible(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return appointListget(
                                Appointment.fromJson(snapshot.data[index]));
                          },
                          itemCount: appointmentList,
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Center(
                            child: SpinKitFadingCube(
                          color: Colors.pink,
                          size: 50.0,
                        )),
                      );
                    } else {
                      return Center(
                        child: SizedBox(
                          width: w_s * 72.22,
                          height: h_s * 20.625,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.wifi_off, color: Colors.pink),
                              SizedBox(height: 10),
                              Text("Network error",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              MainButton(
                                onPressed: () async {
                                  await mongo.con();
                                  // await mongo.getDoctor();
                                  Navigator.restorablePushReplacementNamed(
                                      context, "homepage");
                                },
                                color: Colors.pink,
                                backgroundColor: Colors.pink,
                                child: Text("Refresh"),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }),
              // Flexible(
              //   child: ListView(
              //     children: [
              //       SizedBox(height:20),
              //       AppointmentList(date:widget.date, time: widget.time, doctorName: widget.doctorName,
              //         speciality: widget.speciality,location: widget.location,),
              //       SizedBox(height:20),
              //       AppointmentList(date:widget.date.toUtc(), time: '${widget.time}',location:'${widget.location}' ,
              //         doctorName: widget.doctorName, speciality: '${widget.speciality}',),
              //       SizedBox(height:20),
              //       AppointmentList(date:widget.date, time: '${widget.time}',
              //         doctorName: '${widget.doctorName}', speciality: '${widget.speciality}',location: '${widget.location}',),
              //       SizedBox(height:20),
              //       AppointmentList(date:widget.date, time: '${widget.time}',
              //         doctorName: '${widget.doctorName}', speciality: '${widget.speciality}',location: '${widget.location}',),
              //       SizedBox(height:20),
              //       AppointmentList(date:widget.date, time: '${widget.time}',
              //         doctorName: '${widget.doctorName}', speciality: '${widget.speciality}', location: '${widget.location}',),
              //     ],),
              // )
            ]),
          ),
          bottomNavigationBar: BottomNavBar()),
    ));
  }

  Widget appointListget(Appointment appoint) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
      child: AppointmentList(
          date: "${appoint.date}",
          time: "${appoint.time}",
          doctorName: "${appoint.doctor}",
          speciality: "${appoint.speciality}",
          location: "${appoint.location}"),
    );
  }
}

class AppointmentList extends StatelessWidget {
  final String date;
  final String time;
  final String doctorName;
  final String speciality;
  final String location;
  const AppointmentList(
      {Key? key,
      required this.date,
      required this.time,
      required this.doctorName,
      required this.speciality,
      required this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: h_s * 13.75,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Column(
            children: [
              Text("Date\n$date",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 10),
              // RichText(text: TextSpan(text:"Speciality", children:  <TextSpan>[TextSpan(text: '\n$speciality', style: TextStyle(fontWeight:FontWeight.bold,fontSize:16)),],)),
              Text(
                  speciality.length >= 13
                      ? "Speciality\n${speciality.substring(0, 12)}..."
                      : "Speciality\n$speciality",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          Column(
            children: [
              Text("Time\n$time",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 10),
              Text(
                  location.length >= 15
                      ? "Location\n${location.substring(0, 14)}..."
                      : "Location\n$location",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          Column(
            children: [
              Text(
                  doctorName.length >= 15
                      ? "Doctor\nDr. ${doctorName.substring(0, 14)}..."
                      : "Doctor\nDr. $doctorName",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 10),
              SizedBox(
                height: h_s * 3.75,
                width: w_s * 27.78,
                child: MainButton(
                  child: Text("Cancel"),
                  onPressed: () {},
                  color: Colors.redAccent,
                  backgroundColor: Colors.redAccent,
                ),
              ),
            ],
          )
        ]));
  }
}
