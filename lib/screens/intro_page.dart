import 'package:flutter/material.dart';
import 'package:wine_app/components/filled_rounded_button.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/Wine_App_Logo.jpg',
              width: 130,
              height: 130,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 50,),
            FilledRoundedButton(buttonText: 'Social Media', onPressed: (){}, color: Theme.of(context).colorScheme.primary,),
            const SizedBox(height: 40,),
            FilledRoundedButton(buttonText: 'Website', onPressed: (){}, color: Theme.of(context).colorScheme.primary,),
            const SizedBox(height: 40,),
            FilledRoundedButton(buttonText: 'Store Location', onPressed: (){}, color: Theme.of(context).colorScheme.primary,),
          ],
        ),
      ),
    );
  }
}
