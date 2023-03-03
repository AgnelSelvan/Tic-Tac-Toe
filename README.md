# TIC TAC TOE

TIC TAC TOE Multiplayer Game using Flutter and Firebase.

<img src="./screenshot/output.gif" />

## Getting Started

### Flutter Setup
This project is a starting point for a Flutter application.

- [Download Flutter from their official website](https://docs.flutter.dev/get-started/install)

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

- Enable the Google Authentication 
<img src="./screenshot/4.png" />

- Enabling the Google Login Functionality
Now Select Google from Additional Providers
<img src="./screenshot/6.png" />

Enable the Google Sign In and add your support Mail
<img src="./screenshot/7.png" />

We have Successfully done the setup for Google Login In Firebase
<img src="./screenshot/8.png" />


- Google Firestore Service from Firebase
<img src="./screenshot/5.png" />

Select the Test Mode and click on Next
<img src="./screenshot/9.png" />

Now inside Rules make the if condition to true and Publish the changes.
<img src="./screenshot/9.png" width=600 />

**Firebase setup has completed successfully.**

Now to run the application

Open the terminal and enter
```cmd
    git clone https://github.com/AgnelSelvan/Tic-Tac-Toe.git
```

and open the project in respective IDE and in Terminal enter
```cmd
    flutter pub get
```
 and now run the application.