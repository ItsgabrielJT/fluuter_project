import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluuter_project/Screens/homepage/components/home_page_body.dart';

class AkunPage extends StatefulWidget {
  @override
  _AkunPageState createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late User user;
  String? username, email, mobileNumber, userType, collegeName;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser!;
    _loadUserProfile();
  }

  // Carga la finormacion desde el firestore al widget
  Future<void> _loadUserProfile() async {
    var docSnapshot = await firestore.collection("user").doc(user.uid).get();
    if (docSnapshot.exists) {
      var userData = docSnapshot.data();
      setState(() {
        username = userData!["name"];
        email = userData["email"];
        mobileNumber = userData["mobileNumber"];
        userType = userData["userType"];
        collegeName = userData["collegeName"];
      });
    }
  }

  // Muestra el modal de edicion de un campo
  void _showEditDialog(String field) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? value = '';

        return AlertDialog(
          title: Text('Editar $field'),
          content: TextField(
            onChanged: (newValue) {
              value = newValue;
            },
            decoration: InputDecoration(
              labelText: field,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () async {
                if (value != null && value!.isNotEmpty) {
                  try {
                    await firestore
                        .collection('user')
                        .doc(user.uid)
                        .update({field: value});
                    setState(() {
                      // Memperbarui nilai bidang yang sesuai di state
                      switch (field) {
                        case 'name':
                          username = value;
                          break;
                        case 'email':
                          email = value;
                          break;
                        case 'mobileNumber':
                          mobileNumber = value;
                          break;
                        case 'collegeName':
                          collegeName = value;
                          break;
                        case 'userType':
                          userType = value;
                          break;
                        default:
                          break;
                      }
                    });
                    Navigator.pop(context);
                  } catch (e) {
                    print('Error updating user data: $e');
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreenBody()),
            );
          },
        ),
        title: const Text('Configuracion de perfil'),
       
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where('uid', isEqualTo: auth.currentUser!.uid)
            .snapshots()
            .map((querySnapshot) => querySnapshot.docs.first),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!.data();
            var username = data['name'];
            var email = data['email'];
            var mobileNumber = data['mobileNumber'];
            var userType = data['userType'];

            return ListView(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text('Nombres'),
                  subtitle: Text(username ?? 'Loading...'),
                  onTap: () => _showEditDialog(
                      'nombres'), // Menampilkan dialog pengeditan saat item diklik
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Correo'),
                  subtitle: Text(email ?? 'Loading...'),
                  onTap: () => _showEditDialog('correo'),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('Numero celular'),
                  subtitle: Text(mobileNumber ?? 'Loading...'),
                  onTap: () => _showEditDialog('celular'),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Tipo de usuario'),
                  subtitle: Text(userType ?? 'Loading...'),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
