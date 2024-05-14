import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/firebase_options.dart';
import 'package:mini_project/pages/createfundraise.dart';
import 'package:mini_project/pages/edit_profile.dart';
import 'package:mini_project/pages/forgotpassword1.dart';
import 'package:mini_project/pages/home.dart';
import 'package:mini_project/pages/profile.dart';
import 'package:mini_project/pages/sign_in.dart';
import 'package:mini_project/pages/sign_up.dart';
import 'package:mini_project/pages/wallet.dart'; 
import 'package:mini_project/pages/welcome.dart';
import 'package:mini_project/pages/project.dart';
import 'package:mini_project/pages/withdraw.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/signin': (context) => const SignIn(),
        '/signup': (context) => const SignUp(),
        '/project': (context) => const ProjectPage(),
        '/profile':(context) => const ProfilePage(),
        '/createProject' : (context) => const CreateFundRaisePage(),
        '/wallet':(context) => const WalletPage(),
        '/forgotpassword1':(context) => const ForgotPage1(),
        '/editprofile':(context) => const EditProfilePage(),
        '/withdraw':(context) => const WithdrawPage(),
      },
    );
  }
}
