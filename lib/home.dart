import 'package:ar_furniture/constants.dart';
import 'package:ar_furniture/game.dart';
import 'package:ar_furniture/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  Future<void> _showLogoutAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Logout Alert"),
            content: const Text("Are you shure want to logout?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No")),
              ElevatedButton(
                  onPressed: () async {
                    await GoogleSignIn().signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: const Text("Yes")),
            ],
          );
        });
  }

  _showJoinTeamDialog(context) {
    final controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Enter Team Code"),
          contentPadding: const EdgeInsets.all(10),
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: "Enter Room Code",
              ),
              controller: controller,
            ),
            TextButton(
                onPressed: () async {
                  print(controller.text);
                  final id = controller.text;
                  final docData = await game.doc(id).get();
                  if (docData.exists) {
                    await game.doc(id).update(
                      {
                        "0PlayerId": FirebaseAuth.instance.currentUser?.uid,
                      },
                    );
                    if (context.mounted) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: ((context) {
                        return GameScreen(id: id);
                      })));
                    }
                  } else {
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("No Such Room ID Exists"),
                        ),
                      );
                    }
                  }
                },
                child: const Text("Join")),
          ],
        );
      },
    );
  }

  final game = FirebaseFirestore.instance.collection("games");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TIC - TAC - TOE",
          style: TextStyle(color: Colors.grey[800]!),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showLogoutAlert(context);
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.red,
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    _showJoinTeamDialog(context);
                  },
                  child: const Text("Join A Team")),
              TextButton(
                  onPressed: () async {
                    final id = Constants.generateTeamID;
                    print(id);
                    final googleSignInAccount =
                        FirebaseAuth.instance.currentUser;

                    try {
                      await game.doc(id).set({
                        "id": id,
                        "displayElement": ['', '', '', '', '', '', '', '', ''],
                        "xPlayerId": googleSignInAccount?.uid,
                        "currentPlayerTurn": "X",
                      });
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text("Table Created Successfully"),
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameScreen(
                              id: id,
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("$e"),
                        ),
                      );
                    }
                  },
                  child: const Text("Create A Team")),
            ],
          ),
        ),
      ),
    );
  }
}
