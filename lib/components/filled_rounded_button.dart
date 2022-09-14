import 'package:flutter/material.dart';

/// F I L L E D    R  O U N D E D  B U T T O N
/// An elevated button customised with rounded edges and solid background color for
/// use throughout the app.

class FilledRoundedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final Color color;
  // Used to distinguish between regular button designs and login button designs with different styling of FontFamily and FontSize
  final bool applyFont;
  const FilledRoundedButton(
      {Key? key,
        required this.buttonText,
        required this.onPressed,
        required this.color,
        this.applyFont = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SizedBox keeps consistency between all button uses
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height* 0.1,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return color.withOpacity(0.04);
              }
              if (states.contains(MaterialState.focused) ||
                  states.contains(MaterialState.pressed)) {
                return color.withOpacity(0.12);
              }
              return color;
            },
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            letterSpacing: 1.5,
            // Design differences implemented
            fontFamily: applyFont ? 'Montserrat' : null,
            fontWeight: FontWeight.bold,
            // Design differences implemented
            fontSize: applyFont ? 15 : MediaQuery.of(context).size.height / 35,
          ),
        ),
      ),
    );
  }
}
