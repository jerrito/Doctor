import 'package:doctor/widgets/MainButton.dart';
import 'package:doctor/constants/Size_of_screen.dart';
import 'package:doctor/appointments.dart';
import 'package:doctor/widgets/doctorSearch.dart';
import 'package:doctor/firebase_options.dart';
import 'package:doctor/homePage.dart';
import 'package:doctor/login_signup/login.dart';
import 'package:doctor/databases/mongo.dart';
import 'package:doctor/patients.dart';
import 'package:doctor/profile.dart';
import 'package:doctor/login_signup/signUp.dart';
import 'package:doctor/login_signup/splash.dart';
import 'package:doctor/userProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_manager/theme_manager.dart';

class LifecycleWatcher extends StatefulWidget {
  const LifecycleWatcher({super.key, required AppPage child});

  @override
  State<LifecycleWatcher> createState() => _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher>
    with WidgetsBindingObserver {
  AppLifecycleState? _lastLifecycleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lastLifecycleState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_lastLifecycleState == null) {
      return const Text(
        'This widget has not observed any lifecycle changes.',
        textDirection: TextDirection.ltr,
      );
    }

    return Text(
      'The most recent lifecycle state this widget observed was: $_lastLifecycleState.',
      textDirection: TextDirection.ltr,
    );
  }
}

// void main() {
//   runApp(const Center(child: LifecycleWatcher())
//   );
// }
int indexed = 0;
double w = SizeConfig.W;
double h_s = SizeConfig.SV;
double h = SizeConfig.H;
double w_s = SizeConfig.SH;
dynamic subscription;
// ThemeData _buildTheme(brightness) {
//   var baseTheme = ThemeData(
//       brightness: brightness,
//       primaryIconTheme: const IconThemeData(color: Colors.amberAccent),
//       primarySwatch: Colors.amber,
//       primaryColor: Colors.amberAccent);
//
//   return baseTheme.copyWith(
//     textTheme: GoogleFonts.notoSansGeorgianTextTheme(baseTheme.textTheme),
//   );
// }

// Future<void> network() async {
//   final connectivityResult = await (Connectivity().checkConnectivity());
//   if (connectivityResult == ConnectivityResult.mobile) {
// // I am connected to a mobile network.
//   } else if (connectivityResult == ConnectivityResult.wifi) {
// // I am connected to a wifi network.
//   }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

// var db = await Db.Db.create(url);
//   await db.open();
  //runApp(const LifecycleWatcher(child: AppPage()));
  runApp(const AppPage());
}

class AppPage extends StatelessWidget {
  final Widget? child;
  const AppPage({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            color: Colors.white,
          );
        }
        return ThemeManager(
            defaultBrightnessPreference: BrightnessPreference.light,
            data: (Brightness brightness) => ThemeData(
                  iconTheme: const IconThemeData(color: Colors.black),
                  primaryColor: Colors.black,
                  primarySwatch: Colors.pink,
                  textTheme: GoogleFonts.notoSansGeorgianTextTheme(
                      ThemeData().textTheme),
                  //accentColor: Colors.lightBlue,
                  brightness: Brightness.light,
                ),
            loadBrightnessOnStart: true,
            themedWidgetBuilder: (BuildContext context, ThemeData theme) {
              return MultiProvider(
                  providers: [
                    ListenableProvider(
                      create: (_) => UserProvider(preferences: snapshot.data),
                    ),
                  ],
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: theme,
                    initialRoute: "splash",
                    routes: {
                      "homeScreen": (context) => const HomeScreen(),
                      "login": (context) => const LoginSignUp(),
                      "splash": (context) => const Splashscreen(),
                      "signup": (context) => const Signuppage(),
                      "homepage": (context) => const HomePage(),
                      "doctorSearch": (context) => const DoctorSearch(
                            cardvalue: "Family physician",
                          ),
                      "profile": (context) => Profile(
                            profileUpdate:
                                ProfileUpdate(imagePath: "", check: "see"),
                          ),
                      "doctorsAvailable": (context) => const DoctorsAvailable(),
                      //"doctorAppointment": (context)=>DoctorAppointment(),
                      "appoinments": (context) => Appointments(
                            date: DateTime.now(),
                            time: '12:00 pm',
                            doctorName: 'Jerrito',
                            speciality: 'Gynaecologist',
                            location: "UCC Hospital",
                          ),
                      //"appoinmentList": (context)=>AppointmentList(date: null, time: '',),
                      // "doctorOptions": (context)=>DoctorOptions(),
                    },
                  ));
            });
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    mongo.con();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(210, 230, 250, 0.2),
          ),
          padding: const EdgeInsets.all(10),

          // margin: const EdgeInsets.only(left: 150),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView(children: [
                const Center(
                    child: Text(
                  "ONLINE HEALTH CARE",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: h_s * 18.75,
                    backgroundImage: Image.asset(
                      "./assets/images/doctor_1.jpg",
                      height: h / 3,
                      width: w,
                    ).image,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Center(
                    child: Text(
                  "Good Day Doctor",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
                const Center(
                    child: Text(
                  "Welcome To Quality Online HealthCare ",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                )),
                const Center(
                    child: Text(
                  "Here your health is our priority",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                )),
              ]),
            ),
            SecondaryButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "login");
              },
              foregroundColor: Colors.white,
              backgroundColor: Colors.pink,
              color: Colors.pink,
              child: const Text("Login",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            SecondaryButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.pink,
              onPressed: () {
                Navigator.pushReplacementNamed(context, "signup");
              },
              color: Colors.pink,
              child: const Text("Signup",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20)
          ])),
    );
  }
}
