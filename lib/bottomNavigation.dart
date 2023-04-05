import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:doctor/MainButton.dart';
import 'package:doctor/main.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {


  @override
  Widget build(BuildContext context) {
    return  BottomNavigationBar(
      type:BottomNavigationBarType.fixed,
      selectedItemColor:Colors.pink,
      unselectedItemColor: Colors.black,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      // color: Color.fromRGBO(0, 110, 255, 1),
      onTap:(index) {
        if(index==0){
          setState((){

            Navigator.pushReplacementNamed(context, "homepage");
            indexed=index;
            print(indexed);
          });}
        else if(index==1){
          setState((){
            Navigator.pushReplacementNamed(context,"doctorsAvailable");
            indexed=index;

          });}
        else if(index==2){
          setState(()  {
            Navigator.pushReplacementNamed(context, "appoinments");
            indexed=index;
            print(indexed);
            print(index);
          });}
        else if(index==3){setState((){
          Navigator.pushReplacementNamed(context, "profile");
          indexed=index;
        });}
      },
      currentIndex: indexed,
      items: [
        BottomNavigationBarItem(
          activeIcon:IconLabelButton(label: "Home",icon:SvgPicture.asset('./assets/svgs/home.svg',color: Colors.white),
        onPressed: (){},backgroundColor:Colors.pink, color: Colors.pink),
          label:"Home",
          icon:SvgPicture.asset('./assets/svgs/home.svg',color: Colors.black,width:18,height:18),
        ),
        BottomNavigationBarItem(
          label:"Patients",
          icon:SvgPicture.asset('./assets/svgs/users.svg',color: Colors.black,width:18,height:18),
           activeIcon:IconLabelButton(label: "Patient",icon:SvgPicture.asset('./assets/svgs/users.svg',
               color: Colors.white),
               onPressed: (){},backgroundColor:Colors.pink, color: Colors.pink),
        ),

        BottomNavigationBarItem(
          label:"Schedules",
          backgroundColor: Color.fromRGBO(0, 110, 255, 1),
          icon:SvgPicture.asset('./assets/svgs/edit.svg',color: Colors.black,width:18,height:18),
          activeIcon:IconLabelButton(label: "Date",icon:SvgPicture.asset('./assets/svgs/edit.svg',
              color: Colors.white),
    onPressed: (){},backgroundColor:Colors.pink, color: Colors.pink),
        ),
        BottomNavigationBarItem(
          label: "Profile",
          icon:SvgPicture.asset('./assets/svgs/user.svg',color: Colors.black,width:18,height:18),
          activeIcon:IconLabelButton(label: "Profile",icon:SvgPicture.asset('./assets/svgs/user.svg',
              color: Colors.white),
              onPressed: (){},backgroundColor:Colors.pink, color: Colors.pink),
        ),

      ],
    );
  }
}
