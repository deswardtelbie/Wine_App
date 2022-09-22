import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wine_app/components/red_container.dart';
import 'package:wine_app/screens/farm_page.dart';

class SpecialsScreen extends StatelessWidget {
  const SpecialsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Specials').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return _buildSpecialsItem(
                        context, snapshot.data!.docs[index]);
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    ));
  }

  Widget _buildSpecialsItem(context, DocumentSnapshot documentSnapshot) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            documentSnapshot['farmName'],
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 20,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () {
              print("Farm id");
              print(documentSnapshot['farmId'].toString());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FarmPage(
                      reference: "Farms/zrv1NTtrfax9wBPnJ12C"),
                ),
              );
            },
            child: RedContainer(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.height * 0.07,
                    backgroundImage: const AssetImage('assets/wine_farm.jpg'),
                  ),
                  const SizedBox(width: 40),
                  Flexible(
                      child: Text(
                    documentSnapshot['description'],
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                    textAlign: TextAlign.center,
                  )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
