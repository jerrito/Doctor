import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:doctor/constants/Size_of_screen.dart';
import 'package:doctor/widgets/bottomNavigation.dart';
import 'package:doctor/widgets/doctorSearch.dart';
import 'package:doctor/widgets/homeContainers.dart';
import 'package:doctor/main.dart';
import 'package:doctor/databases/mongo.dart';
import 'package:doctor/userProvider.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:firebase_auth/firebase_auth.dart' as use;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  use.FirebaseAuth auth = use.FirebaseAuth.instance;
  UserProvider? userProvider;
  int indexed = 0;
  bool search = false;
  bool searching = true;
  double searchWidth = 150;
  Future<void> internet() async {
    await mongo.con();
    var search = await mongo.doctorCollection.findOne(
      {"number": "${userProvider?.appUser?.number}"},
    );
    search["live"] = 1;
    await mongo.doctorCollection.save(search);
  }

  Future<void> noInternet() async {
    await mongo.con();
    var search = await mongo.doctorCollection.findOne(
      {"number": "${userProvider?.appUser?.number}"},
    );
    search["live"] = 0;
    await mongo.doctorCollection.save(search);
  }

  @override
  void initState() {
    userProvider = context.read<UserProvider>();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile) {
        internet();
      } else if (result == ConnectivityResult.wifi) {
        internet();
      } else if (result == ConnectivityResult.ethernet) {
        internet();
      } else if (result == ConnectivityResult.vpn) {
        internet();
      } else {}

      print(result);
    });
    mongo.con();
    super.initState();
  }

  @override
  dispose() async {
    await noInternet();
    subscription.cancel();
    print("hello");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DoubleBack(
      message: "Tap again to exit app",
      child: Scaffold(
          // appBar: AppBar(
          //     title: Text("Ayaresapa",
          //         style: TextStyle(fontWeight: FontWeight.bold)),
          //     // leading: Image.asset("./assets/images/4.png"),
          //     //centerTitle: true,
          //     actions: [Image.asset("./assets/images/1.png")]),
          body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(210, 230, 250, 0.2),
                    Color.fromRGBO(210, 230, 250, 0.2)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: h_s * 3.75),
                  Text(
                    "Contact other",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Text(
                          "Specialist",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            showSearch(
                                context: context, delegate: DoctorSearching());
                          }),
                    ],
                  ),
                  SizedBox(height: 20),
                  CarouselSlider(
                      items: items,
                      options: CarouselOptions(
                        height: h_s * 20.625,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 5),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.3,
                      )),
                  SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("Categories"), Icon(Icons.arrow_back)]),
                  SizedBox(height: 10),
                  Flexible(
                    child: ListView(
                      reverse: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DoctorCategories(
                                  icon: Icons.medication_liquid,
                                  role: "Neurologist"),
                              DoctorCategories(
                                  icon: Icons.medication_liquid,
                                  role: "Dentist"),
                              DoctorCategories(
                                  icon: Icons.medication_liquid,
                                  role: "Obstetrician"),
                              DoctorCategories(
                                  icon: Icons.medication_liquid,
                                  role: "Gynecologist"),
                              DoctorCategories(
                                  icon: Icons.medication_liquid,
                                  role: "Radiologist"),
                              DoctorCategories(
                                  icon: Icons.medication_liquid,
                                  role: "Anesthesiologist"),
                              DoctorCategories(
                                  icon: Icons.medication_liquid,
                                  role: "Internist"),
                              DoctorCategories(
                                  icon: Icons.medication_liquid,
                                  role: "Dermatologist"),
                              DoctorCategories(
                                  icon: Icons.medical_information_rounded,
                                  role: "Pediatrician"),
                              DoctorCategories(
                                  icon: Icons.medication_liquid,
                                  role: "E.R doctor"),
                              DoctorCategories(
                                  icon: Icons.medication, role: "Psychiatrist"),
                              DoctorCategories(
                                  icon: Icons.medication,
                                  role: "Ophthalmologist"),
                            ]),
                      ],
                    ),
                  ),
                  Text("Available Doctors"),
                  SizedBox(height: 10),
                  CarouselSlider(
                      items: items_2,
                      options: CarouselOptions(
                        height: h_s * 23.125,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 5),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.3,
                      )),
                ],
              )),
          bottomNavigationBar: BottomNavBar()),
    );
  }

  List<Widget> items = [
    DoctorInfo(
      Name: "Stephen Atta",
      Speciality: "Orthopedic",
      location: "Korle Bu",
      picture: "d5.png",
      Experience: '2.7 Years',
      Patients: '4.63K',
    ),
    DoctorInfo(
        Name: "Jerry Boateng",
        Speciality: "Pediatrician",
        location: "UCC Hospital",
        picture: "d6.png",
        Experience: '4.3 Years',
        Patients: '954K'),
    DoctorInfo(
        Name: "John Ametepe",
        Speciality: "Nuerologist",
        location: "KATH",
        picture: "d14.png",
        Experience: '3.5 Years',
        Patients: '795'),
    DoctorInfo(
        Name: "Mannasseh Tsikata",
        Speciality: "Cardiologist",
        location: "UCC Hospital",
        picture: "doctor_1.jpg",
        Experience: '4 Years',
        Patients: '1.31K'),
    DoctorInfo(
        Name: "Dora Aidoo",
        Speciality: "Psychiatric doctor",
        location: "Ridge Hospital",
        picture: "d5.png",
        Experience: '2 Years',
        Patients: '3.21K'),
  ];
  List<Widget> items_2 = [
    DoctorPick(
      Name: "Esther Obuobi",
      Speciality: "Cardiologist",
      picture: "d14.png",
      Experience: "6 Years",
      Patients: "890",
      rating: 4,
      location: 'Korle Bu',
    ),
    DoctorPick(
      Name: "Daniel Amissah",
      Speciality: "Psychiatric Doctor",
      picture: "d6.png",
      Experience: "6 Years",
      Patients: "1.21K",
      rating: 3,
      location: 'KATH',
    ),
    DoctorPick(
      Name: "Freda Otu",
      Speciality: "Cardiologist",
      picture: "doctor_1.jpg",
      Experience: "2 Years",
      Patients: "3.21K",
      rating: 5,
      location: 'UCC Hospital',
    ),
    DoctorPick(
      Name: "Peter Atsu",
      Speciality: "Medicine Specialist",
      picture: "d14.png",
      Experience: "12 Years",
      Patients: "1.92K",
      rating: 2.8,
      location: 'KATH',
    ),
    DoctorPick(
      Name: "Priscilla Segbefia",
      Speciality: "Nuerologist",
      picture: "doctor_1.jpg",
      Experience: "9 Years",
      Patients: "3.91K",
      rating: 4.5,
      location: 'St. Helena Clinic',
    ),
    DoctorPick(
      Name: "Isaac Abanga",
      Speciality: "Pediatrician",
      picture: "d5.png",
      Experience: "1 Year",
      Patients: "932",
      rating: 3.7,
      location: 'Ridge Hospital',
    ),
  ];
}

class DoctorSearching extends SearchDelegate<DoctorSearch> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
    throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(
              context,
              DoctorSearch(
                cardvalue: '',
              ));
        });
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text(query);
    throw UnimplementedError();
  }
}
