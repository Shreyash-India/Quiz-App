import 'package:flutter/material.dart';
import 'package:quizapp2/helper/constants.dart';
import 'package:quizapp2/services/firebase_authentication.dart';
import 'package:quizapp2/services/firebase_database.dart';
import 'package:quizapp2/views/home.dart';
import 'package:quizapp2/widget/stateless/app_title_widget.dart';

class SignUp extends StatefulWidget {
  final Function toogleView;

  SignUp({this.toogleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthService authService = new AuthService();
  DatabaseService databaseService = new DatabaseService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passEditingController = TextEditingController();

  String email = '', password = '', name = "";

  getInfoAndSignUp() async {
    if (_formKey.currentState.validate()) {
      await authService
          .signUpWithEmailAndPassword(email, password)
          .then((value) {
        Map<String, String> userInfo = {
          "userName": name,
          "email": email,
        };
        databaseService.addData(userInfo);
        Constants.saveUserLoggedInSharedPreference(true);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AppLogo(),
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Color.fromARGB(255, 145, 211, 244).withOpacity(0.2),
                      BlendMode.srcATop),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/quizzfy.jpg'),
                  ),
                ),
              ],
            ),
            Spacer(),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (val) => val.isEmpty ? "Enter an Name" : null,
                    decoration: InputDecoration(hintText: "Name"),
                    controller: nameController,
                    onChanged: (val) {
                      name = val;
                    },
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  TextFormField(
                    validator: (val) =>
                        validateEmail(email) ? null : "Enter correct email",
                    decoration: InputDecoration(hintText: "Email"),
                    controller: emailEditingController,
                    onChanged: (val) {
                      email = val;
                    },
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  TextFormField(
                    obscureText: true,
                    validator: (val) => val.length < 7
                        ? "Password must contains atleast than 7 characters"
                        : null,
                    decoration: InputDecoration(hintText: "Password"),
                    controller: passEditingController,
                    onChanged: (val) {
                      password = val;
                    },
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onTap: () {
                      getInfoAndSignUp();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('already have account? ',
                          style:
                              TextStyle(color: Colors.black87, fontSize: 17)),
                      GestureDetector(
                        onTap: () {
                          widget.toogleView();
                        },
                        child: Container(
                          child: Text('Sign In',
                              style: TextStyle(
                                  color: Colors.black87,
                                  decoration: TextDecoration.underline,
                                  fontSize: 17)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 80,
            )
          ],
        ),
      ),
    );
  }
}

bool validateEmail(String email) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(email)) ? false : true;
}

bool validateName(String name) {
  final RegExp regex = new RegExp('[a-zA-Z]');
  return regex.hasMatch(name) ? true : false;
}
