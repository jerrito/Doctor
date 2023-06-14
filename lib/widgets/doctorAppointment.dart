import 'package:doctor/constants/Size_of_screen.dart';
import 'package:doctor/appointments.dart';
import 'package:doctor/main.dart';
import 'package:doctor/widgets/MainButton.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:time_slot/controller/day_part_controller.dart';
import 'package:time_slot/model/time_slot_Interval.dart';
import 'package:time_slot/time_slot_from_interval.dart';

class DoctorAppointment extends StatefulWidget {
  final String name;
  final String speciality;
  final String patients;
  final String location;
  const DoctorAppointment({
    Key? key,
    required this.name,
    required this.speciality,
    required this.patients,
    required this.location,
  }) : super(key: key);

  @override
  State<DoctorAppointment> createState() => _DoctorAppointmentState();
}

class _DoctorAppointmentState extends State<DoctorAppointment> {
  GlobalKey<FormState> dropdownKey = GlobalKey<FormState>();
  DayPartController dayPartController = DayPartController();
  DateTime date = DateTime.now().add(const Duration(hours: 24));
  late var formattedDate;
  String dateget = "";
  bool dateConfirm = false;
  bool timeSlot = false;
  var selectTime = DateTime.now();
  @override
  void initState() {
    formattedDate = DateFormat('d-MMM-yy').format(date);
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_outlined),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              Text("Appointment",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text("")
            ]),
            SizedBox(height: h_s * 6.25),
            Expanded(
              child: ListView(
                children: [
                  SecondaryButton(
                      child: Text("Select Date",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      onPressed: () async {
                        await showDatePicker(
                          context: context,
                          // selectableDayPredicate:
                          // (DateTime weekdays)=>
                          //   (weekdays.weekday==6 || weekdays.weekday==7)?false:true,
                          helpText: "SELECT DATE FOR APPOINTMENT",
                          confirmText: "CONFIRM",
                          initialDate: date,
                          firstDate: date,
                          lastDate:
                              DateTime.utc(DateTime.now().year + 1, 12, 31),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            setState(() {
                              date = selectedDate;
                              formattedDate =
                                  DateFormat('d-MMM-yy').format(selectedDate);
                              timeSlot = true;
                              dateget =
                                  DateFormat('d-MMM-yy').format(selectedDate);
                            });
                          }
                        });
                      },
                      color: Colors.pink,
                      backgroundColor: Colors.pink),
                  SizedBox(height: h_s * 6.25),
                  Text("$dateget"),
                  SizedBox(height: 20),
                  Text("Slots"),
                  Visibility(
                    visible: timeSlot,
                    child: TimesSlotGridViewFromInterval(
                      locale: "en",
                      initTime: selectTime,
                      crossAxisCount: 4,
                      timeSlotInterval: const TimeSlotInterval(
                        start: TimeOfDay(hour: 8, minute: 00),
                        end: TimeOfDay(hour: 16, minute: 0),
                        interval: Duration(hours: 1, minutes: 0),
                      ),
                      onChange: (value) {
                        setState(() {
                          selectTime = value;
                          dateConfirm = true;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SecondaryButton(
              onPressed: !dateConfirm
                  ? null
                  : () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Appointments(
                                    date: date,
                                    time: "${selectTime.hour.toString()}" +
                                        ":${selectTime.minute.toString()}0",
                                    doctorName: '${widget.name}',
                                    speciality: '${widget.speciality}',
                                    location: "${widget.location}",
                                  )));
                    },
              color: Colors.amberAccent,
              backgroundColor: Colors.amberAccent,
              child: Text("Confirm Appointment"),
            ),
            SizedBox(height: 10)
          ]),
        ),
      ),
    );
  }
}
