import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:udhari_2/Screens/HomePages/Dashboard.dart';
import 'package:udhari_2/Screens/HomePages/Trips.dart';
import 'package:udhari_2/Screens/HomePages/History.dart';
import 'package:udhari_2/Screens/HomePages/NormalUdhari.dart';
import 'package:udhari_2/Screens/Intro.dart';
import 'package:udhari_2/Utils/ScreenHandler.dart';
import 'package:udhari_2/Utils/IconHandler.dart';
import 'package:udhari_2/Widgets/Layout.dart';
import 'package:udhari_2/Widgets/FabWithIcons.dart';

class HomePage extends StatefulWidget {
  HomePage({@required this.user});

  final FirebaseUser user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScreenHandler screens;
  IconHandler homeIcon =
      IconHandler(Icon(Icons.home, color: Colors.blueAccent));
  IconHandler personIcon = IconHandler(Icon(Icons.person));
  IconHandler peopleIcon = IconHandler(Icon(Icons.group));
  IconHandler historyIcon = IconHandler(Icon(Icons.history));

  @override
  void initState() {
    super.initState();
    screens = ScreenHandler(Dashboard(user: widget.user));
  }

  @override
  void dispose() {
    super.dispose();
    screens.screenController.close();
    homeIcon.iconController.close();
    personIcon.iconController.close();
    peopleIcon.iconController.close();
    historyIcon.iconController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(7),
          child: CircleAvatar(
            backgroundImage: NetworkImage("${widget.user.photoUrl}"),
          ),
        ),
        title: Text("Udhari"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              _signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: screens.screenStream,
        initialData: Dashboard(
          user: widget.user,
        ),
        builder: (BuildContext context, snapshot) {
          return snapshot.data;
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: StreamBuilder(
                stream: homeIcon.iconStream,
                initialData: Container(),
                builder: (BuildContext context, snapshot) {
                  return snapshot.data;
                },
              ),
              onPressed: () {
                screens.screenSink.add(Dashboard(user: widget.user));
                homeIcon.changeIcon(Icon(Icons.home, color: Colors.blueAccent));
                personIcon.changeIcon(Icon(Icons.person, color: Colors.black));
                peopleIcon.changeIcon(Icon(Icons.people, color: Colors.black));
                historyIcon
                    .changeIcon(Icon(Icons.history, color: Colors.black));
              },
            ),
            IconButton(
              icon: StreamBuilder(
                stream: personIcon.iconStream,
                initialData: Container(),
                builder: (BuildContext context, snapshot) {
                  return snapshot.data;
                },
              ),
              onPressed: () {
                screens.screenSink.add(NormalUdhari(user: widget.user));
                homeIcon.changeIcon(Icon(Icons.home, color: Colors.black));
                personIcon
                    .changeIcon(Icon(Icons.person, color: Colors.blueAccent));
                peopleIcon.changeIcon(Icon(Icons.people, color: Colors.black));
                historyIcon
                    .changeIcon(Icon(Icons.history, color: Colors.black));
              },
            ),
            SizedBox(
              width: 50,
            ),
            IconButton(
              icon: StreamBuilder(
                stream: peopleIcon.iconStream,
                initialData: Container(),
                builder: (BuildContext context, snapshot) {
                  return snapshot.data;
                },
              ),
              onPressed: () {
                screens.screenSink.add(Trips(user: widget.user));
                homeIcon.changeIcon(Icon(Icons.home, color: Colors.black));
                personIcon.changeIcon(Icon(Icons.person, color: Colors.black));
                peopleIcon
                    .changeIcon(Icon(Icons.people, color: Colors.blueAccent));
                historyIcon
                    .changeIcon(Icon(Icons.history, color: Colors.black));
              },
            ),
            IconButton(
              icon: StreamBuilder(
                stream: historyIcon.iconStream,
                initialData: Container(),
                builder: (BuildContext context, snapshot) {
                  return snapshot.data;
                },
              ),
              onPressed: () {
                screens.screenSink.add(History(user: widget.user));
                homeIcon.changeIcon(Icon(Icons.home, color: Colors.black));
                personIcon.changeIcon(Icon(Icons.person, color: Colors.black));
                peopleIcon.changeIcon(Icon(Icons.people, color: Colors.black));
                historyIcon
                    .changeIcon(Icon(Icons.history, color: Colors.blueAccent));
              },
            ),
          ],
        ),
      ),

      // FAB with Notched bottom appbar taken from https://github.com/bizz84/bottom_bar_fab_flutter
      // by Andrea Bizzotto

      floatingActionButton: _buildFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    print("Logged out");
  }

  Widget _buildFab(BuildContext context) {
    final icons = [Icons.person_add, Icons.group_add, Icons.drive_eta];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy - icons.length * 35.0),
          child: FabWithIcons(
            icons: icons,
            onIconTapped: (_) {
              print("FAB index: $_");
            },
          ),
        );
      },
      child: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add',
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
    );
  }
}