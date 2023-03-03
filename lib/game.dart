import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.id});
  final String id;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late User? user;
  String? playerTurn;
  late DocumentReference<Map<String, dynamic>> documentReference;
  late ConfettiController confettiController;

  _performInit() async {
    confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    documentReference =
        FirebaseFirestore.instance.collection("games").doc(widget.id);
    user = FirebaseAuth.instance.currentUser;
    final docData = (await FirebaseFirestore.instance
            .collection("games")
            .doc(widget.id)
            .get())
        .data();
    final xPlayerId = docData?['xPlayerId'];
    final oPlayerId = docData?['0PlayerId'];
    if (user?.uid == xPlayerId) {
      playerTurn = "X";
    } else {
      playerTurn = "0";
    }
    setState(() {});
  }

  _checkForCollectionChanges() {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      final docSnap = FirebaseFirestore.instance
          .collection("games")
          .doc(widget.id)
          .snapshots();
      docSnap.listen((event) {
        log("event: ${event.data()}");
        final winner = event.data()?['winner'];
        if (winner != null && winner != '') {
          if (winner == playerTurn) {
            confettiController.play();
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(winner == 'draw'
                  ? "Match Got Draw"
                  : "Player $winner has won the Game"),
              action: SnackBarAction(
                  label: "Okay",
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  }),
            ),
          );
          setState(() {});
          // _showWinDialog(context, winner ?? '');
        }
      });
    });
  }

  @override
  void initState() {
    _performInit();
    _checkForCollectionChanges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Turn ${playerTurn ?? ''}",
          style: TextStyle(
            color: Colors.grey[800]!,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: documentReference.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text(widget.id),
                      GridView.builder(
                        itemCount:
                            snapshot.data?.data()?["displayElement"].length ??
                                0,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemBuilder: (BuildContext context, int index) {
                          final docData = snapshot.data?.data();
                          final value = docData?["displayElement"][index];
                          // if (docData?["winner"] != null || docData?['winner'] != "") {
                          //   _showWinDialog(context, docData?["winner"] ?? '');
                          // }
                          return GestureDetector(
                            onTap: () async {
                              final docData =
                                  (await documentReference.get()).data();
                              if (docData?["winner"] == "" ||
                                  docData?["winner"] == null) {
                                if (docData?["currentPlayerTurn"] ==
                                    playerTurn) {
                                  List<String> displayElement =
                                      List<String>.from(
                                          (docData?['displayElement'] ?? []));
                                  if (displayElement[index] == "") {
                                    displayElement[index] = playerTurn ?? '';
                                    final winner = _checkWinner(displayElement);
                                    await documentReference.update({
                                      "displayElement": displayElement,
                                      "currentPlayerTurn":
                                          playerTurn == "X" ? "0" : "X",
                                      "winner": winner ?? "",
                                    });
                                  }
                                }
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 5,
                                    )
                                  ]),
                              margin: const EdgeInsets.all(10),
                              child: Center(
                                  child: Text(
                                value.toString(),
                                style: const TextStyle(
                                  fontSize: 24,
                                ),
                              )),
                            ),
                          );
                        },
                      )
                    ],
                  );
                }
                return const CircularProgressIndicator();
              }),
          // if (isWinner)
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                particleDrag: 0.05,
                emissionFrequency: 0.05,
                numberOfParticles: 10,
                gravity: 0.05,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink
                ], // manually specify the colors to be used
                strokeWidth: 1,
                strokeColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showWinDialog(BuildContext context, String winner) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(winner == 'draw'
                ? "Match Got Draw"
                : "Player $winner has won the Game"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Okay"),
              ),
            ],
          );
        });
  }

  String? _checkWinner(List<String> displayElement) {
    if (displayElement[0] == displayElement[1] &&
        displayElement[0] == displayElement[2] &&
        displayElement[0] != "") {
      return displayElement[0];
    }
    if (displayElement[3] == displayElement[4] &&
        displayElement[3] == displayElement[5] &&
        displayElement[3] != "") {
      return displayElement[3];
    }
    if (displayElement[6] == displayElement[7] &&
        displayElement[6] == displayElement[8] &&
        displayElement[6] != "") {
      return displayElement[6];
    }

    if (displayElement[0] == displayElement[3] &&
        displayElement[0] == displayElement[6] &&
        displayElement[0] != "") {
      return displayElement[0];
    }
    if (displayElement[1] == displayElement[4] &&
        displayElement[1] == displayElement[7] &&
        displayElement[1] != "") {
      return displayElement[1];
    }
    if (displayElement[2] == displayElement[5] &&
        displayElement[2] == displayElement[8] &&
        displayElement[2] != "") {
      return displayElement[2];
    }

    if (displayElement[0] == displayElement[4] &&
        displayElement[0] == displayElement[8] &&
        displayElement[0] != "") {
      return displayElement[0];
    }

    if (displayElement[2] == displayElement[4] &&
        displayElement[2] == displayElement[6] &&
        displayElement[2] != "") {
      return displayElement[2];
    }

    if (displayElement[0] == displayElement[1] &&
        displayElement[0] == displayElement[2] &&
        displayElement[0] != "") {
      return displayElement[0];
    }

    if (isAllBoxFilled(displayElement)) {
      return "draw";
    }
    return null;
  }

  bool isAllBoxFilled(List<String> allData) {
    return allData[0] != "" &&
        allData[1] != "" &&
        allData[2] != "" &&
        allData[3] != "" &&
        allData[4] != "" &&
        allData[5] != "";
  }
}
