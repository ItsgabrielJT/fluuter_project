import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluuter_project/Screens/account/akunPage.dart';
import 'package:fluuter_project/Screens/login/login.dart';
import 'package:fluuter_project/Screens/maps/calculate_area.dart';
import 'package:fluuter_project/Screens/maps/maps.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({Key? key}) : super(key: key);

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class UserProfileDrawerHeader extends StatefulWidget {
  @override
  _UserProfileDrawerHeaderState createState() =>
      _UserProfileDrawerHeaderState();
}

class _UserProfileDrawerHeaderState extends State<UserProfileDrawerHeader> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: auth.currentUser!.uid)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs.first),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const UserAccountsDrawerHeader(
            accountName: Text('Loading...'),
            accountEmail: Text('Loading...'),
            currentAccountPicture: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 195, 248, 184)),
          );
        }

        if (snapshot.hasError) {
          return const UserAccountsDrawerHeader(
            accountName: Text('Error'),
            accountEmail: Text('Error'),
            currentAccountPicture: CircleAvatar(backgroundColor: Colors.red),
          );
        }

        if (snapshot.hasData) {
          var data = snapshot.data!.data();
          var username = data['name'];
          var email = data['email'];
          var userType = data['userType'];
          var imageUrl = data['imageUrl'];

          return UserAccountsDrawerHeader(
            accountName: Text(username),
            accountEmail: Text(userType),
            currentAccountPicture: imageUrl != null
                ? CircleAvatar(backgroundImage: NetworkImage(imageUrl))
                : const CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 195, 248, 184)),
            decoration: BoxDecoration(
              color: Color.fromRGBO(26, 228, 130, 1), // Cambia este color al que desees
            ),
          );
        }

        return const UserAccountsDrawerHeader(
          accountName: Text('No data'),
          accountEmail: Text('No data'),
          currentAccountPicture: CircleAvatar(backgroundColor: Colors.orange),
        );
      },
    );
  }
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 245, 245, 245),
        elevation: 0.0,
        flexibleSpace: Container(
          width: 200,
          height: 200,
          
        ),
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // memberi spasi antar widget
          children: [
            SizedBox(
              width: 100,
            ),
          ],
        ),
      ),
      body: CalculateAreaScreen(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserProfileDrawerHeader(),

            // Menu Map
            ListTile(
              leading: const Icon(Icons.location_on),
              hoverColor: Color.fromRGBO(105, 240, 174, 1),
              title: const Text('Mapa'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreenBody()),
                );
              },
            ),

            

            // Menu Profile
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              hoverColor: Color.fromRGBO(105, 240, 174, 1),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AkunPage()),
                );
              },
            ),

            // Menu Logout
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesion'),
              hoverColor: Color.fromRGBO(105, 240, 174, 1),

              onTap: () async {
                await FirebaseAuth.instance.signOut();
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
