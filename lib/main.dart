import 'package:ar_furniture/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
          future: GoogleSignIn().isSignedIn(),
          builder: ((context, snapshot) {
            if (snapshot.data == true) {
              return HomeScreen();
            }
            return const SignUpScreen();
          })),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final usersCollection = FirebaseFirestore.instance.collection("users");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            final googleSignIn = GoogleSignIn();
            final googleSignInAccount = await googleSignIn.signIn();
            if (googleSignInAccount != null) {
              final googleAuthentication =
                  await googleSignInAccount.authentication;
              final authCred = GoogleAuthProvider.credential(
                accessToken: googleAuthentication.accessToken,
                idToken: googleAuthentication.idToken,
              );
              final user = await auth.signInWithCredential(authCred);

              try {
                await usersCollection.doc(googleSignInAccount.id).set({
                  "displayName": user.user?.displayName,
                  "email": user.user?.email,
                  "photoUrl": user.user?.photoURL,
                  "id": user.user?.uid,
                });
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              } catch (e) {
                print(e);
              }
            }
          },
          style: ButtonStyle(
              padding:
                  MaterialStateProperty.all(const EdgeInsets.only(right: 10))),
          icon: Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Image.asset('assets/images/google-logo.png')),
          label: const Text("Sign In with Google"),
        ),
      ),
    );
  }
}
