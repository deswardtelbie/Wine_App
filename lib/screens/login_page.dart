import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wine_app/firebase.dart';
import 'package:wine_app/screens/forgot_password_screen.dart';

import '../components/filled_rounded_button.dart';

///     L O G I N   S C R E E N
///    - This is the screen the user sees when logging in. This screen will be bypassed if the user has an authentication
///    token stored from a previous login.
///    - Once the user submits an input, form validation is executed to check that all entered values are valid.
///    - After this, the http.dart file checks that the user is in fact registered on the app, prompting signing up
///      if the entered email address is not found.
///    - Prompts for incorrect password are also implemented.
///    - Once the user has successfully logged in, the user is redirected to the load up and home screen.

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  // Allows for form validation
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String _email = '';
  String _password = '';
  bool _obscurePassword = true;

  // The visibility of error prompts are toggled using boolean variables
  bool _userNotRegistered = false;
  bool _incorrectPassword = false;

  // Check for authentication token upon startup
  @override
  void initState() {
    super.initState();
    getToken();
  }

  // We check this at login to still have the login screen as the base root to pop back to upon logout
  void getToken() async {
    // Access app cache storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // If the token is not null and therefore the user is signed in.
    if (prefs.getString('auth_token') != null) {
      Navigator.of(context).pushNamed('/homeScreen');
    }
  }

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
                        'assets/Logo.png',
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
                          'Login',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      //Conditional text acts as error prompts
                      Visibility(
                        visible: _userNotRegistered,
                        child: Text(
                          'Email not registered, try signing up.',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      //Conditional text acts as error prompts
                      Visibility(
                        visible: _incorrectPassword,
                        child: Text(
                          'Invalid login details',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Email form field
                      TextFormField(
                        autocorrect: false,
                        //TODO: Remove initial values before launching
                        initialValue: 'testuser@wines.com',
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
                      const SizedBox(height: 13),
                      // Build password form field
                      TextFormField(
                        autocorrect: false,
                        //TODO: Remove initial values before launching
                        initialValue: 'ILoveWine123',
                        keyboardType: TextInputType.text,
                        obscureText: _obscurePassword,
                        decoration: textFormFieldDecoration.copyWith(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(
                                Icons.lock,
                                color: Colors.grey,
                                size: 26,
                              ),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 25),
                              child: IconButton(
                                icon: const FaIcon(FontAwesomeIcons.eye),
                                color: _obscurePassword
                                    ? Colors.grey
                                    : Theme.of(context).colorScheme.secondary,
                                iconSize: 23,
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            hintText: 'Password'),
                        onChanged: (value) {
                          _password = value;
                        },
                        // Null check confirmed during validation
                        onSaved: (String? input) => _password = input!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter password';
                          } else {
                            // The return of null acts as a pass
                            return null;
                          }
                          // No further validation for security purposes
                        },
                      ), //Forgot Password ButtonText
                      TextButton(
                        child: Text(
                          'Forgot your password?',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize:
                                  MediaQuery.of(context).size.height / 40,
                          fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen(),
                              ));
                        },
                      ),
                      const SizedBox(
                        height: 20,
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
                                buttonText: 'Sign in',
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
                              text: 'Don\'t have an account?',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize:
                                    MediaQuery.of(context).size.height / 40,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: ' Sign Up',
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
                          Navigator.pushNamed(context, '/signUp');
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
        _userLogin();
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  _userLogin() async {
    String? userAuthToken = await FirebaseServices()
        .userLogin(_email.trim(), _password.trim(), context);
    // Reset to false prior to checks.
    setState(() {
      _userNotRegistered = false;
      _incorrectPassword = false;
      _isLoading = false;
    });
    if (userAuthToken == 'not registered') {
      // If the user does not exist on the database
      // Notify user by changing the alert visibility
      setState(() {
        _userNotRegistered = true;
      });
    } else if (userAuthToken == null) {
      // A null _userAuthToken signifies incorrect login details
      setState(() {
        _incorrectPassword = true;
      });
    } else {
      // Store token on device for automatic future login
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', userAuthToken);
      //Navigate to loading screen
      Navigator.pushNamed(context, '/home');
    }
  }
}
