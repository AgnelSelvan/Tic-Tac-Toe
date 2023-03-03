# TIC TAC TOE

TIC TAC TOE Multiplayer Game using Flutter and Firebase.

## Getting Started

### Flutter Setup
This project is a starting point for a Flutter application.

- [Download Flutter in their official webaite](https://docs.flutter.dev/get-started/install)

### Firebase Setup

- [Create a new Project in Firebase](https://console.firebase.google.com/u/0/)
![image](https://user-images.githubusercontent.com/47639176/222667712-4c2ec0b3-2dfd-4ca9-85d9-9a7e5e08eb98.png)


#### Android Setup

- Enter the App's Pakage ID and SHA-1 Key

For generating SHA-1 key open the terminal of your project and type **cd android** and then enter
```dart
./gradlew signingReport
```
Copy SHA-1 Key and Paste it in Debug signing Certificate. 

![image](https://user-images.githubusercontent.com/47639176/222669066-cd91d94f-c346-463d-92c9-11705ed9f6de.png)
click Register App

- Download the google-services.json file
![image](https://user-images.githubusercontent.com/47639176/222668363-dc584ba1-eee6-46f1-9230-3eb981c246c9.png)
and place the file inside *android/app/* folder.

- Enable the Google Authentication and Google Firebase Service from Firebase.
<img src="./screenshot/4.png" />
<img src="./screenshot/5.png" />
