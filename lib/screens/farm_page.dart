import 'package:flutter/material.dart';
import 'package:wine_app/components/red_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FarmPage extends StatefulWidget {
  final String reference;

  const FarmPage({required this.reference, Key? key}) : super(key: key);

  @override
  State<FarmPage> createState() => _FarmPageState();
}

class _FarmPageState extends State<FarmPage> {
  late String farmName;
  late String description;
  late List<dynamic> differentiators;

  @override
  void initState() async {
    super.initState();
    await FirebaseFirestore.instance.doc(widget.reference).get().then((value) {
      farmName = value.data()!['name'];
      description = value.data()!['description'];
      differentiators = value.data()!['differentiators'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(
                  onPressed: () => Navigator.of(context).pop,
                  icon: Icon(Icons.arrow_back_ios,
                      color: Theme.of(context).colorScheme.primary, size: 30)),
              Text(
                farmName,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height / 15,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),
              ),
              CircleAvatar(
                radius: MediaQuery.of(context).size.height * 0.05,
                backgroundImage: const AssetImage('assets/wine_farm.jpg'),
              ),
            ]),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(15.0),
              color: Theme.of(context).colorScheme.primary,
              child: Row(children: [Text("")]),
            ),
            Text(
              description,
              style: TextStyle(
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "What makes us different?",
              style: TextStyle(
                  fontSize: 30,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            RedContainer(
              child: Column(
                  children: differentiators
                      .map((description) => ListTile(
                            leading: const Icon(Icons.arrow_forward_ios),
                            title: Text(
                              description.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ))
                      .toList()),
            ),
            const SizedBox(height: 10),
            Text(
              "Photos",
              style: TextStyle(
                  fontSize: 30,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            RedContainer(
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/wine_farm.jpg',
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.1,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
