// ignore_for_file: unrelated_type_equality_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizapp2/helper/constants.dart';
import 'package:quizapp2/services/firebase_authentication.dart';
import 'package:quizapp2/services/firebase_database.dart';
import 'package:quizapp2/views/create_quiz.dart';
import 'package:quizapp2/views/play_quiz.dart';
import 'package:quizapp2/views/signin.dart';
import 'package:quizapp2/widget/stateless/app_title_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream quizStream;
  DatabaseService databaseService = new DatabaseService();
  AuthService authService = new AuthService();

  Widget quizList() {
    return Container(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: quizStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Check if snapshot has data
                final querySnapshot = snapshot.data;
                final documents =
                    querySnapshot.docs; // Access the list of documents
                return ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final docData =
                        documents[index].data(); // Access the document data
                    print("$docData");
                    return QuizTile(
                      imageUrl: docData['quizImgUrl'],
                      title: docData['quizTitle'],
                      description: docData['quizDesc'],
                      id: docData["quizId"],
                    );
                  },
                );
              } else {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 60, vertical: 145),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  height: 300,
                  width: 270,
                  child: Column(children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage('assets/images/quizzfy.jpg'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "No quizes available, create one",
                      style: TextStyle(fontSize: 15),
                    ),
                  ]),
                );
              }
            },
          )
        ],
      ),
    );
  }

  void initState() {
    setState(() {
      quizStream = databaseService.getQuizData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AppLogo(),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        elevation: 0.0,
        actions: [
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                  color: Colors.black26,
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    await authService.signOut();
                    setState(() {
                      Constants.saveUserLoggedInSharedPreference(false);
                      Constants.isUserLoggedIn();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                      );
                    });
                  }),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 2, vertical: 3),
            height: 22,
            child: Text(
              "Trivia Challenge for Awesome Prizes!",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ),
          quizList(),
          FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateQuiz()));
            },
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => CreateQuiz()));
      //   },
      // ),
    );
  }
}


class QuizTile extends StatelessWidget {
  final String imageUrl, title, id, description;

  QuizTile({
    @required this.title,
    @required this.imageUrl,
    @required this.description,
    @required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => QuizPlay(id)));
      },
      child: Container(
        height: 170,
        margin: EdgeInsets.symmetric(horizontal: 11, vertical: 13),
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 104, 191, 244),
              blurRadius: 2.0,
              offset: Offset(0, 8),
              spreadRadius: 0.1,
            ),
          ],
          borderRadius: BorderRadius.circular(2),
        ),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              child: Opacity(
                opacity: 0.89,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: 170,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              borderRadius: BorderRadius.circular(2.0),
            ),
            Container(
              color: Colors.black26,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      description,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
