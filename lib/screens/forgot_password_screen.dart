import 'package:flutter/material.dart';
import 'package:wine_app/firebase.dart';
import '../components/filled_rounded_button.dart';

///     F O R G O  T   P A S S W O R D   S C R E E N
///    - This is the screen the user sees when selecting "Forgot password".
///    - The user has to enter their registered email address in order for a successful email reset to be sent.
///    - Firebase handles the sending of the email en resetting of password.
///    - Once an email has been sent the ForgotPasswordScreen pops off and a
///    SnackBar message notifying the user of the sent email is shown.
///   - After successful password resetting, the user can log in with their existing email and new password.

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Allows for form validation
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // The visibility of error prompts are toggled using boolean variables
  bool _userNotFound = false;

  // Default values
  String _email = '';

  @override
  Widget build(BuildContext context) {
    // Universal input decoration with styling
    // TextFields are varied using the default styling .copWith their unique properties
    InputDecoration textFormFieldDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.white),
      ),
      hintStyle: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 18,
        color: Colors.grey.withOpacity(0.7),
      ),
    );

    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Builds App Logo
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/Wine_App_Logo.jpg',
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.1,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
                Padding(
                  // 10% padding on all sides
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.height * 0.09,
                        backgroundImage:
                            const AssetImage('assets/default_profile.jpg'),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      //Login Text
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Reset Password',
                          style: TextStyle(
                            // fontFamily: 'Montserrat',
                            fontSize: MediaQuery.of(context).size.height / 25,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      //Conditional text acts as error prompts
                      Visibility(
                        visible: _userNotFound,
                        child: Text(
                          'Email not registered, try signing up.',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Email form field
                      TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: textFormFieldDecoration.copyWith(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(
                                Icons.email,
                                color: Colors.grey,
                                size: 26,
                              ),
                            ),
                            hintText: 'E-mail'),
                        onChanged: (value) {
                          _email = value;
                        },
                        // Null check confirmed during validation
                        onSaved: (String? input) => _email = input!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter email';
                          } else {
                            // Regex to confirm a valid email address
                            bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value);
                            if (!emailValid) {
                              return 'Enter a valid email address';
                            } else {
                              // The return of null acts as a pass
                              return null;
                            }
                          }
                        },
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      // Login Button
                      _isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              height: 1.4 *
                                  (MediaQuery.of(context).size.height / 20),
                              width:
                                  6 * (MediaQuery.of(context).size.width / 10),
                              child: FilledRoundedButton(
                                buttonText: 'Send Email',
                                onPressed: _validateInputs,
                                color: Theme.of(context).colorScheme.secondary,
                                // Keep default flutter fonts
                                applyFont: false,
                              ),
                            ),
                      //Sign Up Text
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: 'Have an account?',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize:
                                    MediaQuery.of(context).size.height / 40,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: ' Login',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize:
                                    MediaQuery.of(context).size.height / 40,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ]),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validateInputs() {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState?.validate() != null) {
      final validForm = _formKey.currentState!.validate();
      if (validForm) {
        _formKey.currentState!.save();
        _passwordReset();
      }
    }
  }

  _passwordReset() async {
    setState(() {
      _userNotFound = false;
    });
    String? response =
        await FirebaseServices().resetUserPassword(_email, context);
    setState(() {
      _isLoading = false;
    });
    if (response == 'success') {
      Navigator.pop(context);
      // Show SnackBar to signify successful reset.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.all(20),
          content: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Email has been sent! Check your spam as well.',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: 'OpenSans',
                  fontSize: 15),
            ),
          ]),
        ),
      );
    } else if (response == 'user-not-found') {
      setState(() {
        _userNotFound = true;
      });
    }
  }
}
