import 'dart:io';
import 'dart:ui' as ui;

import 'package:doctor/MainButton.dart';
import 'package:doctor/MainInput.dart';
import 'package:doctor/ProfileContainers.dart';
import 'package:doctor/bottomNavigation.dart';
import 'package:doctor/displayPicScreen.dart';
import 'package:doctor/firebase_services.dart';
import 'package:doctor/main.dart';
import 'package:doctor/mongo.dart';
import 'package:doctor/user.dart';
import 'package:doctor/userProvider.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:firebase_auth/firebase_auth.dart' as use;
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileUpdate {
  final String imagePath;
  String? check;

  ProfileUpdate({required this.imagePath, this.check});
}

class Profile extends StatefulWidget {
  ProfileUpdate profileUpdate;
  //List<CameraDescription> cameras=[];
  Profile({super.key, required this.profileUpdate});
  // const Profile({Key? key,}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  use.FirebaseAuth auth = use.FirebaseAuth.instance;
  GlobalKey<FormState> nameKey = GlobalKey();
  GlobalKey<FormState> emailKey = GlobalKey();
  GlobalKey<FormState> numberKey = GlobalKey();
  GlobalKey<FormState> locationKey = GlobalKey();
  GlobalKey<FormState> pinKey = GlobalKey();
  GlobalKey<FormState> dropdownKey = GlobalKey<FormState>();
  ui.Image? image;

  bool cardSelection = true;
  String? cardvalue = "Family physician";
  var doctorTypes = [
    "Obstetrician",
    "Gynecologist",
    "Neurologist",
    "Radiologist",
    "Dentist",
    "Anesthesiologist",
    "Family physician",
    "Emergency physician",
    "Psychiatrist",
    "Internist",
    "Pediatrician",
    "Dermatologist",
    "Ophthalmologist",
    "E.R doctor"
  ];
  File? _image;
  TextEditingController name = TextEditingController();
  final email = TextEditingController();
  final number = TextEditingController();
  final location = TextEditingController();
  final pinOld = TextEditingController();
  final pinNew = TextEditingController();
  final pinConfirm = TextEditingController();

  bool obscure = true;
  int index = 0;
  bool obscure1 = true;
  int index1 = 0;
  bool obscure2 = true;
  int index2 = 0;
  UserProvider? userProvider;
  bool saveLoading = false;

  void changeProfilePic({required User? user}) async {
    String? img = user?.image;
    if (widget.profileUpdate.check == "see") {
    } else if (widget.profileUpdate.check == "update") {
      img = widget.profileUpdate.imagePath;
      user?.image = img;

      await updateUser(user: user!);
      await RealtimeDatabase.update(userId: auth.currentUser!.uid, user: user);
      await idMongo(user: userProvider?.appUser);
      await nav();
    }
  }

  Future<void> idMongo({required User? user}) async {
    String? img = user?.image;
    userProvider = context.read<UserProvider>();
    var search = await mongo.doctorCollection.findOne(
      {"number": "${userProvider?.appUser?.number}"},
    );
    img = widget.profileUpdate.imagePath;
    // await  mongo.update("email", "${userProvider?.appUser?.email}",
    //     "number" ,"+233${number?.substring(1)}");
    search["image"] = img;
    search["id"] = userProvider?.appUser?.id;
    // await RealtimeDatabase.update(
    //     userId: auth.currentUser!.uid, user: user);
    await mongo.doctorCollection.save(search);
  }

  Future<void> nav() async {
    await Navigator.pushReplacementNamed(context, "profile");
  }

  @override
  void initState() {
    userProvider = context.read<UserProvider>();
    changeProfilePic(user: userProvider!.appUser);
    setState(() {
      cardvalue = userProvider?.appUser?.speciality;
    });
    print(userProvider?.appUser?.speciality);
    print(userProvider?.appUser?.fullname);
    super.initState();
  }
  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }
// Be sure to cancel subscription after you are done

  // Future<bool> popNot() async {
  //   return false;
  // }

  @override
  Widget build(BuildContext context) {
    return DoubleBack(

        message:'Tap again to exit app',

      child:SafeArea(
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.pink,
              leading: Container(),
              centerTitle: true,
              title: Text("Profile",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              actions: [Image.asset("./assets/images/1.png")]),
          body:  Container(
                padding: EdgeInsets.all(10),
                color: Color.fromRGBO(210, 230, 250, 0.2),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children:[
                      // IconButton(icon:Icon(Icons.arrow_back_ios_new_outlined),
                      //     onPressed:(){
                      //       Navigator.pop(context);
                      //     }),
                      // Center(child: Text("Profile", style: TextStyle(
                      //     fontWeight: FontWeight.bold, fontSize: 18))),
                      // IconButton(icon:Icon(Icons.settings,color:Colors.pink),
                      // onPressed:(){
                      //
                      // })
                      // ])

                      Flexible(
                        child: ListView(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: double.infinity, height: h_s * 22.5,
                                  color: Color.fromRGBO(210, 230, 250, 0.2),
                                  // decoration: ,
                                  child: Visibility(
                                    visible: userProvider
                                            ?.appUser?.image?.isNotEmpty ==
                                        true,
                                    replacement: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      //backgroundImage:SvgPicture.asset("./assets/svgs/user.svg").image,
                                      //radius:50,
                                      child: SvgPicture.asset(
                                          "./assets/svgs/user.svg",
                                          width: w_s * 22.22,
                                          height: h_s * 10),
                                    ),
                                    child: CircleAvatar(
                                        radius: h_s * 11.25,
                                        backgroundColor: Colors.pink,
                                        child: ProfilePicture(
                                          //key:profile,
                                          radius: h_s * 11,
                                          //child: Text('${userProvider?.appUser?.firstName![0]}'),
                                          name:
                                              '${userProvider?.appUser?.fullname![0]}',

                                          img:
                                              '${userProvider?.appUser?.image}',
                                          //img:'https://firebasestorage.googleapis.com/v0/b/wasime.appspot.com/o/data%2Fuser%2F0%2Fcom.example.mobile_money_project%2Fcache%2F14ae4d1e-b1b5-424d-98e0-07f05cd319602261144635358132582.jpg?alt=media&token=b2c3cdfb-941b-48fe-8d5f-ea00532d0a15',
                                          fontsize: 20,
                                        )),
                                  ),
                                ),
                                Positioned(
                                  right: h_s * 10.875,
                                  bottom: h_s * 2.5,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.pink,
                                    child: IconButton(
                                        icon: Icon(Icons.camera_alt,
                                            color: Colors.white),
                                        onPressed: () async {
                                          await changeProfile(
                                              user: userProvider?.appUser);
                                        }),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            ContainerProfileInfo(
                              title: 'Dr. ${userProvider?.appUser?.fullname}',
                              onPressed: () async {
                                await showName(user: userProvider?.appUser);
                              },
                            ),
                            SizedBox(height: 20),
                            ContainerProfileInfo(
                              title: '${userProvider?.appUser?.email}',
                              onPressed: () {
                                showEmail(user: userProvider?.appUser);
                              },
                            ),
                            SizedBox(height: 20),
                            ContainerProfileInfo(
                              title: '${userProvider?.appUser?.number}',
                              onPressed: () {
                                showNumber(user: userProvider?.appUser);
                              },
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: h_s * 8.125,
                              width: w - 20,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                // border: Border.all(color:Colors.black,width:1,
                                //     style:BorderStyle.solid)
                              ),
                              child: DropdownButton(
                                  value: cardvalue,
                                  key: dropdownKey,
                                  dropdownColor: Colors.white,
                                  style: TextStyle(color: Colors.white),
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.black,
                                  ),
                                  items: doctorTypes.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      onTap: () {
                                        // cardvalue = value!;
                                        // idType=cardvalue;
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          // SizedBox(width: SizeConfig.blockSizeHorizontal*5.56,),
                                          Text(items,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            width: (w - 20) - 168,
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (newValue) async {
                                    setState(() {
                                      cardvalue = newValue!;
                                      //i=20;
                                    });
                                    await speciality(
                                        user: userProvider?.appUser);
                                  }),
                            ),
                            SizedBox(height: 20),
                            ContainerProfileInfo(
                              title: 'Short bio',
                              onPressed: () {
                                showshortBio(user: userProvider?.appUser);
                              },
                            ),
                            SizedBox(height: 20),
                            ContainerProfileInfo(
                              title: 'Change Pin',
                              onPressed: () {
                                pinEdit(user: userProvider?.appUser);
                              },
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(10),
                              height: h_s * 8.75,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Rating",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    RatingBar.builder(
                                      initialRating:
                                          userProvider!.appUser!.ratings!,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 15,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                  ]),
                            ),
                            SizedBox(height: 20),
                            ContainerProfileInfo(
                              title: userProvider?.appUser?.location == ""
                                  ? "Hospital Name"
                                  : "${userProvider?.appUser?.location}",
                              onPressed: () async {
                                await showLocation(user: userProvider?.appUser);
                              },
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(10),
                              height: h_s * 8.75,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Experience",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    Text(
                                        userProvider?.appUser?.experience ==
                                                null
                                            ? ""
                                            : "${userProvider?.appUser?.experience} year(s)",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    IconButton(
                                        icon: Icon(Icons.edit,
                                            color: Colors.pink),
                                        onPressed: () {
                                          showExperience(
                                              user: userProvider?.appUser);
                                        })
                                  ]),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(10),
                              height: h_s * 8.75,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Patients",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    Text("${userProvider?.appUser?.patients}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                  ]),
                            ),
                            SizedBox(height: 20),
                            ContainerProfileInfo(
                              title: 'Logout',
                              onPressed: () {
                                showExitPopup();
                              },
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
              bottomNavigationBar: BottomNavBar())),
    );
  }

  Future<void> updateDocInfo({required User user}) async {
    print(userProvider?.appUser?.number);
    var search = await mongo.doctorCollection.findOne(
      {"number": "${userProvider?.appUser?.number}"},
    );
    search["id"] = userProvider?.appUser?.id;
    search["image"] = userProvider?.appUser?.image;
    print(search["id"]);
    print(userProvider?.appUser?.id);
    // search["fullname"]=user.fullname;
    // search[["password"].toString()]=user.password;
    // search["image"]=user.image;
    // search["email"]=user.email;
    var update = await mongo.doctorCollection.save(search);
    return update;
  }

  updateUser({required User user}) async {
    var result = await userProvider?.updateUser(user: user);
    print("num ${userProvider?.appUser?.number}");
    print("id ${userProvider?.appUser?.id}");
    if (result?.status == QueryStatus.Successful) {
      //var  id=User(id:userProvider?.appUser?.id);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        content: Text("Profile updated successfully",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(20, 100, 150, 1),
      ));

      return;
    }
    if (result?.status == QueryStatus.Failed) {
      setState(() {
        saveLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        content:
            Text("Error saving details", style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(20, 100, 150, 1),
      ));
    }
  }

  Future<void> speciality({required User? user}) async {
    String? speciality = user?.speciality;
    var search = await mongo.doctorCollection.findOne(
      {"number": "${userProvider?.appUser?.number}"},
    );
    search["speciality"] = cardvalue;
    user?.speciality = cardvalue;
    await updateUser(user: user!);
    await RealtimeDatabase.update(userId: auth.currentUser!.uid, user: user);
    var saveSpeciality = await mongo.doctorCollection.save(search);
    return saveSpeciality;
  }

  Future<void> showName({required User? user}) async {
    var search = await mongo.doctorCollection.findOne(
      {"number": "${userProvider?.appUser?.number}"},
    );
    String? fullname = user?.fullname;
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return saveLoading
                ? DialogLoading()
                : DialogProfile(
                    profileType: "name",
                    keys: nameKey,
                    validator: FullNameValidator,
                    onChanged: (value) {
                      fullname = value;
                    },
                    initialValue: '${userProvider?.appUser?.fullname}',
                    onPressed: saveLoading
                        ? null
                        : () async {
                            if (nameKey.currentState?.validate() == true) {
                              setState(() {
                                saveLoading = true;
                              });

                              user?.fullname = fullname;
                              search["fullname"] = fullname;
                              await mongo.doctorCollection.save(search);
                              await RealtimeDatabase.update(
                                  userId: auth.currentUser!.uid, user: user!);
                              //await  updateDocInfo(user: user!);
                              await updateUser(user: user);
                              setState(() {
                                saveLoading = false;
                                Navigator.pushReplacementNamed(
                                    context, "profile");
                              });
                            }
                          },
                  );
          });
        });
  }

  Future<void> showshortBio({required User? user}) async {
    var search = await mongo.doctorCollection.findOne(
      {"number": "${userProvider?.appUser?.number}"},
    );
    String? shortBio = user?.shortBio;
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return saveLoading
                ? const DialogLoading()
                : DialogProfile(
                    profileType: "shortBio",
                    keys: nameKey,
                    validator: inputValidator,
                    onChanged: (value) {
                      shortBio = value;
                    },
                    initialValue: userProvider?.appUser?.shortBio == ""
                        ? ""
                        : '${userProvider?.appUser?.shortBio}',
                    onPressed: saveLoading
                        ? null
                        : () async {
                            if (nameKey.currentState?.validate() == true) {
                              setState(() {
                                saveLoading = true;
                              });

                              user?.shortBio = shortBio;
                              search["shortBio"] = shortBio;
                              await mongo.doctorCollection.save(search);
                              //await  updateDocInfo(user: user!);
                              await updateUser(user: user!);
                              await RealtimeDatabase.update(
                                  userId: auth.currentUser!.uid, user: user);
                              setState(() {
                                saveLoading = false;
                                Navigator.pushReplacementNamed(
                                    context, "profile");
                              });
                            }
                          },
                  );
          });
        });
  }

  // Future<void> NameEdit({required User? user}) async {
  //   String? fullname = user?.fullname;
  //   showModalBottomSheet<dynamic>(
  //       shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(20), topRight: Radius.circular(20))),
  //       isScrollControlled: true,
  //       context: context,
  //       builder:(BuildContext context) {
  //     return StatefulBuilder(
  //         builder: (context, setState) {
  //           return saveLoading ?
  //           Container(
  //               width: double.infinity,
  //               height: 600,
  //               decoration: const BoxDecoration(
  //                   borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(20),
  //                     topRight: Radius.circular(20),
  //                   )),
  //               child: Center(child: SpinKitFadingCube(
  //                 color: Colors.pink,
  //                 size: 50.0,
  //               ))) :
  //           BottomSheetContainer(
  //               keys: nameKey,
  //               onChanged: (value) {fullname = value;},
  //               initialValue: user?.fullname,
  //               onPressed:saveLoading? null:
  //                   () async {
  //                 setState(() {
  //                   saveLoading = true;
  //                 });
  //                 user?.fullname = fullname;
  //                 await updateUser(user: user!);
  //                 setState(() {
  //                   saveLoading = false;
  //                   Navigator.pushReplacementNamed(context, "profile");
  //                 });
  //               });
  //         }
  //     );
  //   }
  //   );
  // }
  Future<void> showLocation({required User? user}) async {
    print(userProvider?.appUser?.number);
    var search = await mongo.doctorCollection.findOne(
      {"number": "${userProvider?.appUser?.number}"},
    );
    String? location = user?.location;
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return saveLoading
                ? DialogLoading()
                : DialogProfile(
                    profileType: "hospital name",
                    keys: nameKey,
                    //validator: FullNameValidator,
                    onChanged: (value) {
                      location = value;
                    },
                    initialValue: '${userProvider?.appUser?.location}',
                    onPressed: saveLoading
                        ? null
                        : () async {
                            if (nameKey.currentState?.validate() == true) {
                              setState(() {
                                saveLoading = true;
                              });

                              user?.location = location;
                              search["location"] = location;
                              await mongo.doctorCollection.save(search);
                              //await  updateDocInfo(user: user!);
                              await updateUser(user: user!);
                              await RealtimeDatabase.update(
                                  userId: auth.currentUser!.uid, user: user);
                              setState(() {
                                saveLoading = false;
                                Navigator.pushReplacementNamed(
                                    context, "profile");
                              });
                            }
                          },
                  );
          });
        });
  }

  Future<void> showExperience({required User? user}) async {
    var search = await mongo.doctorCollection.findOne(
      {"number": "${userProvider?.appUser?.number}"},
    );
    int? experience = user?.experience;
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return saveLoading
                ? DialogLoading()
                : DialogProfile(
                    profileType: "experience",
                    keyboardType: TextInputType.number,
                    keys: nameKey,
                    //validator: FullNameValidator,
                    onChanged: (value) {
                      experience = int.parse(value);
                    },
                    initialValue: userProvider?.appUser?.experience == null
                        ? ""
                        : "${userProvider?.appUser?.experience}",
                    onPressed: saveLoading
                        ? null
                        : () async {
                            if (nameKey.currentState?.validate() == true) {
                              setState(() {
                                saveLoading = true;
                              });

                              user?.experience = experience;
                              search["experience"] = experience;
                              await mongo.doctorCollection.save(search);
                              //await  updateDocInfo(user: user!);
                              await updateUser(user: user!);
                              await RealtimeDatabase.update(
                                  userId: auth.currentUser!.uid, user: user);
                              setState(() {
                                saveLoading = false;
                                Navigator.pushReplacementNamed(
                                    context, "profile");
                              });
                            }
                          },
                  );
          });
        });
  }

  String? phoneNumberValidator(String? value) {
    final pattern = RegExp("([0][2358])[0-9]{8}");

    if (pattern.stringMatch(value ?? "") != value) {
      return "Invalid PhoneNumber";
    }

    return null;
  }

  String? FullNameValidator(String? value) {
    final pattern = RegExp("([A-Z][a-z]+)[/s/ ]([A-Z][a-z]+)");

    if (pattern.stringMatch(value ?? "") != value) {
      return "Invalid fullname";
    }

    return null;
  }

  String? emailValidator(String? value) {
    final pattern =
        RegExp("^([a-zA-Z0-9_/-/./]+)@([a-zA-Z0-9_/-/.]+)[.]([a-zA-Z]{2,5})");
    if (pattern.stringMatch(value ?? "") != value) {
      return "Invalid Email address";
    }
    return null;
  }

  Future<void> showNumber({required User? user}) async {
    print(userProvider?.appUser?.fullname);
    // var search= await mongo.doctorCollection.findOne(
    //   {"name":"${userProvider?.appUser?.fullname}"},);
    String? number = user?.number;
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return saveLoading
                ? DialogLoading()
                : DialogProfile(
                    keys: numberKey,
                    profileType: "number",
                    onChanged: (value) {
                      number = value;
                    },
                    validator: phoneNumberValidator,
                    initialValue: '0${user?.number?.substring(4)}',
                    onPressed: saveLoading
                        ? null
                        : () async {
                            if (numberKey.currentState?.validate() == true) {
                              setState(() {
                                saveLoading = true;
                              });

                              user?.number = '+233${number?.substring(1)}';
                              //search["number"]='+233${number?.substring(1)}';
                              // await mongo.doctorCollection.update(search);
                              await mongo.update(
                                  "email",
                                  "${userProvider?.appUser?.email}",
                                  "number",
                                  "+233${number?.substring(1)}");
                              await updateUser(user: user!);
                              await RealtimeDatabase.update(
                                  userId: auth.currentUser!.uid, user: user);
                              setState(() {
                                saveLoading = false;
                                Navigator.pushReplacementNamed(
                                    context, "profile");
                              });
                            }
                          },
                  );
          });
        });
  }

  Future<void> showEmail({required User? user}) async {
    var search = await mongo.doctorCollection.findOne(
      {"number": "${userProvider?.appUser?.number}"},
    );
    String? email = user?.email;
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return saveLoading
                ? DialogLoading()
                : DialogProfile(
                    keys: emailKey,
                    validator: emailValidator,
                    profileType: "email",
                    onChanged: (value) {
                      email = value;
                    },
                    initialValue: '${userProvider?.appUser?.email}',
                    onPressed: saveLoading
                        ? null
                        : () async {
                            if (emailKey.currentState?.validate() == true) {
                              setState(() {
                                saveLoading = true;
                              });

                              user?.email = email;
                              search["email"] = email;
                              await mongo.doctorCollection.save(search);
                              await updateUser(user: user!);
                              await RealtimeDatabase.update(
                                  userId: auth.currentUser!.uid, user: user);
                              setState(() {
                                saveLoading = false;
                                Navigator.pushReplacementNamed(
                                    context, "profile");
                              });
                            }
                          },
                  );
          });
        });
  }

  Future<void> changeProfile({required User? user}) async {
    String? number = user?.email;
    showModalBottomSheet<dynamic>(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
                width: double.infinity,
                height: 600,
                padding: EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
                child: Column(children: [
                  Text("Choose from camera or gallery",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  SizedBox(height: 50),
                  SecondaryButton(
                      child: Text("Camera"),
                      onPressed: () async {
                        await getCameraImage();
                      },
                      color: Colors.pink,
                      backgroundColor: Colors.pink),
                  SizedBox(height: 20),
                  SecondaryButton(
                      child: Text("Gallery"),
                      onPressed: () async {
                        await getFileImage();
                      },
                      backgroundColor: Colors.greenAccent,
                      color: Colors.greenAccent)
                ]));
          });
        });
  }

  Future<void> locationEdit() async {
    showModalBottomSheet<dynamic>(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return BottomSheetContainer(
              keys: locationKey, initialValue: "Location", onPressed: () {});
        });
  }

  String? oldPinValidator(String? value) {
    final pattern = RegExp("[0-9]{4}");
    if (value?.isEmpty == true) {
      return "This field is required";
    } else if (pattern.stringMatch(value ?? "") != value) {
      return "Pin is not equal";
    }
    return null;
  }

  String? pinValidator(String? value) {
    final pattern = RegExp("[0-9]{4}");
    if (value?.isEmpty == true) {
      return "This field is required";
    } else if (pattern.stringMatch(value ?? "") != value) {
      return "Pin is not equal";
    }
    return null;
  }

  String? confirmPinValidator(String? value) {
    final pattern = RegExp("[0-9]{4}");
    if (value?.isEmpty == true) {
      return "This field is required";
    }

    // if (pattern.stringMatch(value ?? "") != value) {
    //   return AppStrings.invalidPhoneNumber;
    // }
    else if (pattern.stringMatch(value ?? "") != value) {
      return "Pin is not equal";
    } else if (value != pinNew.text) {
      return "Pin does not match";
    }
    return null;
  }

  String? inputValidator(String? value) {
    if (value?.isEmpty == true) {
      return "This field is required";
    }
    return null;
  }

  Future<void> pinEdit({required User? user}) async {
    var search = await mongo.doctorCollection.findOne(
      {"number": "${userProvider?.appUser?.number}"},
    );
    String? oldPin = user?.password;
    String? correctPin;
    showModalBottomSheet<dynamic>(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
                width: double.infinity,
                height: 600,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
                margin: EdgeInsets.all(10),
                child: Visibility(
                  visible: !saveLoading,
                  replacement: Center(
                    child: SpinKitFadingCube(
                      color: Colors.pink,
                      size: 50.0,
                    ),
                  ),
                  child: Form(
                    key: pinKey,
                    child: Column(children: [
                      Expanded(
                        child: ListView(children: [
                          SizedBox(height: 10),
                          Center(
                              child: Text("Change Pin",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18))),
                          SizedBox(height: 40),
                          Text("Enter old pin",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          MainInput(
                            obscureText: obscure,
                            controller: pinOld,
                            validator: oldPinValidator,
                            onChanged: (value) {},
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscure = false;
                                    index++;
                                    if (index % 2 == 0) {
                                      obscure = true;
                                    }
                                  });
                                },
                                icon: obscure == true
                                    ? SvgPicture.asset("./assets/svgs/eye.svg",
                                        color: Colors.black)
                                    : SvgPicture.asset(
                                        "./assets/svgs/eye-off.svg",
                                        color: Colors.pink)),
                          ),
                          SizedBox(height: 20),
                          Text("Enter new pin",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          MainInput(
                            obscureText: obscure1,
                            controller: pinNew,
                            validator: pinValidator,
                            onChanged: (value) {},
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscure1 = false;
                                    index1++;
                                    if (index1 % 2 == 0) {
                                      obscure1 = true;
                                    }
                                  });
                                },
                                icon: obscure1 == true
                                    ? SvgPicture.asset("./assets/svgs/eye.svg",
                                        color: Colors.black)
                                    : SvgPicture.asset(
                                        "./assets/svgs/eye-off.svg",
                                        color: Colors.pink)),
                          ),
                          SizedBox(height: 20),
                          Text("Confirm new pin",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          MainInput(
                            obscureText: obscure2,
                            controller: pinConfirm,
                            validator: confirmPinValidator,
                            onChanged: (value) {},
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscure2 = false;
                                    index2++;
                                    if (index2 % 2 == 0) {
                                      obscure2 = true;
                                    }
                                  });
                                },
                                icon: obscure2 == true
                                    ? SvgPicture.asset("./assets/svgs/eye.svg",
                                        color: Colors.black)
                                    : SvgPicture.asset(
                                        "./assets/svgs/eye-off.svg",
                                        color: Colors.pink)),
                          ),
                        ]),
                      ),
                      SecondaryButton(
                          child: Text("Confirm"),
                          onPressed: saveLoading
                              ? null
                              : () async {
                                  if (pinKey.currentState?.validate() == true) {
                                    setState(() {
                                      saveLoading = true;
                                      correctPin = pinOld.text;
                                      print(correctPin);
                                    });

                                    var userData = user;
                                    print(correctPin);
                                    if (correctPin == userData?.password) {
                                      userData?.password = pinNew.text;
                                      search["password"] = pinNew.text;
                                      await mongo.doctorCollection.save(search);
                                      updateUser(user: userData!);
                                      await RealtimeDatabase.update(
                                          userId: auth.currentUser!.uid,
                                          user: userData);
                                      setState(() {
                                        saveLoading = false;
                                        pinConfirm.clear();
                                        pinNew.clear();
                                        pinOld.clear();
                                      });
                                      Navigator.pop(context);
                                    } else {
                                      print("Wrong pin");
                                      setState(() {
                                        saveLoading = false;
                                        pinConfirm.clear();
                                        pinNew.clear();
                                        pinOld.clear();
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        duration: Duration(seconds: 5),
                                        content: Text(
                                            "Entered old pin is wrong",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        backgroundColor:
                                            Color.fromRGBO(20, 100, 150, 1),
                                      ));
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                          color: Colors.pink,
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white),
                      SizedBox(height: 10)
                    ]),
                  ),
                ));
          });
        });
  }

  Future getCameraImage() async {
    ImagePicker picker = ImagePicker();
    PickedFile? pickedFile;
    pickedFile = (await picker.getImage(
      source: ImageSource.camera,
    ));
    setState(() {
      if (pickedFile != null) {
        // _images?.add(File(pickedFile.path));
        _image = File(pickedFile.path); // Use if you only need a single picture
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            // Pass the automatically generated path to
            // the DisplayPictureScreen widget.
            imagePath: pickedFile!.path,
          ),
        ));
      } else {
        print('No image selected.');
      }
    });
  }

  Future getFileImage() async {
    ImagePicker picker = ImagePicker();
    PickedFile? pickedFile;
    pickedFile = (await picker.getImage(
      source: ImageSource.gallery,
    ));
    setState(() {
      if (pickedFile != null) {
        // _images?.add(File(pickedFile.path));
        _image = File(pickedFile.path); // Use if you only need a single picture
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            // Pass the automatically generated path to
            // the DisplayPictureScreen widget.
            imagePath: pickedFile!.path,
          ),
        ));
      }
    });
  }

  Future<void> showExitPopup() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.black54,
              content: Container(
                decoration: BoxDecoration(
                    // color: Color.fromRGBO(210, 230, 250, 0.2),
                    borderRadius: BorderRadius.circular(20)),
                height: 120,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Are you sure you want to logout?",
                        style: TextStyle(color: Colors.white)),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                Navigator.pushReplacementNamed(
                                    context, 'homeScreen');
                              });
                            },
                            child: Text("Yes"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                                foregroundColor: Colors.white),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              Navigator.of(context).pop();
                            });
                          },
                          child:
                              Text("No", style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white70,
                            // shape: const OutlinedBorder(
                            //   side: BorderSide(color: Colors.blue,width: 2,style: BorderStyle.solid)
                            // )
                          ),
                        )),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }
}
